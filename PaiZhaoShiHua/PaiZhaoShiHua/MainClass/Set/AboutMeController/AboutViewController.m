//
//  AboutViewController.m
//  shoudiantong
//
//  Created by 北城 on 2018/3/8.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import "AboutViewController.h"
#import "ABMETableViewCell.h"

@interface AboutViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *myTableView;
@property(nonatomic,strong)UIButton *lianJieBtn;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMyTableView];
    [self initOtherUI];
    // Do any additional setup after loading the view.
}
- (void)initOtherUI{
    UIButton * backBtn = [Factory createButtonWithTitle:@"" frame:CGRectMake(20, 28, 25, 25) backgroundColor:[UIColor clearColor] backgroundImage:[UIImage imageNamed:@""] target:self action:@selector(backAction)];
    [backBtn setImage:[UIImage imageNamed:@"关闭2"] forState:UIControlStateNormal];
    if (PNCisIPHONEX) {
        backBtn.frame = CGRectMake(20, 48, 25, 25);
    }
    [self.view addSubview:backBtn];
    backBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
//
//    [UIView animateWithDuration:0.4 animations:^{
//        backBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
//    }];
//    backBtn.transform = CGAffineTransformIdentity;
//    [UIView animateWithDuration:2 delay:2 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        backBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
//
//    } completion:^(BOOL finished) {
//
//    }];

  
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CABasicAnimation* rotationAnimation;

        rotationAnimation =[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//        rotationAnimation.fromValue =[NSNumber numberWithFloat: 0M_PI_4];

        rotationAnimation.toValue =[NSNumber numberWithFloat: 0];
        rotationAnimation.duration =0.4;
        rotationAnimation.repeatCount =1;
        rotationAnimation.removedOnCompletion = NO;
        rotationAnimation.fillMode = kCAFillModeForwards;
        [backBtn.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];

    });



}
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)initMyTableView{
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    [self.view addSubview:self.myTableView];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"1234"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"ABMETableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"2234"];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 64;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"1234";
   
    if (indexPath.row == 0) {
     
        ABMETableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"2234" forIndexPath:indexPath];
        return cell;
        
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    
    if (indexPath.row == 2) {
        UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 60, 60)];
        [cell.contentView addSubview:iconImage];
        iconImage.image = [UIImage imageNamed:@"weibo.jpg"];
        
        iconImage.layer.cornerRadius = kAUTOHEIGHT(8);
        //        iconImage.layer.borderWidth = 0.5f;
        //        iconImage.layer.borderColor = [UIColor grayColor].CGColor;
        iconImage.layer.masksToBounds = YES;
        CALayer *subLayer=[CALayer layer];
        CGRect fixframe=iconImage.layer.frame;
        subLayer.frame = fixframe;
        subLayer.cornerRadius = kAUTOHEIGHT(8);
        subLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
        subLayer.masksToBounds=NO;
        subLayer.shadowColor=[UIColor grayColor].CGColor;
        subLayer.shadowOffset=CGSizeMake(0,5);
        subLayer.shadowOpacity=0.5f;
        subLayer.shadowRadius= 4;
        [cell.contentView.layer insertSublayer:subLayer below:iconImage.layer];
        
        
        
        UILabel *blogLabel = [Factory createLabelWithTitle:@"关注作者" frame:CGRectMake(CGRectGetMaxX(iconImage.frame)+kAUTOWIDTH(20), kAUTOHEIGHT(20), 150, kAUTOHEIGHT(32))];
        blogLabel.font = [UIFont fontWithName:@"Heiti SC" size:15.f];
        blogLabel.font = [UIFont boldSystemFontOfSize:15];
        blogLabel.textAlignment = NSTextAlignmentLeft;
        //        jieshaoLabel.backgroundColor = [UIColor redColor];
        [cell.contentView addSubview:blogLabel];
        blogLabel.textColor = [UIColor blackColor];
        
        UILabel *detailLabel = [Factory createLabelWithTitle:@"随时分享新鲜事" frame:CGRectMake(CGRectGetMaxX(iconImage.frame)+kAUTOWIDTH(20),CGRectGetMaxY(blogLabel.frame) , 150, kAUTOHEIGHT(22))];
        detailLabel.font = [UIFont fontWithName:@"Heiti SC" size:12.f];
        detailLabel.textAlignment = NSTextAlignmentLeft;
        //        jieshaoLabel.backgroundColor = [UIColor redColor];
        [cell.contentView addSubview:detailLabel];
        detailLabel.textColor = [UIColor blackColor];
        
        UIButton *lianJieBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        lianJieBtn.frame = CGRectMake(ScreenWidth - kAUTOWIDTH(104), kAUTOHEIGHT(35.f), kAUTOWIDTH(74), kAUTOHEIGHT(30));
        [ lianJieBtn setBackgroundColor:RGBA(238, 241, 249, 1)];
        [ lianJieBtn setTitleColor:RGBA(41, 130, 251, 1) forState:UIControlStateNormal];
        [ lianJieBtn setTitle:@"获取" forState:UIControlStateNormal];
        lianJieBtn.titleLabel.font = [UIFont boldSystemFontOfSize: 15.f];
        
        [cell.contentView addSubview: lianJieBtn];
        lianJieBtn.layer.masksToBounds = YES;
        lianJieBtn.layer.cornerRadius = kAUTOHEIGHT(15);
        [ lianJieBtn addTarget:self action:@selector(awakeWeiBoApp) forControlEvents:UIControlEventTouchUpInside];
        
        
        //判断本地是否有淘宝App
        NSURL * myURL_APP_A = [NSURL URLWithString:@"sinaweibo://"];
        if ([[UIApplication sharedApplication] canOpenURL:myURL_APP_A]) {
            NSLog(@"canOpenURL");
            [ lianJieBtn setTitle:@"关注" forState:UIControlStateNormal];
        }else{
            NSLog(@"不显示");
            [ lianJieBtn setTitle:@"获取" forState:UIControlStateNormal];
        }
    }
    
   

    
    if (indexPath.row == 3) {
        
        
        UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 60, 60)];
        [cell.contentView addSubview:iconImage];
        iconImage.image = [UIImage imageNamed:@"iconcheng"];
        
        iconImage.layer.cornerRadius = kAUTOHEIGHT(8);
        //        iconImage.layer.borderWidth = 0.5f;
        //        iconImage.layer.borderColor = [UIColor grayColor].CGColor;
        iconImage.layer.masksToBounds = YES;
        CALayer *subLayer=[CALayer layer];
        CGRect fixframe=iconImage.layer.frame;
        subLayer.frame = fixframe;
        subLayer.cornerRadius = kAUTOHEIGHT(8);
        subLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
        subLayer.masksToBounds=NO;
        subLayer.shadowColor=[UIColor grayColor].CGColor;
        subLayer.shadowOffset=CGSizeMake(0,5);
        subLayer.shadowOpacity=0.5f;
        subLayer.shadowRadius= 4;
        [cell.contentView.layer insertSublayer:subLayer below:iconImage.layer];
        
        
        
        UILabel *blogLabel = [Factory createLabelWithTitle:@"城池-这座城冷清陌生" frame:CGRectMake(CGRectGetMaxX(iconImage.frame)+kAUTOWIDTH(20), kAUTOHEIGHT(20), 150, kAUTOHEIGHT(32))];
        blogLabel.font = [UIFont fontWithName:@"Heiti SC" size:15.f];
        blogLabel.font = [UIFont boldSystemFontOfSize:15];
        blogLabel.textAlignment = NSTextAlignmentLeft;
        //        jieshaoLabel.backgroundColor = [UIColor redColor];
        [cell.contentView addSubview:blogLabel];
        blogLabel.textColor = [UIColor blackColor];
        
        UILabel *detailLabel = [Factory createLabelWithTitle:@"高逼格文艺社区" frame:CGRectMake(CGRectGetMaxX(iconImage.frame)+kAUTOWIDTH(20),CGRectGetMaxY(blogLabel.frame) , 150, kAUTOHEIGHT(22))];
        detailLabel.font = [UIFont fontWithName:@"Heiti SC" size:12.f];
        detailLabel.textAlignment = NSTextAlignmentLeft;
        //        jieshaoLabel.backgroundColor = [UIColor redColor];
        [cell.contentView addSubview:detailLabel];
        detailLabel.textColor = [UIColor blackColor];
        
        self.lianJieBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.lianJieBtn.frame = CGRectMake(ScreenWidth - kAUTOWIDTH(104), kAUTOHEIGHT(35.f), kAUTOWIDTH(74), kAUTOHEIGHT(30));
        [ self.lianJieBtn setBackgroundColor:RGBA(238, 241, 249, 1)];
        [ self.lianJieBtn setTitleColor:RGBA(41, 130, 251, 1) forState:UIControlStateNormal];
        [ self.lianJieBtn setTitle:@"获取" forState:UIControlStateNormal];
        self.lianJieBtn.titleLabel.font = [UIFont boldSystemFontOfSize: 15.f];
        
        [cell.contentView addSubview: self.lianJieBtn];
        self.lianJieBtn.layer.masksToBounds = YES;
        self.lianJieBtn.layer.cornerRadius = kAUTOHEIGHT(15);
        [ self.lianJieBtn addTarget:self action:@selector(awakeOtherApp) forControlEvents:UIControlEventTouchUpInside];
        
        
        //判断本地是否有淘宝App
        NSURL * myURL_APP_A = [NSURL URLWithString:@"niancheng://"];
        if ([[UIApplication sharedApplication] canOpenURL:myURL_APP_A]) {
            NSLog(@"canOpenURL");
            [ self.lianJieBtn setTitle:@"打开" forState:UIControlStateNormal];
        }else{
            NSLog(@"不显示");
            [ self.lianJieBtn setTitle:@"获取" forState:UIControlStateNormal];
        }
        
    }
    if (indexPath.row == 1) {
        UIButton *Button = [UIButton buttonWithType:UIButtonTypeCustom];
      Button = [self CellContentViewwWithBtnNormalString:@"关注" WithBtnSelectedString:@"获取" WithAppUrlSecheme:@"zhihu://" WithImageName:@"zhihuIcon.jpg" WithTitleString:@"关注作者" WithDetailString:@"分享你的问题和经验" WithCell:cell];
            [Button addTarget:self action:@selector(awakeZhiHuApp) forControlEvents:UIControlEventTouchUpInside];

    }
    
    if (indexPath.row == 4) {
        UIButton *Button = [UIButton buttonWithType:UIButtonTypeCustom];
        Button = [self CellContentViewwWithBtnNormalString:@"打开" WithBtnSelectedString:@"获取" WithAppUrlSecheme:@"chenxishoudiantong://" WithImageName:@"iconshoudiantong.png" WithTitleString:@"手电筒-极简" WithDetailString:@"一款极简手电筒" WithCell:cell];
        [Button addTarget:self action:@selector(awakeShouDIanTongApp) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (indexPath.row == 5) {
        if (!self.shiJianJiaoNangBtn) {
            self.shiJianJiaoNangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.shiJianJiaoNangBtn = [self CellContentViewwWithBtnNormalString:@"打开" WithBtnSelectedString:@"获取" WithAppUrlSecheme:@"chenxishijianjiaonang://" WithImageName:@"zuizhongIcon.png" WithTitleString:@"时间胶囊" WithDetailString:@"乘时间之海" WithCell:cell];
            [self.shiJianJiaoNangBtn addTarget:self action:@selector(awakeShiJianJiaoNangApp) forControlEvents:UIControlEventTouchUpInside];
        }

    }
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];

    if (indexPath.row == 6) {
        if (!self.jiuGongGeBtn) {
            self.jiuGongGeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.jiuGongGeBtn = [self CellContentViewwWithBtnNormalString:@"去评价" WithBtnSelectedString:@"获取" WithAppUrlSecheme:@"comchenxijiugongge://" WithImageName:@"iconJiu.png" WithTitleString:[NSString stringWithFormat:@"Version %@", [infoDictionary objectForKey:@"CFBundleShortVersionString"]]  WithDetailString:@"一键切图" WithCell:cell];
            [self.jiuGongGeBtn addTarget:self action:@selector(awakeSelfApp) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    if (indexPath.row == 7) {
        if (!self.selfBtn) {
            self.selfBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.selfBtn = [self CellContentViewwWithBtnNormalString:@"打开" WithBtnSelectedString:@"获取" WithAppUrlSecheme:@"comchenxijiyisuipian://" WithImageName:@"icon.png" WithTitleString:@"闪念碎片 - 碎片化灵感记录" WithDetailString:@"一生太短，一瞬太长，记住此刻美好" WithCell:cell];
            [self.selfBtn addTarget:self action:@selector(awakeShanNianApp) forControlEvents:UIControlEventTouchUpInside];
        }
    }

    if (indexPath.row == 8) {
        if (!self.wangHouYuShengBtn) {
            self.wangHouYuShengBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.wangHouYuShengBtn = [self CellContentViewwWithBtnNormalString:@"打开" WithBtnSelectedString:@"获取" WithAppUrlSecheme:@"comchenxiwanghouyusheng://" WithImageName:@"1024" WithTitleString: @"往后余生" WithDetailString:@"余生有你" WithCell:cell];
            [self.wangHouYuShengBtn addTarget:self action:@selector(awakeWangHouYuSheng) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return  cell;
    }
    return nil;
}

- (UIButton *)CellContentViewwWithBtnNormalString:(NSString *)btnNormalString WithBtnSelectedString:(NSString *)btnSeleString WithAppUrlSecheme:(NSString *)urlSchemeString WithImageName:(NSString *)imageName WithTitleString:(NSString *)titleString WithDetailString:(NSString*)detailString WithCell:(UITableViewCell *)cell{
    
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 60, 60)];
    [cell.contentView addSubview:iconImage];
    iconImage.image = [UIImage imageNamed:imageName];
    
    iconImage.layer.cornerRadius = kAUTOHEIGHT(8);
    //        iconImage.layer.borderWidth = 0.5f;
    //        iconImage.layer.borderColor = [UIColor grayColor].CGColor;
    iconImage.layer.masksToBounds = YES;
    CALayer *subLayer=[CALayer layer];
    CGRect fixframe=iconImage.layer.frame;
    subLayer.frame = fixframe;
    subLayer.cornerRadius = kAUTOHEIGHT(8);
    subLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    subLayer.masksToBounds=NO;
    subLayer.shadowColor=[UIColor grayColor].CGColor;
    subLayer.shadowOffset=CGSizeMake(0,5);
    subLayer.shadowOpacity=0.5f;
    subLayer.shadowRadius= 4;
    [cell.contentView.layer insertSublayer:subLayer below:iconImage.layer];
    
    
    
    UILabel *blogLabel = [Factory createLabelWithTitle:titleString frame:CGRectMake(CGRectGetMaxX(iconImage.frame)+kAUTOWIDTH(20), kAUTOHEIGHT(20), 150, kAUTOHEIGHT(32))];
    blogLabel.font = [UIFont fontWithName:@"Heiti SC" size:15.f];
    blogLabel.font = [UIFont boldSystemFontOfSize:15];
    blogLabel.textAlignment = NSTextAlignmentLeft;
    //        jieshaoLabel.backgroundColor = [UIColor redColor];
    [cell.contentView addSubview:blogLabel];
    blogLabel.textColor = [UIColor blackColor];
    
    UILabel *detailLabel = [Factory createLabelWithTitle:detailString frame:CGRectMake(CGRectGetMaxX(iconImage.frame)+kAUTOWIDTH(20),CGRectGetMaxY(blogLabel.frame) , 150, kAUTOHEIGHT(22))];
    detailLabel.font = [UIFont fontWithName:@"Heiti SC" size:12.f];
    detailLabel.textAlignment = NSTextAlignmentLeft;
    //        jieshaoLabel.backgroundColor = [UIColor redColor];
    [cell.contentView addSubview:detailLabel];
    detailLabel.textColor = [UIColor blackColor];
    
    UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame = CGRectMake(ScreenWidth - kAUTOWIDTH(104), kAUTOHEIGHT(35.f), kAUTOWIDTH(74), kAUTOHEIGHT(30));
    [ Btn setBackgroundColor:RGBA(238, 241, 249, 1)];
    [ Btn setTitleColor:RGBA(41, 130, 251, 1) forState:UIControlStateNormal];
    [ Btn setTitle:@"获取" forState:UIControlStateNormal];
    Btn.titleLabel.font = [UIFont boldSystemFontOfSize: 15.f];
    
    [cell.contentView addSubview: Btn];
    Btn.layer.masksToBounds = YES;
    Btn.layer.cornerRadius = kAUTOHEIGHT(15);
//    [ lianJieBtn addTarget:self action:@selector(awakeWeiBoApp) forControlEvents:UIControlEventTouchUpInside];
    
    
    //判断本地是否有淘宝App
    NSURL * myURL_APP_A = [NSURL URLWithString:urlSchemeString];
    if ([[UIApplication sharedApplication] canOpenURL:myURL_APP_A]) {
        NSLog(@"canOpenURL");
        [ Btn setTitle:btnNormalString forState:UIControlStateNormal];
    }else{
        NSLog(@"不显示");
        [ Btn setTitle:btnSeleString forState:UIControlStateNormal];
    }
 
    return  Btn;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    ///配置 CATransform3D 动画内容
    CATransform3D  transform;
//    transform.m34 = 1.0/-800;
    
    //定义 Cell的初始化状态
//    cell.layer.transform = transform;
    cell.transform = CGAffineTransformMakeScale(0.95f, 0.95f);
    // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
    [UIView animateWithDuration: 0.7 delay:0.2 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
        // 放大
        cell.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
    //定义Cell 最终状态 并且提交动画
//    [UIView beginAnimations:@"transform" context:NULL];
//    [UIView setAnimationDuration:1];
//    cell.layer.transform = CATransform3DIdentity;
//    cell.frame = CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
//    [UIView commitAnimations];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 268;
    }else{
        return kAUTOHEIGHT(100);
    }
    return 60;
}

- (void)awakeSelfApp
{

    NSString *itunesurl = @"itms-apps://itunes.apple.com/cn/app/id1383797480?mt=8&action=write-review";
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itunesurl]];
    
    
}

- (void)awakeWangHouYuSheng
{
    NSString *customURL = @"comchenxijiyisuipian://";
    
    if ([[UIApplication sharedApplication]
         canOpenURL:[NSURL URLWithString:customURL]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customURL]];
    }
    else
    {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/%E5%9F%8E%E6%B1%A0-%E8%BF%99%E5%BA%A7%E5%9F%8E%E5%86%B7%E6%B8%85%E9%99%8C%E7%94%9F/id1419939043?mt=8"]];
    }
}
- (void)awakeShanNianApp
{
    NSString *customURL = @"comchenxijiyisuipian://";
    
    if ([[UIApplication sharedApplication]
         canOpenURL:[NSURL URLWithString:customURL]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customURL]];
    }
    else
    {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/%E5%9F%8E%E6%B1%A0-%E8%BF%99%E5%BA%A7%E5%9F%8E%E5%86%B7%E6%B8%85%E9%99%8C%E7%94%9F/id1397149726?mt=8"]];
    }
}

- (void)awakeJiuGongGeApp
{
    NSString *customURL = @"comchenxijiugongge://";
    
    if ([[UIApplication sharedApplication]
         canOpenURL:[NSURL URLWithString:customURL]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customURL]];
    }
    else
    {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/%E5%9F%8E%E6%B1%A0-%E8%BF%99%E5%BA%A7%E5%9F%8E%E5%86%B7%E6%B8%85%E9%99%8C%E7%94%9F/id?mt=8"]];
    }
}

- (void)awakeZhiHuApp
{
    NSString *customURL = @"zhihu://people/chen-xi-18-69-64";
    
    if ([[UIApplication sharedApplication]
         canOpenURL:[NSURL URLWithString:customURL]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customURL]];
    }
    else
    {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.zhihu.com/people/chen-xi-18-69-64/activities"]];

    }
}

- (void)awakeWeiBoApp
{
    NSString *customURL = @"sinaweibo://userinfo?uid=5227295178";
    
    if ([[UIApplication sharedApplication]
         canOpenURL:[NSURL URLWithString:customURL]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customURL]];
    }
    else
    {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/%E5%BE%AE%E5%8D%9A/id350962117?mt=8"]];
        
    }
}


      
- (void)awakeShouDIanTongApp
{
    NSString *customURL = @"chenxishoudiantong://";
    
    if ([[UIApplication sharedApplication]
         canOpenURL:[NSURL URLWithString:customURL]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customURL]];
    }
    else
    {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/%E5%9F%8E%E6%B1%A0-%E8%BF%99%E5%BA%A7%E5%9F%8E%E5%86%B7%E6%B8%85%E9%99%8C%E7%94%9F/id1358074351?mt=8"]];
    }
}
                                        
- (void)awakeOtherApp
{
    NSString *customURL = @"niancheng://";
    
    if ([[UIApplication sharedApplication]
         canOpenURL:[NSURL URLWithString:customURL]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customURL]];
    }
    else
    {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/%E5%9F%8E%E6%B1%A0-%E8%BF%99%E5%BA%A7%E5%9F%8E%E5%86%B7%E6%B8%85%E9%99%8C%E7%94%9F/id1353019343?mt=8"]];
    }
}

- (void)awakeShiJianJiaoNangApp
{
    NSString *customURL = @"chenxishijianjiaonang://";
    
    if ([[UIApplication sharedApplication]
         canOpenURL:[NSURL URLWithString:customURL]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customURL]];
    }
    else
    {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/%E5%9F%8E%E6%B1%A0-%E8%BF%99%E5%BA%A7%E5%9F%8E%E5%86%B7%E6%B8%85%E9%99%8C%E7%94%9F/id1358237203?mt=8"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
