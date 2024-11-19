//
//  GSScanView.h
//  jiaohangScanUI
//
//  Created by 刘高升 on 2017/9/26.
//  Copyright © 2017年 刘高升. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BackClickBlock)();
typedef void(^FlashLightClickBlock)();
@interface GSScanView : UIView
@property (nonatomic , copy) BackClickBlock backBlock;
@property (nonatomic , copy) FlashLightClickBlock lightClickBlock;
@property(nonatomic,strong)UIView *barBgView;
@property(nonatomic,strong)UIView *navBgView;

- (void)stopCenterAnimation;
- (void)scanEndAnimation;
- (void)stratScan;
- (void)hiddenScan;

@end
