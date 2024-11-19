//
//  ABMETableViewCell.m
//  wanghouyusheng
//
//  Created by 北城 on 2018/8/11.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import "ABMETableViewCell.h"

@implementation ABMETableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (!_fuYongView) {
        _fuYongView = [[UIView alloc]initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:_fuYongView];
    }
    
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(15, 54, ScreenWidth - 30, 200)];
        [_fuYongView addSubview:_bgView];
        //        bgView.alpha = 0.9;
        _bgView.layer.cornerRadius= 9;
        _bgView.layer.shadowColor=[UIColor grayColor].CGColor;
        //        bgView.layer.shadowOffset=CGSizeMake(0, 3);
        //        bgView.layer.shadowOpacity=0.6f;
        _bgView.layer.shadowRadius=8;
        _bgView.layer.masksToBounds = YES;
    }
    
    if (!_gradientLayerLeft) {
        _gradientLayerLeft = [CAGradientLayer layer];
        _gradientLayerLeft.frame = CGRectMake(0, 0, ScreenWidth, 200);
        _gradientLayerLeft.colors = @[(id)PNCColor(28, 148, 251).CGColor, (id)PNCColor(105, 208, 253).CGColor];
        //        gradientLayerLeft.colors = @[(id)PNCColor(221, 253, 205).CGColor, (id)PNCColor(160, 250, 255).CGColor];
        _gradientLayerLeft.locations = @[@(0),@(1)];
        _gradientLayerLeft.startPoint = CGPointMake(0, 0.2);
        _gradientLayerLeft.endPoint = CGPointMake(1, 0.8);
        //    gradientLayerLeft.cornerRadius = 5;
        //        gradientLayerLeft.shadowOffset = CGSizeMake(3, 3);
        //        gradientLayerLeft.shadowOpacity = 0.1f;
        [_bgView.layer addSublayer:_gradientLayerLeft];
        
    }
    
    if (!_subBgLayer) {
        _subBgLayer=[CALayer layer];
        CGRect fixBgframe=_bgView.layer.frame;
        _subBgLayer.frame = fixBgframe;
        _subBgLayer.cornerRadius = 9;
        _subBgLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
        _subBgLayer.masksToBounds=NO;
        _subBgLayer.shadowColor=[UIColor grayColor].CGColor;
        _subBgLayer.shadowOffset=CGSizeMake(0,5);
        _subBgLayer.shadowOpacity=0.9f;
        _subBgLayer.shadowRadius= 6;
        [_fuYongView.layer insertSublayer:_subBgLayer below:_bgView.layer];
    }
    
    
    
    
    if (!_touxiangImageView) {
        _touxiangImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 84, 60, 60)];
        [self.contentView addSubview:_touxiangImageView];
        _touxiangImageView.layer.cornerRadius = 30.f;
        _touxiangImageView.image = [UIImage imageNamed:@"IMG_0122.JPG"];
        _touxiangImageView.layer.borderWidth = 3.f;
        _touxiangImageView.contentMode = UIViewContentModeScaleAspectFill;
        _touxiangImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _touxiangImageView.layer.masksToBounds = YES;
    }
    
    if (!_subLayer) {
        _subLayer=[CALayer layer];
        CGRect fixframe=_touxiangImageView.layer.frame;
        _subLayer.frame = fixframe;
        _subLayer.cornerRadius = 30;
        _subLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
        _subLayer.masksToBounds=NO;
        _subLayer.shadowColor=[UIColor grayColor].CGColor;
        _subLayer.shadowOffset=CGSizeMake(0,5);
        _subLayer.shadowOpacity=0.7f;
        _subLayer.shadowRadius= 8;
        [_fuYongView.layer insertSublayer:_subLayer below:_touxiangImageView.layer];
        
    }
    
    UILabel *qianMingLabel = [Factory createLabelWithTitle:@"希望，世界和平" frame:CGRectMake(30, CGRectGetMaxY(_touxiangImageView.frame) +kAUTOHEIGHT(20), 150, 30)];
    qianMingLabel.textAlignment = NSTextAlignmentLeft;
    qianMingLabel.textColor = [UIColor whiteColor];
    qianMingLabel.font = [UIFont fontWithName:@"TpldKhangXiDictTrial" size:15];
    
    UILabel *qianMingELabel = [Factory createLabelWithTitle:@"I hope,the peace of the world" frame:CGRectMake(30, CGRectGetMaxY(qianMingLabel.frame) , 180, 20)];
    qianMingELabel.textAlignment = NSTextAlignmentLeft;
    qianMingELabel.textColor = [UIColor whiteColor];
    qianMingELabel.font = [UIFont fontWithName:@"Avenir Next" size:11];
    
    [_fuYongView addSubview:qianMingELabel];
    
    [_fuYongView addSubview:qianMingLabel];
    
    UILabel *nameLabel = [Factory createLabelWithTitle:@"北城以北" frame:CGRectMake(ScreenWidth - 180,74,150, 44)];
    nameLabel.font = [UIFont fontWithName:@"TpldKhangXiDictTrial" size:20];
    nameLabel.textAlignment = NSTextAlignmentRight;
    [_fuYongView addSubview:nameLabel];
    nameLabel.textColor = [UIColor whiteColor];
    
    //        nameLabel.backgroundColor = [UIColor blueColor];
    UILabel *jieshaoLabel = [Factory createLabelWithTitle:@"独立开发·专注开发精品App" frame:CGRectMake(ScreenWidth - 180, CGRectGetMaxY(nameLabel.frame), 150, 30)];
    jieshaoLabel.font = [UIFont fontWithName:@"Heiti SC" size:12.f];
    jieshaoLabel.textAlignment = NSTextAlignmentRight;
    jieshaoLabel.textColor = [UIColor whiteColor];
    //        jieshaoLabel.backgroundColor = [UIColor redColor];
    [_fuYongView addSubview:jieshaoLabel];
    
    UILabel *youXianglLabel = [Factory createLabelWithTitle:@"northcitytime@sina.com" frame:CGRectMake(ScreenWidth - 180, CGRectGetMaxY(jieshaoLabel.frame), 150, 28)];
    youXianglLabel.font = [UIFont fontWithName:@"Avenir Next" size:12.f];
    youXianglLabel.textAlignment = NSTextAlignmentRight;
    //        jieshaoLabel.backgroundColor = [UIColor redColor];
    [_fuYongView addSubview:youXianglLabel];
    youXianglLabel.textColor = [UIColor whiteColor];
    
    
    
    
    UILabel *blogLabel = [Factory createLabelWithTitle:@"www.northcity.top" frame:CGRectMake(ScreenWidth - 180, CGRectGetMaxY(youXianglLabel.frame), 150, 28)];
    blogLabel.font = [UIFont fontWithName:@"Avenir Next" size:12.f];
    blogLabel.textAlignment = NSTextAlignmentRight;
    //        jieshaoLabel.backgroundColor = [UIColor redColor];
    [_fuYongView addSubview:blogLabel];
    blogLabel.textColor = [UIColor whiteColor];
    
    UIImageView *imageViewPingGuo = [[UIImageView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(blogLabel.frame) + 5, 35, 35)];
    //        [cell.contentView addSubview:imageViewPingGuo];
    imageViewPingGuo.image = [UIImage imageNamed:@"iconshoudiantong.png"];
    imageViewPingGuo.layer.cornerRadius = kAUTOHEIGHT(17.5f);
    //        iconImage.layer.borderWidth = 0.5f;
    //        iconImage.layer.borderColor = [UIColor grayColor].CGColor;
    imageViewPingGuo.layer.masksToBounds = YES;
    CALayer *subLayerIcon=[CALayer layer];
    CGRect fixframeIcon = imageViewPingGuo.layer.frame;
    subLayerIcon.frame = fixframeIcon;
    subLayerIcon.cornerRadius = kAUTOHEIGHT(17.5f);
    subLayerIcon.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    subLayerIcon.masksToBounds=NO;
    subLayerIcon.shadowColor=[UIColor grayColor].CGColor;
    subLayerIcon.shadowOffset=CGSizeMake(0,5);
    subLayerIcon.shadowOpacity=0.8f;
    subLayerIcon.shadowRadius= 2;
    //        [cell.contentView.layer insertSublayer:subLayerIcon below:imageViewPingGuo.layer];
    imageViewPingGuo.layer.borderColor = [UIColor redColor].CGColor;
    imageViewPingGuo.layer.borderWidth = 2.f;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
