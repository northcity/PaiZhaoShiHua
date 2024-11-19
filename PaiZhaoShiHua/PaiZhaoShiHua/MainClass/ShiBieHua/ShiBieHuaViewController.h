//
//  ShiBieHuaViewController.h
//  PaiZhaoShiHua
//
//  Created by 北城 on 2018/11/12.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShiBieHuaViewController : UIViewController
@property (nonatomic,strong)UIImage *selectedImage;

@property (nonatomic,strong)UIImageView *selectedImageView;
@property (nonatomic, strong) UIVisualEffectView *effectView;//模糊视图
@property (nonatomic, strong) UIBlurEffect *effect;//模糊视图
@property (nonatomic,strong)UIImageView *bgImageView;
@property (nonatomic,strong)UILabel *shiBieLabel;
@property (nonatomic, strong)UIButton *shiBieCancleBtn;
@property (nonatomic,strong)UILabel *paiLabel;
@property (nonatomic, strong)UIButton *fanHuiBtn;

@end

