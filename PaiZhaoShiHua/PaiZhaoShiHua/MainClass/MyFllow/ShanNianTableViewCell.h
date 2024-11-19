//
//  ShanNianTableViewCell.h
//  CutImageForYou
//
//  Created by chenxi on 2018/5/24.
//  Copyright © 2018年 chenxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaveView.h"
#import "LZDataModel.h"
//#import "PcmPlayer.h"
//#import "PcmPlayerDelegate.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ShanNianTableViewCell : UITableViewCell
@property(nonatomic,strong)UIView * label;
@property (nonatomic, strong) UILabel *dateLabel;

@property(nonatomic,strong)UIButton *playBtn;

@property(nonatomic, strong) UIImageView *baiSeMaskImageView;

@property(nonatomic,copy)dispatch_block_t cellPlayBlock;
@property (nonatomic,strong) WaveView *waveView;
@property (nonatomic,strong) LZDataModel *model;
//@property (nonatomic, strong) PcmPlayer *audioPlayer;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView * seleImage;


- (void)setContentModel:(LZDataModel *)model;

@end
