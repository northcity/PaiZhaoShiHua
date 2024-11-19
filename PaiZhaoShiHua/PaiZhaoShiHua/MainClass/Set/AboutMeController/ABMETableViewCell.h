//
//  ABMETableViewCell.h
//  wanghouyusheng
//
//  Created by 北城 on 2018/8/11.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABMETableViewCell : UITableViewCell
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong) UIImageView *touxiangImageView;
@property (nonatomic,strong) UIView *fuYongView;
@property (nonatomic,strong) CALayer *subLayer;
@property (nonatomic,strong) CALayer *subBgLayer;

@property (nonatomic,strong) CAGradientLayer * gradientLayerLeft;

@end
