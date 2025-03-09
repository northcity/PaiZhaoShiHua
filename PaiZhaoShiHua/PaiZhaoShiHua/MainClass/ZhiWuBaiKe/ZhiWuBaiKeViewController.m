//
//  ZhiWuBaiKeViewController.m
//  PaiZhaoShiHua
//
//  Created by 北城 on 2018/11/12.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import "ZhiWuBaiKeViewController.h"
#import <WebKit/WebKit.h>

@interface ZhiWuBaiKeViewController ()

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, strong) UILabel *customTitleLabel;
@property (nonatomic, strong) WKWebView *myWebView; // 自己的WebView属性引用
@property (nonatomic, strong) UIProgressView *customProgressView; // 自定义进度条

@end

@implementation ZhiWuBaiKeViewController

- (void)viewDidLoad {
    // 先调用父类的viewDidLoad，让父类创建webView等基础组件
    [super viewDidLoad];
    
    // 获取父类的webView引用
    [self findParentWebView];
    
    // 设置自定义UI
    [self setupCustomUI];
    
    // 加载URL
    [self loadBaikeContent];
}

- (void)findParentWebView {
    // 尝试通过KVC获取父类的webView
    // 这种方法不是很安全，但在无法修改父类的情况下是一种解决方案
    @try {
        self.myWebView = [self valueForKey:@"webView"];
        NSLog(@"成功获取父类webView: %@", self.myWebView);
    } @catch (NSException *exception) {
        NSLog(@"无法获取父类webView: %@", exception);
        
        // 如果KVC失败，遍历子视图找到WKWebView
        [self findWebViewInSubviews:self.view];
    }
}

- (void)findWebViewInSubviews:(UIView *)parentView {
    for (UIView *subview in parentView.subviews) {
        if ([subview isKindOfClass:[WKWebView class]]) {
            self.myWebView = (WKWebView *)subview;
            NSLog(@"在子视图中找到webView: %@", self.myWebView);
            return;
        }
        
        if ([subview isKindOfClass:[UIView class]] && subview.subviews.count > 0) {
            [self findWebViewInSubviews:subview];
            if (self.myWebView) return; // 如果找到了就停止递归
        }
    }
}

- (void)setupCustomUI {
    // 设置背景颜色 - 使用App通用浅紫色背景
    self.view.backgroundColor = [UIColor colorWithRed:0.98 green:0.96 blue:1.0 alpha:1.0];
    
    // 创建自定义头部
    [self setupHeaderView];
    
    // 调整父类webView的位置和样式
    [self adjustWebViewStyle];
    
    // 隐藏导航栏，使用自定义标题栏
    if (self.navigationController) {
        self.navigationController.navigationBar.hidden = YES;
    }
    
    // 尝试隐藏父类的progressView - 如果能找到的话
    @try {
        UIProgressView *parentProgressView = [self valueForKey:@"progressView"];
        if (parentProgressView) {
            parentProgressView.hidden = YES;
        }
    } @catch (NSException *exception) {
        NSLog(@"无法访问父类progressView: %@", exception);
    }
}

- (void)setupHeaderView {
    // 创建头部容器视图
    self.headerView = [[UIView alloc] init];
    self.headerView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]; // 白色背景
    self.headerView.layer.cornerRadius = 16;
    self.headerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.headerView.layer.shadowOpacity = 0.08;
    self.headerView.layer.shadowOffset = CGSizeMake(0, 2);
    self.headerView.layer.shadowRadius = 8;
    [self.view addSubview:self.headerView];
    
    // 计算头部位置
    CGFloat statusBarHeight = 0;
    if (@available(iOS 13.0, *)) {
        UIWindowScene *windowScene = UIApplication.sharedApplication.connectedScenes.allObjects.firstObject;
        statusBarHeight = windowScene.statusBarManager.statusBarFrame.size.height;
    } else {
        statusBarHeight = UIApplication.sharedApplication.statusBarFrame.size.height;
    }
    
    CGFloat topInset = statusBarHeight + 8;
    CGFloat headerHeight = 60;
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    
    self.headerView.frame = CGRectMake(16, topInset, screenWidth - 32, headerHeight);
    
    // 创建关闭按钮
    self.closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.closeButton setImage:[UIImage systemImageNamed:@"xmark.circle.fill"] forState:UIControlStateNormal];
    self.closeButton.tintColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.7 alpha:0.7]; // 粉色
    [self.closeButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.closeButton];
    
    // 设置关闭按钮位置
    self.closeButton.frame = CGRectMake(16, (headerHeight - 30) / 2, 30, 30);
    
    // 创建标题标签
    self.customTitleLabel = [[UILabel alloc] init];
    self.customTitleLabel.text = @"百科详情";
    self.customTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.customTitleLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.4 alpha:1.0]; // 深紫色
    
    // 尝试使用Chalkboard SE字体
    UIFont *customFont = [UIFont fontWithName:@"Chalkboard SE" size:18];
    if (customFont) {
        self.customTitleLabel.font = customFont;
    } else {
        self.customTitleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    }
    
    [self.headerView addSubview:self.customTitleLabel];
    
    // 设置标题标签位置
    self.customTitleLabel.frame = CGRectMake(60, 0, screenWidth - 32 - 120, headerHeight);
    
    // 创建刷新按钮
    self.refreshButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.refreshButton setImage:[UIImage systemImageNamed:@"arrow.clockwise"] forState:UIControlStateNormal];
    self.refreshButton.tintColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.7 alpha:0.7]; // 粉色
    [self.refreshButton addTarget:self action:@selector(refreshButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.refreshButton];
    
    // 设置刷新按钮位置
    self.refreshButton.frame = CGRectMake(screenWidth - 32 - 46, (headerHeight - 30) / 2, 30, 30);
}

- (void)adjustWebViewStyle {
    // 调整父类webView的位置和样式
    if (self.myWebView) {
        // 计算位置
        CGFloat headerBottom = CGRectGetMaxY(self.headerView.frame);
        CGFloat webViewTop = headerBottom + 16;
        CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;
        CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
        CGFloat bottomInset = 16;
        
        if (@available(iOS 11.0, *)) {
            UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
            bottomInset += window.safeAreaInsets.bottom;
        }
        
        // 设置webView位置
        self.myWebView.frame = CGRectMake(16, webViewTop, screenWidth - 32, screenHeight - webViewTop - bottomInset);
        
        // 美化webView
        self.myWebView.backgroundColor = [UIColor colorWithRed:0.98 green:0.96 blue:1.0 alpha:1.0]; // 浅紫色背景
        self.myWebView.layer.cornerRadius = 16;
        self.myWebView.layer.masksToBounds = YES;
        
        // 确保WebView在最上层
        [self.view bringSubviewToFront:self.myWebView];
        
        // 添加自定义进度条
        [self addCustomProgressBar];
    } else {
        NSLog(@"无法找到WebView，无法调整样式");
    }
}

- (void)addCustomProgressBar {
    // 创建自定义进度条
    self.customProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.customProgressView.progressTintColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.7 alpha:1.0]; // 粉色
    self.customProgressView.trackTintColor = [UIColor colorWithWhite:0.9 alpha:0.5];
    self.customProgressView.transform = CGAffineTransformMakeScale(1.0, 0.5);
    
    // 确保设置了正确的frame
    if (self.myWebView) {
        self.customProgressView.frame = CGRectMake(0, 0, self.myWebView.frame.size.width, 2);
        [self.myWebView addSubview:self.customProgressView];
        
        // 更新进度值
        [self.customProgressView setProgress:self.myWebView.estimatedProgress animated:NO];
        
        // 创建一个定时器来更新进度条
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateCustomProgress:) userInfo:nil repeats:YES];
        [timer fire];
    }
}

- (void)updateCustomProgress:(NSTimer *)timer {
    if (!self.myWebView || !self.customProgressView) {
        [timer invalidate];
        return;
    }
    
    [self.customProgressView setProgress:self.myWebView.estimatedProgress animated:YES];
    
    // 当进度完成时停止定时器并隐藏进度条
    if (self.myWebView.estimatedProgress >= 1.0) {
        [timer invalidate];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                self.customProgressView.alpha = 0.0;
            }];
        });
    }
}

- (void)loadBaikeContent {
    // 构建URL
    if (self.urlstring.length > 0) {
        self.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://baike.baidu.com/item/",self.urlstring]];
        self.customTitleLabel.text = [NSString stringWithFormat:@"%@ - 百科", self.urlstring];
    } else {
        self.url = [NSURL URLWithString:@"https://baike.baidu.com"];
        self.customTitleLabel.text = @"百度百科";
    }
}

#pragma mark - 按钮事件

- (void)closeButtonTapped {
    // 添加轻微的弹性动画
    [UIView animateWithDuration:0.1 animations:^{
        self.closeButton.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.closeButton.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }];
}

- (void)refreshButtonTapped {
    // 添加轻微的旋转动画
    [UIView animateWithDuration:0.3 animations:^{
        self.refreshButton.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.refreshButton.transform = CGAffineTransformIdentity;
        }];
    }];
    
    // 刷新网页
    if (self.myWebView) {
        [self.myWebView reload];
    }
}

#pragma mark - 覆盖父类的方法

// 页面加载完毕时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
//    [super webView:webView didFinishNavigation:navigation];
    
    // 网页加载完成后，尝试提取标题
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if ([result isKindOfClass:[NSString class]] && [result length] > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.customTitleLabel.text = result;
            });
        }
    }];
}

// 覆盖KVO处理，使用我们自己的UI
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // 先调用super的方法，让父类处理，确保父类功能正常
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    // 然后处理我们自己的UI更新
    if ([keyPath isEqualToString:@"estimatedProgress"] && object == self.myWebView) {
        // 可以在这里更新我们自己的进度条，但目前我们使用定时器
    } else if ([keyPath isEqualToString:@"title"] && object == self.myWebView) {
        // 使用自定义标题标签
        if (self.myWebView.title.length > 0) {
            self.customTitleLabel.text = self.myWebView.title;
        }
    }
}

#pragma mark - 生命周期

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController) {
        self.navigationController.navigationBar.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

@end
