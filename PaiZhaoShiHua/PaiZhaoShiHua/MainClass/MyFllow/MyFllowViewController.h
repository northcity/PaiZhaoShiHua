//
//  MyFllowViewController.h
//  PaiZhaoShiHua
//
//  Created by 北城 on 2018/11/9.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFllowViewController : UIViewController

@property(nonatomic,assign)BOOL isPresnted;
@property (nonatomic,strong) WaveView *waveView;

@property(nonatomic,strong)UILabel *navTitleLabel;
@property(nonatomic,strong)UIView *titleView;
@property(nonatomic,strong)UIButton *backBtn;

@property(nonatomic,strong) UIImageView *smartImage;
@property(nonatomic,strong) UIImageView *blurImageView;

@end
