//
//  GSScanView.m
//  jiaohangScanUI
//
//  Created by 刘高升 on 2017/9/26.
//  Copyright © 2017年 刘高升. All rights reserved.
//

#import "GSScanView.h"
//#import "CustomTitleView.h"

#define HiddenAnimationTime 0.5
#define HiddenEndingAnimationTime 0.5


@interface GSScanView()
{
    
    UIImageView *_baseBgImageView;
    UIView   *_topNavView;
    UIImageView *_navBgImageView;
    UIButton *_backBtn;
    UIButton *_flashlightBtn;
    UILabel  *_titleLable;

//    CustomTitleView *_titleBtn;
    
    UIImageView *_base_centerImageView;
    UIImageView *_centerImageView_circle;
    //中间UI
    UIImageView *_centerImageView_circle_out;
    
    UIImageView *_rotating_UpLeft_Within;
    UIImageView *_rotating_UpRight_Within;
    UIImageView *_rotating_downLeft_Within;
    UIImageView *_rotating_downRight_Within;
    //中心UI
    UIImageView *_centerImageView;
    
    //结束UI
    UIImageView *_endingImageView;
    
    UILabel *_noteLable;
    
    
    
}
@property (nonatomic , strong)NSMutableArray<UIImage *> *arrayM;

@end
@implementation GSScanView

- (NSMutableArray *)arrayM {
    if (!_arrayM) {
        _arrayM =  [NSMutableArray array];
    }
    return _arrayM;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initContentUI];
    

    }
    return self;
}

//初始化UI界面
- (void)initContentUI {
    self.backgroundColor = [UIColor clearColor];
    _baseBgImageView = [[UIImageView alloc]init];
    
    if (PNCisIPHONEX) {
        if (_navBgView == nil) {
            _navBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 72)];
            [self addSubview:_navBgView];
            _navBgView.backgroundColor = PNCColorWithHexA(0x000000, 0.6);
//            [UIColor colorWithHex:0x000000 alpha:0.6];
        }
        _baseBgImageView.frame = CGRectMake(0, 72, ScreenWidth, ScreenHeight - 145 -  40.5);
        _baseBgImageView.image = [UIImage imageNamed:@"bgXXXX"];

    }else{
        _baseBgImageView.image = [UIImage imageNamed:@"bg"];
        _baseBgImageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }
    [self addSubview:_baseBgImageView];
    _centerImageView_circle = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_circle"]];
    _centerImageView_circle.frame = CGRectMake(0, 0,   kAUTOWIDTH(_centerImageView_circle.frame.size.width),kAUTOHEIGHT(_centerImageView_circle.frame.size.height));
  
    _centerImageView_circle.center = self.center;
    [self addSubview:_centerImageView_circle];



    _topNavView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, kAUTOHEIGHT(95))];
    _topNavView.backgroundColor = [UIColor clearColor];
//    [self addSubview:_topNavView];

    _navBgImageView = [[UIImageView alloc]initWithFrame:_topNavView.bounds];
    _navBgImageView.image = [UIImage imageNamed:@"top"];
    _navBgImageView.userInteractionEnabled = YES;
    [_topNavView addSubview:_navBgImageView];


    _titleLable = [[UILabel alloc]initWithFrame:CGRectMake(_topNavView.center.x -   kAUTOWIDTH(80) / 2, 20,   kAUTOWIDTH(80), 40)];
    _titleLable.font = [UIFont systemFontOfSize:18];
    _titleLable.textAlignment = NSTextAlignmentCenter;
    _titleLable.textColor = [UIColor whiteColor];
    _titleLable.text = @"AR";
    [_topNavView addSubview:_titleLable];

    //返回按钮
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _backBtn.frame = CGRectMake(15, 35, 40, 20);
    [_backBtn setTitle:@"返回" forState:UIControlStateNormal];

    [_backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topNavView addSubview:_backBtn];

    //闪光灯
    _flashlightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_flashlightBtn setBackgroundImage:[UIImage imageNamed:@"icon-未开灯状态"] forState:UIControlStateNormal];
    _flashlightBtn.frame = CGRectMake(ScreenWidth - 15 -   kAUTOWIDTH(20), 35,   kAUTOWIDTH(20),   kAUTOWIDTH(20));
    [_flashlightBtn addTarget:self action:@selector(flashLightClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topNavView addSubview:_flashlightBtn];


    // 底下的黑色遮罩
    _barBgView = [[UIView alloc]initWithFrame:CGRectZero];
    if (PNCisIPHONEX) {
        _barBgView.frame = CGRectMake(0, ScreenHeight - 114, ScreenWidth, 114);
    }else{
        _barBgView.frame = CGRectMake(0, ScreenHeight - kAUTOHEIGHT(80), ScreenWidth, kAUTOHEIGHT(80));
    }
    _barBgView.backgroundColor = PNCColorWithHexA(0x000000, 0.8);
//    [UIColor colorWithHex:0x000000 alpha:0.8];
//    [self addSubview:_barBgView];

    //活动按钮
    
    
//    _titleBtn = [[NSBundle mainBundle]loadNibNamed:@"CustomTitleView" owner:nil options:nil].lastObject;
//    [_titleBtn originX:self.center.x  originY:CGRectGetMaxY(_topNavView.frame) + 10 content:@"视辰信息科技(上海)有限公司"];
//    [self addSubview:_titleBtn];



    //中间UI


    //外圈UI

    _centerImageView_circle_out = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"circle_out"]];
    _centerImageView_circle_out.frame = CGRectMake(0, 0,   kAUTOWIDTH(_centerImageView_circle_out.frame.size.width), kAUTOHEIGHT(_centerImageView_circle_out.frame.size.height));
    _centerImageView_circle_out.center = self.center;
    [self addSubview:_centerImageView_circle_out];


    //内圈UI
    _rotating_UpLeft_Within = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rotating_UpLeft_Within"]];
    _rotating_UpLeft_Within.frame = CGRectMake(0, 0,   kAUTOWIDTH(_rotating_UpLeft_Within.frame.size.width), kAUTOHEIGHT(_rotating_UpLeft_Within.frame.size.height) );
    _rotating_UpLeft_Within.center = self.center;
    [self addSubview:_rotating_UpLeft_Within];

    _rotating_UpRight_Within = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rotating_UpRight_Within"]];
    _rotating_UpRight_Within.frame = CGRectMake(0, 0,   kAUTOWIDTH(_rotating_UpRight_Within.frame.size.width), kAUTOHEIGHT(_rotating_UpRight_Within.frame.size.height));
    _rotating_UpRight_Within.center = self.center;
    [self addSubview:_rotating_UpRight_Within];

    _rotating_downLeft_Within = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rotating_downLeft_Within"]];
    _rotating_downLeft_Within.frame = CGRectMake(0, 0,   kAUTOWIDTH(_rotating_downLeft_Within.frame.size.width), kAUTOHEIGHT(_rotating_downLeft_Within.frame.size.height));
    _rotating_downLeft_Within.center = self.center;
    [self addSubview:_rotating_downLeft_Within];

    _rotating_downRight_Within = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rotating_downRight_Within"]];
    _rotating_downRight_Within.frame = CGRectMake(0, 0,   kAUTOWIDTH(_rotating_downRight_Within.frame.size.width), kAUTOHEIGHT(_rotating_downRight_Within.frame.size.height));
    _rotating_downRight_Within.center = self.center;
    [self addSubview:_rotating_downRight_Within];

    
    _noteLable = [[UILabel alloc]init];
    if (PNCisIPHONEX) {
        _noteLable.frame =CGRectMake(0, self.frame.size.height/2 + (_centerImageView_circle.frame.size.height)/2 + 39, ScreenWidth, 20);
    }else{
        _noteLable.frame = CGRectMake(0, self.frame.size.height/2 +(_centerImageView_circle.frame.size.height)/2 + kAUTOHEIGHT(39), ScreenWidth, 20);
    }
    _noteLable.textColor = [UIColor whiteColor];
    _noteLable.alpha = 0.6;
    _noteLable.textAlignment  = NSTextAlignmentCenter;
    _noteLable.font = [UIFont fontWithName:@"FZQKBYSJW--GB1-0" size:11                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             ];
    _noteLable.text = @"将扫描内容放入框内，点击拍摄开始识别";
    [self addSubview:_noteLable];

}


#pragma mark - ======开始旋转动画Animation=======
- (void)startRotationAnimation:(CALayer *)layer {

    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.95];
    rotationAnimation.toValue = [NSNumber numberWithFloat:1];
    rotationAnimation.duration = 0.5 ;
//    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE;
    rotationAnimation.autoreverses = YES;
    
    [layer addAnimation:rotationAnimation forKey:@"scaleAnimation"];


}
#pragma mark - ======开始心跳动画Animation=======
- (void)startHeartAnimation:(CALayer *)layer {
    CASpringAnimation *springAnimation = [CASpringAnimation animationWithKeyPath:@"transform.scale"];
    springAnimation.mass = 10.0;
    springAnimation.stiffness = 1200;
    springAnimation.damping = 2;
    springAnimation.initialVelocity = 0;
    springAnimation.duration = 5;
    springAnimation.fromValue = [NSNumber numberWithFloat:0.95];
    springAnimation.toValue = [NSNumber numberWithFloat:1];
    springAnimation.repeatCount = MAXFLOAT;
    springAnimation.autoreverses = YES;
    springAnimation.removedOnCompletion = NO;
    springAnimation.fillMode = kCAFillModeForwards;
    springAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [layer addAnimation:springAnimation forKey:@"springAnimation"];

}

#pragma mark - ======特殊心跳动画Animation=======

- (void)startSpringAnimation{
    
    __weak typeof(self) weakSelf  = self;
    
    [UIView animateWithDuration: 1 delay:0 usingSpringWithDamping:1 initialSpringVelocity: 0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        _centerImageView_circle_out.frame = CGRectMake(0, 0,   kAUTOWIDTH(_centerImageView_circle_out.frame.size.width)-  kAUTOWIDTH(25), kAUTOHEIGHT(_centerImageView_circle_out.frame.size.height)-kAUTOHEIGHT(25));
        _centerImageView_circle_out.center = weakSelf.center;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            _centerImageView_circle_out.frame = CGRectMake(0, 0,   kAUTOWIDTH(_centerImageView_circle_out.frame.size.width) +   kAUTOWIDTH(25), kAUTOHEIGHT(_centerImageView_circle_out.frame.size.height)+kAUTOHEIGHT(25));
            _centerImageView_circle_out.center = weakSelf.center;
        }];
        
        if (finished) {
            [weakSelf startSpringAnimation];
        }
    }];
}


- (void)startReverseRotationAnimation:(CALayer *)layer {
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.toValue = [NSNumber numberWithFloat:0] ;
    rotationAnimation.duration = 5.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE;
    
    [layer addAnimation:rotationAnimation forKey:@"ReverserotationAnimation"];
    
    
}



#pragma mark - ButtonClcik
- (void)backClick:(UIButton *)sender {
    !self.backBlock ? : self.backBlock();

}

- (void)flashLightClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_flashlightBtn setBackgroundImage:[UIImage imageNamed:@"icon-开灯状态"] forState:UIControlStateNormal];
    }else{
        [_flashlightBtn setBackgroundImage:[UIImage imageNamed:@"icon-未开灯状态"] forState:UIControlStateNormal];
    }

    !self.lightClickBlock ? : self.lightClickBlock();

}


#pragma mark - 序列帧动画
- (void)beginAnimationWithImageCount:(int)count imageName:(NSString *)imageName {
    
    // 如果当前的图片框正在执行一个动画, 那么不开启一个新的动画
    if (_centerImageView.isAnimating) return;
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"SequenceFrame" ofType:@"bundle"];
    NSString *path = [bundlePath stringByAppendingString:@"/SequenceFrameAnimation/"];
    
    // 1. 把要执行动画的图片设置UIImageView（图片框）
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < count; i++) {

        NSString *imgNamePath = [NSString stringWithFormat:@"%@%@%02d.png", path,imageName,i];
        

         UIImage *img = [UIImage imageWithContentsOfFile:imgNamePath];
        
        // 把图片对象添加到数组中
        [array addObject:img];
    }
    // 把要执行动画的图片设置给图片框
    _centerImageView.animationImages = array;
    
    
    // 2. 设置动画的持续时间
    _centerImageView.animationDuration = 1 / 30 * _centerImageView.animationImages.count;
    
    
    // 3. 设置动画的重复次数
    _centerImageView.animationRepeatCount = HUGE_VAL;
    
    
    // 4. 启动动画
    [_centerImageView startAnimating];
   
    
    
}

- (void)endingAnimationWithImageCount:(int)count imageName:(NSString *)imageName {
    
    // 如果当前的图片框正在执行一个动画, 那么不开启一个新的动画
    if (_endingImageView.isAnimating) return;
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"SequenceFrame" ofType:@"bundle"];
    NSString *path = [bundlePath stringByAppendingString:@"/EndAnimation/"];
    // 1. 把要执行动画的图片设置UIImageView（图片框）
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        
        NSString *imgNamePath = [NSString stringWithFormat:@"%@%@%02d.png", path,imageName,i];
        UIImage *img = [UIImage imageWithContentsOfFile:imgNamePath];
        
        // 把图片对象添加到数组中
        [array addObject:img];
    }
    // 把要执行动画的图片设置给图片框
    _endingImageView.animationImages = array;
    
    
    // 2. 设置动画的持续时间
    _endingImageView.animationDuration = HiddenEndingAnimationTime;
    
    
    // 3. 设置动画的重复次数
    _endingImageView.animationRepeatCount = 1;
    
    
    // 4. 启动动画
    [_endingImageView startAnimating];
    
   
    
}
- (void)stopCurrentAnimation {
    
    // 等待动画执行完毕后, 再清除内存
    _centerImageView_circle_out.hidden = YES;
    _rotating_UpLeft_Within.hidden = YES;
    _rotating_UpRight_Within.hidden = YES;
    _rotating_downLeft_Within.hidden = YES;
    _rotating_downRight_Within.hidden = YES;

    
    [_centerImageView_circle_out.layer removeAllAnimations];
    [_rotating_UpLeft_Within.layer removeAllAnimations];
    [_rotating_UpRight_Within.layer removeAllAnimations];
    [_rotating_downLeft_Within.layer removeAllAnimations];
    [_rotating_downRight_Within.layer removeAllAnimations];

    
}


#pragma mark ============扫描结束动画============
- (void)scanEndAnimation {
    _endingImageView.hidden = NO;
    [self endingAnimationWithImageCount:15 imageName:@"AR扫描_000"];
}
// 清除animationImages所占用内存
- (void)clearAinimationImageMemory {

    [_endingImageView stopAnimating];
    _endingImageView.animationImages = nil;
    [_endingImageView removeFromSuperview];
    _endingImageView = nil;
}
- (void)clearCenterAnimationImageMemory {
    
    [_centerImageView stopAnimating];
    _centerImageView.animationImages = nil;
    [_centerImageView removeFromSuperview];
    _centerImageView = nil;
}

- (void)stratScan {

    _baseBgImageView.hidden = NO;
    _topNavView.hidden = NO;
    _centerImageView_circle.hidden = NO;
//    _titleBtn.hidden = NO;
    _centerImageView_circle_out.hidden = NO;
    _rotating_UpLeft_Within.hidden = NO;
    _rotating_UpRight_Within.hidden = NO;
    _rotating_downLeft_Within.hidden = NO;
    _rotating_downRight_Within.hidden = NO;
    _noteLable.hidden = NO;
    _barBgView.hidden = NO;
    if (PNCisIPHONEX) {
        _navBgView.hidden = NO;
    }
    
    [UIView animateWithDuration:HiddenAnimationTime animations:^{
        _baseBgImageView.alpha = 1;
        _topNavView.alpha = 1;
        _centerImageView_circle.alpha = 1;
//        _titleBtn.alpha = 1;
        _noteLable.alpha = 0.6;
        _barBgView.alpha = 1;
        if (PNCisIPHONEX) {
            _navBgView.alpha = 1;
        }
    }];
    
    
    if (_centerImageView == nil) {
        //中心UI
        _centerImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"00000"]];
        _centerImageView.frame = CGRectMake(0, 0,   kAUTOWIDTH(_centerImageView.frame.size.width) , kAUTOHEIGHT(_centerImageView.frame.size.height));
        _centerImageView.center = self.center;
        [self addSubview:_centerImageView];
        

    }
    
    if (_endingImageView == nil) {
        
        //结束UI
        _endingImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AR扫描_00001"]];
        _endingImageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        _endingImageView.center = self.center;
        _endingImageView.hidden = YES;
        [self addSubview:_endingImageView];
    }
    
    if (PNCisIOS9Later) {
        //添加心跳动画
        [self startHeartAnimation:_centerImageView_circle_out.layer];
        
    }
    if (PNCisIOS8Later && !PNCisIOS9Later) {
        [UIView animateWithDuration:1 animations:^{
            _centerImageView_circle_out.frame = CGRectMake(0, 0,   kAUTOWIDTH(_centerImageView_circle_out.frame.size.width)+   kAUTOWIDTH(25), kAUTOHEIGHT(_centerImageView_circle_out.frame.size.height)+kAUTOHEIGHT(25));
            _centerImageView_circle_out.center = self.center;
        }];
        
        [self startSpringAnimation];
        
    }
 
   
    
    //添加反旋转动画
    [self startReverseRotationAnimation:_rotating_UpLeft_Within.layer];
    [self startReverseRotationAnimation:_rotating_UpRight_Within.layer];
    [self startReverseRotationAnimation:_rotating_downLeft_Within.layer];
    [self startReverseRotationAnimation:_rotating_downRight_Within.layer];
    
    //扩散动画
    [self beginAnimationWithImageCount:15 imageName:@"000" ];
   
}

#pragma mark ===== 隐藏动画=======

- (void)hiddenScan {
    
    [self stopCurrentAnimation];
    [self scanEndAnimation];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:HiddenAnimationTime animations:^{
                _baseBgImageView.alpha = 0;
                _topNavView.alpha = 0;
                _centerImageView_circle.alpha = 0;
        //        _titleBtn.alpha = 0;
                _noteLable.alpha = 0;
                _barBgView.alpha = 0;
        
                if (PNCisIPHONEX) {
                    _navBgView.alpha = 0;
                }
            } completion:^(BOOL finished) {
                _baseBgImageView.hidden = YES;
                _topNavView.hidden = YES;
                _centerImageView_circle.hidden = YES;
        //        _titleBtn.hidden = YES;
                _noteLable.hidden = YES;
                _barBgView.hidden = YES;
                if (PNCisIPHONEX) {
                    _navBgView.hidden = YES;
                }
                [self clearCenterAnimationImageMemory];
            }];
        
        
        
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((HiddenAnimationTime + HiddenEndingAnimationTime+2.5) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self clearAinimationImageMemory];
            });
        
        
            [self removeFromSuperview];
        
    });

    
}

//取消中心动画
- (void)stopCenterAnimation {
    _centerImageView.hidden = YES;
    [self clearCenterAnimationImageMemory];
}


@end
