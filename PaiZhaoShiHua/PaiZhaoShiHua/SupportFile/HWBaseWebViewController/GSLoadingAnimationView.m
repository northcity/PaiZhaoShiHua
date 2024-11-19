//
//  GSLoadingAnimationView.m
//  jiaohangScanUI
//
//  Created by 刘高升 on 2017/10/11.
//  Copyright © 2017年 刘高升. All rights reserved.
//

#import "GSLoadingAnimationView.h"
@interface GSLoadingAnimationView ()
{
    UIImageView *_baseImageView;
    UILabel *_contentLable;
}
@end
@implementation GSLoadingAnimationView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initContentView];
    }
    return self;
}
- (void)initContentView {
    
    _baseImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-加载状态"]];
    _baseImageView.frame = self.bounds;
    [self addSubview:_baseImageView];
    _contentLable = [[UILabel alloc]initWithFrame:self.bounds];
    _contentLable.center = self.center;
    _contentLable.textColor = [UIColor whiteColor];
    _contentLable.textAlignment = NSTextAlignmentCenter;
    _contentLable.font = [UIFont systemFontOfSize:36];
    _contentLable.text = @"0%";
    [self addSubview:_contentLable];
    [self startRotationAnimation:_baseImageView.layer];
    
}

- (void)startRotationAnimation:(CALayer *)layer {
    
    CABasicAnimation *scaleAnimation;
    scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = @0.0;
    scaleAnimation.toValue = @1.0;
    scaleAnimation.duration = 0.2;
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 3.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE;
    
    [layer addAnimation:scaleAnimation forKey:@"transformScalexy"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    });
    
    
}

/**
 *改变字符串中具体某字符串的颜色
 */
- (void)messageActionChangeString:(NSString *)change andAllColor:(UIColor *)allColor andMarkColor:(UIColor *)markColor andMarkFondSize:(float)fontSize {
    NSString *tempStr = _contentLable.text;
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:tempStr];
    [strAtt addAttribute:NSForegroundColorAttributeName value:allColor range:NSMakeRange(0, [strAtt length])];
    NSRange markRange = [tempStr rangeOfString:change];
    [strAtt addAttribute:NSForegroundColorAttributeName value:markColor range:markRange];
    [strAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:fontSize] range:markRange];
    _contentLable.attributedText = strAtt;
}

//Set方法赋值
- (void)setContent:(NSString *)content {
    
    _content = content;
    _contentLable.text = [NSString stringWithFormat:@"%@%%",content];
    [self messageActionChangeString:@"%" andAllColor:[UIColor whiteColor] andMarkColor:[UIColor whiteColor] andMarkFondSize:15];
    
    
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
