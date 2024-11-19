//
//  SignSuccessWindow.m
//  GameMall
//
//  Created by zyc on 16/8/2.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "RewardSuccessWindow.h"
static CGFloat SuccessWindow_width = 270;
static CGFloat SuccessWindow_hight = 170;


@implementation RewardSuccessWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self = [super initWithFrame:CGRectMake((screenSize.width - SuccessWindow_width)/2.0 , (screenSize.height - SuccessWindow_hight)/2.0, SuccessWindow_width, SuccessWindow_hight)];
    
    if (self)
    {
        [self configSubViews];
    }
    return self;
}
- (void)configSubViews
{
    self.backgroundColor = [UIColor blackColor];
    self.layer.cornerRadius = 10;
//    self.layer.masksToBounds = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, SuccessWindow_width, 22)];
    titleLabel.text = @"恭喜您，购买成功！";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:19];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    UILabel *expLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, SuccessWindow_width, 43)];
    expLabel.font =  [UIFont fontWithName:@"Avenir-Medium" size:15];
    expLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:expLabel];

    NSString *string = @"非常感谢您的支持";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,string.length)];
    [attributedString addAttribute:NSFontAttributeName value: [UIFont fontWithName:@"Avenir-Medium" size:15] range:NSMakeRange(0, string.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"MarkerFelt-Thin" size:30] range:NSMakeRange(2,2)];
    NSShadow *shadow =[[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(1, 2);
    [attributedString addAttribute:NSShadowAttributeName value:shadow range:NSMakeRange(2,2)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(2,2)];
    expLabel.attributedText = attributedString;

    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 135, SuccessWindow_width, 22)];
    bottomLabel.text = @"九宫格切图一定会越来越好。";
    bottomLabel.font = [UIFont fontWithName:@"HeiTi SC" size:12];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.textColor = [UIColor whiteColor];
    [self addSubview:bottomLabel];
}

@end
