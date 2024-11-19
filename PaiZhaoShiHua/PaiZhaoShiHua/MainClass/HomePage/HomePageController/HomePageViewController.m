//
//  HomePageViewController.m
//  PaiZhaoShiHua
//
//  Created by 北城 on 2018/10/24.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import "HomePageViewController.h"
#import "SearchViewController.h"
#import "ListModel.h"
#import "AxcDrawPath.h"
#import "CellDrawView.h"
#import "SettingViewController.h"
#import "MyFllowViewController.h"
#import "ZhiWuBaiKeViewController.h"
#import "ShiBieHuaViewController.h"
#import <StoreKit/StoreKit.h>
#import <MessageUI/MessageUI.h>


@interface HomePageViewController ()<UITextFieldDelegate,MFMailComposeViewControllerDelegate>

@property (nonatomic,strong)UILabel *navTitleLabel;
@property (nonatomic,strong)UITextField *searchTextField;
@property (nonatomic,strong)UIView *searchView;
@property (nonatomic,strong)UIImageView *searchIcon;

@property (nonatomic,strong)UIView *paiView;
@property (nonatomic,strong)UIView *baiKeView;
@property (nonatomic,strong)UIView *myFllowView;
@property (nonatomic,strong)UIView *setView;

@property (nonatomic,strong)UILabel *zhiChiLabel;

@property (nonatomic,strong)UIButton *dianZanButton;
@property (nonatomic,strong)UIButton *fenXiangButton;
@property (nonatomic,strong)UIButton *fanKuiButton;

@property(nonatomic , strong)NSMutableArray <ListModel *>*dataListArray;
@property (strong, nonatomic) CellDrawView *drawView;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = PNCColor(254, 254, 254);
    self.navigationController.navigationBar.hidden = YES;

    [self createSubViews];
    [self createPaiSubView];
    [self createGesture];
}

- (void)createGesture{
    
    UITapGestureRecognizer * shiBieTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shiBieTapClick)];
    [_paiView addGestureRecognizer:shiBieTap];
    
    UITapGestureRecognizer * baiKeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(baiKeTapClick)];
    [_baiKeView addGestureRecognizer:baiKeTap];
    
    UITapGestureRecognizer * fllowTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fllowTapClick)];
    [_myFllowView addGestureRecognizer:fllowTap];
    
    UITapGestureRecognizer * setTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setTapClick)];
    [_setView addGestureRecognizer:setTap];
}

-(void)shiBieTapClick{
    ShiBieHuaViewController *set = [[ShiBieHuaViewController alloc]init];
    [self.navigationController pushViewController:set animated:YES];
}

-(void)baiKeTapClick{
    ZhiWuBaiKeViewController *set = [[ZhiWuBaiKeViewController alloc]init];
    [self.navigationController pushViewController:set animated:YES];
}


-(void)fllowTapClick{
    MyFllowViewController *set = [[MyFllowViewController alloc]init];
    [self.navigationController pushViewController:set animated:YES];
}

-(void)setTapClick{
    SettingViewController *set = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:set animated:YES];
}

- (void)createPaiSubView{
    
    _paiView = [[UIView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(20), CGRectGetMaxY(_searchView.frame) + kAUTOHEIGHT(30), (ScreenWidth - kAUTOWIDTH(60))/2, (ScreenWidth - kAUTOWIDTH(60))/2 + kAUTOHEIGHT(20))];
    _paiView.layer.cornerRadius = kAUTOWIDTH(7);
    _paiView.layer.shadowColor = PNCColorWithHex(0x707070).CGColor;
    _paiView.layer.shadowOffset = CGSizeMake(0, 0);
    _paiView.layer.shadowRadius = kAUTOWIDTH(7);
    _paiView.layer.shadowOpacity = 0.1;
    [self.view addSubview:_paiView];
    _paiView.backgroundColor = PNCColor(255, 255, 255);
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.paiView.frame;
    gradientLayer.colors = @[(id)PNCColorWithHex(0xee9ca7).CGColor, (id)PNCColorWithHex(0xffdde1).CGColor];
    gradientLayer.locations = @[@(0),@(1)];
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    gradientLayer.cornerRadius = kAUTOWIDTH(7);
    [self.view.layer insertSublayer:gradientLayer below:self.paiView.layer];
    
    CALayer *subLayer=[CALayer layer];
    CGRect fixframe=CGRectMake(kAUTOWIDTH(30), CGRectGetMaxY(_searchView.frame) + kAUTOHEIGHT(30) + (ScreenWidth - kAUTOWIDTH(60))/2 + kAUTOHEIGHT(20) - kAUTOWIDTH(40), (ScreenWidth - kAUTOWIDTH(60))/2 - kAUTOWIDTH(20), kAUTOHEIGHT(30));
    subLayer.frame = fixframe;
    subLayer.cornerRadius = kAUTOWIDTH(7);
    subLayer.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    subLayer.masksToBounds=NO;
    subLayer.shadowColor = PNCColorWithHex(0x8A7FF7).CGColor;
    subLayer.shadowOffset= CGSizeMake(0,5);
    subLayer.shadowOpacity= 0.9f;
    subLayer.shadowRadius= 16;
    [self.view.layer insertSublayer:subLayer below:gradientLayer];
    
    UIImageView *paibackImageView = [[UIImageView alloc]initWithFrame:_paiView.bounds];
    paibackImageView.image = [UIImage imageNamed:@"paibg5"];
    paibackImageView.contentMode = UIViewContentModeScaleAspectFill;
    paibackImageView.layer.cornerRadius = kAUTOHEIGHT(8);
    paibackImageView.clipsToBounds = YES;
//    [_paiView addSubview:paibackImageView];
    
    UIImageView *paiImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(20), kAUTOHEIGHT(20), kAUTOWIDTH(40), kAUTOWIDTH(40))];
    paiImageView.image = [UIImage imageNamed:@"相机"];
    [_paiView addSubview:paiImageView];
    
    UILabel *paiLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(10), _paiView.frame.size.height - kAUTOHEIGHT(48), _paiView.frame.size.width, kAUTOHEIGHT(22))];
    paiLabel.text = @"拍照识花";
    paiLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    paiLabel.textColor = [UIColor blackColor];
    paiLabel.textAlignment = NSTextAlignmentLeft;
    [self.paiView addSubview:paiLabel];
    
    UILabel *paiShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(10),CGRectGetMaxY(paiLabel.frame), _paiView.frame.size.width, kAUTOHEIGHT(13))];
    paiShowLabel.text = @"拍摄照片一键识别种类";
    paiShowLabel.font = [UIFont fontWithName:@"HeiTi SC" size:10];
    paiShowLabel.textColor = [UIColor grayColor];
    paiShowLabel.textAlignment = NSTextAlignmentLeft;
    [self.paiView addSubview:paiShowLabel];
    
    
    
    CGFloat height = _paiView.frame.size.height/2;
    CGFloat width = _paiView.frame.size.width/2;
    ///圆内切多边形
    CGPoint arcCenter = CGPointMake(width/2 +10, height/2 +10);
    CGFloat arcRadius = width/2 - 10;
    // 辐射圆形
    NSMutableArray *lineHeights = @[].mutableCopy;
    for (int i = 0; i < 50; i ++) [lineHeights addObject:@(arc4random()%30 + 5)];
    [self.dataListArray addObject:[ListModel title:@"辐射圆形绘制 - 辐射圆形示例"
                                          disTitle:@"常规的辐射圆形绘制，需要传入一个高度数组进行运算绘制"
                                              path:[AxcDrawPath AxcDrawCircularRadiationCenter:arcCenter    // 圆心
                                                                                        radius:arcRadius/2        // 半径
                                                                                   lineHeights:lineHeights]]];   // 每条线长度
    
    ListModel *model = [self.dataListArray firstObject];
    [self setModel:model];
    
    self.drawView.frame = CGRectMake(30, 30, width, height);
    
    

    
    
    
    
    
    
    
    
    
    
    _baiKeView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/2 + kAUTOWIDTH(10), CGRectGetMaxY(_searchView.frame) + kAUTOHEIGHT(30), (ScreenWidth - kAUTOWIDTH(60))/2, (ScreenWidth - kAUTOWIDTH(60))/2 + kAUTOHEIGHT(20))];
    _baiKeView.layer.cornerRadius = kAUTOHEIGHT(8);
    [self.view addSubview:_baiKeView];
    _baiKeView.backgroundColor = PNCColor(255, 255, 245);
    
    CAGradientLayer *baiKeGradientLayer = [CAGradientLayer layer];
    baiKeGradientLayer.frame = self.baiKeView.frame;
    baiKeGradientLayer.colors = @[(id)PNCColorWithHex(0xee9ca7).CGColor, (id)PNCColorWithHex(0xffdde1).CGColor];
    baiKeGradientLayer.locations = @[@(0),@(1)];
    baiKeGradientLayer.startPoint = CGPointMake(0, 0.5);
    baiKeGradientLayer.endPoint = CGPointMake(1, 0.5);
    baiKeGradientLayer.cornerRadius = kAUTOHEIGHT(7);
    [self.view.layer insertSublayer:baiKeGradientLayer below:self.baiKeView.layer];
    
    CALayer *baiKeSubLayer=[CALayer layer];
    CGRect baiKefixframe=_baiKeView.layer.frame;
    baiKeSubLayer.frame = baiKefixframe;
    baiKeSubLayer.cornerRadius = kAUTOHEIGHT(8);
    baiKeSubLayer.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    baiKeSubLayer.masksToBounds=NO;
    baiKeSubLayer.shadowColor=[UIColor grayColor].CGColor;
    baiKeSubLayer.shadowOffset=CGSizeMake(0,5);
    baiKeSubLayer.shadowOpacity=1.0f;
    baiKeSubLayer.shadowRadius= 15;
    [self.view.layer insertSublayer:baiKeSubLayer below:baiKeGradientLayer];
    
    UIImageView *baiKebackImageView = [[UIImageView alloc]initWithFrame:_baiKeView.bounds];
    baiKebackImageView.image = [UIImage imageNamed:@"paibg5"];
    baiKebackImageView.contentMode = UIViewContentModeScaleAspectFill;
    baiKebackImageView.layer.cornerRadius = kAUTOHEIGHT(8);
    baiKebackImageView.clipsToBounds = YES;
    //    [_paiView addSubview:paibackImageView];
    
    UIImageView *baiKeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(20), kAUTOHEIGHT(20), kAUTOWIDTH(40), kAUTOWIDTH(40))];
    baiKeImageView.image = [UIImage imageNamed:@"flower1"];
    [_baiKeView addSubview:baiKeImageView];
    
    UILabel *baiKeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(10), _paiView.frame.size.height - kAUTOHEIGHT(48), _paiView.frame.size.width, kAUTOHEIGHT(22))];
    baiKeLabel.text = @"植物百科";
    baiKeLabel.font = [UIFont fontWithName:@"PingFangHK-Semibold" size:15];
    baiKeLabel.textColor = [UIColor blackColor];
    baiKeLabel.textAlignment = NSTextAlignmentLeft;
    [self.baiKeView addSubview:baiKeLabel];
    
    UILabel *baiKeShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(10),CGRectGetMaxY(paiLabel.frame), _paiView.frame.size.width, kAUTOHEIGHT(13))];
    baiKeShowLabel.text = @"专业植物百科全书";
    baiKeShowLabel.font = [UIFont fontWithName:@"HeiTi SC" size:10];
    baiKeShowLabel.textColor = [UIColor grayColor];
    baiKeShowLabel.textAlignment = NSTextAlignmentLeft;
    [self.baiKeView addSubview:baiKeShowLabel];
    
    
    
    
    
    
    
    
    _myFllowView = [[UIView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(20), CGRectGetMaxY(_paiView.frame) + kAUTOHEIGHT(20), (ScreenWidth - kAUTOWIDTH(60))/2, (ScreenWidth - kAUTOWIDTH(60))/2 + kAUTOHEIGHT(20))];
    _myFllowView.layer.cornerRadius = kAUTOHEIGHT(7);
    [self.view addSubview:_myFllowView];
    _myFllowView.backgroundColor = PNCColor(255, 255, 245);
    
    
    CAGradientLayer *myFllowGradientLayer = [CAGradientLayer layer];
    myFllowGradientLayer.frame = self.myFllowView.frame;
    myFllowGradientLayer.colors = @[(id)PNCColorWithHex(0xee9ca7).CGColor, (id)PNCColorWithHex(0xffdde1).CGColor];
    myFllowGradientLayer.locations = @[@(0),@(1)];
    myFllowGradientLayer.startPoint = CGPointMake(0, 0.5);
    myFllowGradientLayer.endPoint = CGPointMake(1, 0.5);
    myFllowGradientLayer.cornerRadius = kAUTOHEIGHT(7);
    [self.view.layer insertSublayer:myFllowGradientLayer below:self.myFllowView.layer];
    
    CALayer *fllowSubLayer=[CALayer layer];
    CGRect fllowfixframe=_myFllowView.layer.frame;
    fllowSubLayer.frame = fllowfixframe;
    fllowSubLayer.cornerRadius = kAUTOHEIGHT(8);
    fllowSubLayer.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    fllowSubLayer.masksToBounds=NO;
    fllowSubLayer.shadowColor=[UIColor grayColor].CGColor;
    fllowSubLayer.shadowOffset=CGSizeMake(0,5);
    fllowSubLayer.shadowOpacity=1.0f;
    fllowSubLayer.shadowRadius= 15;
    [self.view.layer insertSublayer:fllowSubLayer below:myFllowGradientLayer];
    
    UIImageView *fllowbackImageView = [[UIImageView alloc]initWithFrame:_myFllowView.bounds];
    fllowbackImageView.image = [UIImage imageNamed:@"paibg5"];
    fllowbackImageView.contentMode = UIViewContentModeScaleAspectFill;
    fllowbackImageView.layer.cornerRadius = kAUTOHEIGHT(8);
    fllowbackImageView.clipsToBounds = YES;
    //    [_paiView addSubview:fllowbackImageView];
    
    UIImageView *fllowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(20), kAUTOHEIGHT(20), kAUTOWIDTH(40), kAUTOWIDTH(40))];
    fllowImageView.image = [UIImage imageNamed:@"优惠券"];
    [_myFllowView addSubview:fllowImageView];
    
    UILabel *fllowLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(10), _paiView.frame.size.height - kAUTOHEIGHT(48), _paiView.frame.size.width, kAUTOHEIGHT(22))];
    fllowLabel.text = @"我的记录";
    fllowLabel.font = [UIFont fontWithName:@"PingFangHK-Semibold" size:15];
    fllowLabel.textColor = [UIColor blackColor];
    fllowLabel.textAlignment = NSTextAlignmentLeft;
    [_myFllowView addSubview:fllowLabel];
    
    UILabel *fllowShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(10),CGRectGetMaxY(paiLabel.frame), _paiView.frame.size.width, kAUTOHEIGHT(13))];
    fllowShowLabel.text = @"记录你的每一次查看与识别";
    fllowShowLabel.font = [UIFont fontWithName:@"HeiTi SC" size:10];
    fllowShowLabel.textColor = [UIColor grayColor];
    fllowShowLabel.textAlignment = NSTextAlignmentLeft;
    [self.myFllowView addSubview:fllowShowLabel];
    
    
    
    
    
    
    _setView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/2 + kAUTOWIDTH(10), CGRectGetMaxY(_baiKeView.frame) + kAUTOHEIGHT(20), (ScreenWidth - kAUTOWIDTH(60))/2, (ScreenWidth - kAUTOWIDTH(60))/2 + kAUTOHEIGHT(20))];
    _setView.layer.cornerRadius = kAUTOHEIGHT(8);
    [self.view addSubview:_setView];
    _setView.backgroundColor = PNCColor(255, 255, 245);
    
    
    CAGradientLayer *setGradientLayer = [CAGradientLayer layer];
    setGradientLayer.frame = self.setView.frame;
    setGradientLayer.colors = @[(id)PNCColorWithHex(0xee9ca7).CGColor, (id)PNCColorWithHex(0xffdde1).CGColor];
    setGradientLayer.locations = @[@(0),@(1)];
    setGradientLayer.startPoint = CGPointMake(0, 0.5);
    setGradientLayer.endPoint = CGPointMake(1, 0.5);
    setGradientLayer.cornerRadius = kAUTOHEIGHT(7);
    [self.view.layer insertSublayer:setGradientLayer below:self.setView.layer];
    
    CALayer *setSubLayer=[CALayer layer];
    CGRect setfixframe=_setView.layer.frame;
    setSubLayer.frame = setfixframe;
    setSubLayer.cornerRadius = kAUTOHEIGHT(8);
    setSubLayer.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    setSubLayer.masksToBounds=NO;
    setSubLayer.shadowColor=[UIColor grayColor].CGColor;
    setSubLayer.shadowOffset=CGSizeMake(0,5);
    setSubLayer.shadowOpacity=1.0f;
    setSubLayer.shadowRadius= 15;
    [self.view.layer insertSublayer:setSubLayer below:setGradientLayer];
    
    UIImageView *setbackImageView = [[UIImageView alloc]initWithFrame:_myFllowView.bounds];
    setbackImageView.image = [UIImage imageNamed:@"paibg5"];
    setbackImageView.contentMode = UIViewContentModeScaleAspectFill;
    setbackImageView.layer.cornerRadius = kAUTOHEIGHT(8);
    setbackImageView.clipsToBounds = YES;
    //    [_paiView addSubview:fllowbackImageView];
    
    UIImageView *setImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(20), kAUTOHEIGHT(20), kAUTOWIDTH(40), kAUTOWIDTH(40))];
    setImageView.image = [UIImage imageNamed:@"设置"];
    [_setView addSubview:setImageView];
    
    UILabel *setLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(10), _paiView.frame.size.height - kAUTOHEIGHT(48), _paiView.frame.size.width, kAUTOHEIGHT(22))];
    setLabel.text = @"系统设置";
    setLabel.font = [UIFont fontWithName:@"PingFangHK-Semibold" size:15];
    setLabel.textColor = [UIColor blackColor];
    setLabel.textAlignment = NSTextAlignmentLeft;
    [_setView addSubview:setLabel];
    
    UILabel *setShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(10),CGRectGetMaxY(paiLabel.frame), _paiView.frame.size.width, kAUTOHEIGHT(13))];
    setShowLabel.text = @"支持我们一下吧";
    setShowLabel.font = [UIFont fontWithName:@"HeiTi SC" size:10];
    setShowLabel.textColor = [UIColor grayColor];
    setShowLabel.textAlignment = NSTextAlignmentLeft;
    [self.setView addSubview:setShowLabel];
    
    
    
    
    
    
    
    
    
    _zhiChiLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(20), CGRectGetMaxY(_myFllowView.frame) +kAUTOHEIGHT(30), ScreenWidth - kAUTOWIDTH(40), kAUTOHEIGHT(40))];
    _zhiChiLabel.text = @"支持我一下";
    _zhiChiLabel.font = [UIFont fontWithName:@"HeiTi SC" size:13];
    _zhiChiLabel.textColor = [UIColor grayColor];
    [self.view addSubview:_zhiChiLabel];
    
    _dianZanButton = [[UIButton alloc]initWithFrame:CGRectMake(kAUTOWIDTH(20), CGRectGetMaxY(_zhiChiLabel.frame) + kAUTOHEIGHT(10), kAUTOWIDTH(25), kAUTOHEIGHT(25))];
    [_dianZanButton setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateNormal];
    [_dianZanButton addTarget:self action:@selector(dianZanClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_dianZanButton];
    
    _fenXiangButton= [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_dianZanButton.frame) + kAUTOWIDTH(20), CGRectGetMaxY(_zhiChiLabel.frame) + kAUTOHEIGHT(10), kAUTOWIDTH(25), kAUTOHEIGHT(25))];
    [_fenXiangButton setImage:[UIImage imageNamed:@"发送"] forState:UIControlStateNormal];
    [_fenXiangButton addTarget:self action:@selector(dianZanClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_fenXiangButton];
    
    _fanKuiButton= [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_fenXiangButton.frame) +kAUTOWIDTH(20), CGRectGetMaxY(_zhiChiLabel.frame) + kAUTOHEIGHT(10), kAUTOWIDTH(25), kAUTOHEIGHT(25))];
    [_fanKuiButton setImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
    [_fanKuiButton addTarget:self action:@selector(fanKuiClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_fanKuiButton];
    
}

- (void)dianZanClick{
    NSString *itunesurl = @"itms-apps://itunes.apple.com/cn/app/id1439881374?mt=8&action=write-review";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itunesurl]];
}

-(void)fanKuiClick{
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    if (!controller) {
        // 在设备还没有添加邮件账户的时候mailViewController为空，下面的present view controller会导致程序崩溃，这里要作出判断
        NSLog(@"设备还没有添加邮件账户");
    }else{
        controller.mailComposeDelegate = self;
        [controller setSubject:@"拍照识花(iOS版)反馈"];
        NSString * device = [[UIDevice currentDevice] model];
        NSString * ios = [[UIDevice currentDevice] systemVersion];
        NSString *body = [NSString stringWithFormat:@"请留下您的宝贵建议和意见：\n\n\n以下信息有助于我们确认您的问题，建议保留。\nDevice: %@\nOS Version: %@\n", device, ios];
        [controller setMessageBody:body isHTML:NO];
        NSArray *toRecipients = [NSArray arrayWithObject:@"506343891@qq.com"];
        [controller setToRecipients:toRecipients];
        
        [self presentViewController:controller animated:YES completion:nil];
        
    }
}

- (void)createSubViews{
    _navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(30), kAUTOHEIGHT(30), ScreenWidth - kAUTOWIDTH(60), kAUTOHEIGHT(66))];
    _navTitleLabel.text = @"拍照识花";
//    FZXS12--GB1-0  FZQKBYSJW--GB1-0
    _navTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:kAUTOWIDTH(20)];
    _navTitleLabel.textColor = PNCColorWithHex(0x1e1e1e);
    _navTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_navTitleLabel];
    
    _searchView = [[UIView alloc] initWithFrame:CGRectMake(kAUTOWIDTH(20), CGRectGetMaxY(_navTitleLabel.frame) + kAUTOHEIGHT(7), ScreenWidth - kAUTOWIDTH(40), kAUTOHEIGHT(30))];
    _searchView.backgroundColor = [UIColor whiteColor];
    _searchView.layer.cornerRadius = kAUTOHEIGHT(15);
    _searchView.layer.masksToBounds = YES;
    [self.view addSubview:_searchView];
    
    _searchIcon = [[UIImageView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(5), kAUTOHEIGHT(5), kAUTOWIDTH(20), kAUTOHEIGHT(20))];
    _searchIcon.image = [UIImage imageNamed:@"搜索1"];
    [_searchView addSubview:_searchIcon];
    
    _searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_searchIcon.frame) + kAUTOWIDTH(5),0,  ScreenWidth - kAUTOWIDTH(60), kAUTOHEIGHT(30))];
    _searchTextField.placeholder = @"输入你要了解的花的名称";
    _searchTextField.font = [UIFont fontWithName:@"FZQKBYSJW--GB1-0" size:13];
    _searchTextField.returnKeyType = UIReturnKeySearch;
    _searchTextField.delegate = self;
    [_searchView addSubview:_searchTextField];
//    [_searchTextField setValue:PNCColorWithHex(0x666666) forKeyPath:@"_placeholderLabel.textColor"];
//    [_searchTextField setValue:[UIFont fontWithName:@"FZQKBYSJW--GB1-0" size:13] forKeyPath:@"_placeholderLabel.font"];
    

    if (PNCisIPHONEX) {
        _navTitleLabel.frame = CGRectMake(kAUTOWIDTH(30), kAUTOHEIGHT(30 + 22), ScreenWidth - kAUTOWIDTH(60), kAUTOHEIGHT(66));
         _searchView.frame = CGRectMake(kAUTOWIDTH(20), CGRectGetMaxY(_navTitleLabel.frame) + kAUTOHEIGHT(10), ScreenWidth - kAUTOWIDTH(40), kAUTOHEIGHT(30));
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_searchTextField resignFirstResponder];
    SearchViewController *svc = [[SearchViewController alloc]init];
    svc.keyWords = _searchTextField.text;
    [self.navigationController pushViewController:svc animated:YES];
    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
- (NSMutableArray <ListModel *>*)dataListArray{
    if (!_dataListArray) {
        _dataListArray = @[].mutableCopy;
    }
    return _dataListArray;
}

#pragma mark - 懒加载
- (CellDrawView *)  drawView{
    if (!_drawView) {
        _drawView = [CellDrawView new];
        _drawView.layer.masksToBounds = YES;
        _drawView.layer.cornerRadius = 10;
        _drawView.layer.borderColor = [UIColor whiteColor].CGColor;
        _drawView.layer.borderWidth = 1;
        [self.paiView addSubview:_drawView];
    }
    return _drawView;
}

- (void)setModel:(ListModel *)model{
//    self.titleLabel.text = model.title;
//    self.disTitleLabel.text = model.disTitle;
    
    self.drawView.showLayer.path = model.path.CGPath;
    CABasicAnimation *animation = [AxcCAAnimation AxcDrawLineDuration:2 timingFunction:kCAMediaTimingFunctionEaseInEaseOut];
    animation.autoreverses = YES;               // 动画结束时执行逆动画
    animation.repeatCount = 100                                                                                                                                                                                                                                                                                                                  ;          // 重复次数
    animation.removedOnCompletion = YES;
    [self.drawView.showLayer addAnimation:animation forKey:@"animation"];
}

@end
