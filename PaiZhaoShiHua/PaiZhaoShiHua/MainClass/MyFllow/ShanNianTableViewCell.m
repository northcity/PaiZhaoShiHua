//
//  ShanNianTableViewCell.m
//  CutImageForYou
//
//  Created by chenxi on 2018/5/24.
//  Copyright © 2018年 chenxi. All rights reserved.
//

#import "ShanNianTableViewCell.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define DEF_UICOLORFROMRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@implementation ShanNianTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label = [[UIView alloc]initWithFrame:CGRectMake(10, 5, ScreenWidth-20, kAUTOHEIGHT(158))];
    _label.backgroundColor =  [UIColor whiteColor];
    _label.layer.cornerRadius= 10;
    _label.layer.shadowColor=[UIColor grayColor].CGColor;
    _label.layer.shadowOffset=CGSizeMake(0, 4);
    _label.layer.shadowOpacity=0.4f;
    _label.layer.shadowRadius=12;
    _label.layer.borderColor = [UIColor whiteColor].CGColor;
    _label.layer.borderWidth = 2;
    [self.contentView addSubview:_label];
    _label.alpha = 0.8;
//    self.textLabel.font = [UIFont fontWithName:@"Heiti SC" size:13.f];
    
    _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 90, CGRectGetMaxY(_label.frame) - 8, 70, 6)];
    _dateLabel.textColor = [UIColor grayColor];
    _dateLabel.font = [UIFont fontWithName:@"HeiTi SC" size:7];
    _dateLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_dateLabel];
    
//    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.playBtn.frame = CGRectMake(ScreenWidth - 40, self.contentView.frame.size.height - 35, 30, 30);
//    [_label addSubview:self.playBtn];
//    [self.playBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
//    [self.playBtn setImage:[UIImage imageNamed:@"播放-暂停"] forState:UIControlStateSelected];
//    [self.playBtn addTarget:self action:@selector(clickPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
//
//    [_label addSubview:self.waveView];
    

//    self.baiSeMaskImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
//    self.baiSeMaskImageView.image = [UIImage imageNamed:@"白色蒙层2"];
//    [_label addSubview:self.baiSeMaskImageView];
    
    self.seleImage = [[UIImageView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(15), kAUTOHEIGHT(20), kAUTOWIDTH(90), _label.frame.size.height - kAUTOHEIGHT(40))];
    self.seleImage.contentMode = UIViewContentModeScaleAspectFill;
    
    self.seleImage.layer.borderWidth = 2.5;
    self.seleImage.layer.borderColor = PNCColor(255, 255, 245).CGColor;
    self.seleImage.layer.cornerRadius= 8;
    self.seleImage.layer.masksToBounds = YES;
    CALayer *subLayer=[CALayer layer];
    CGRect fixframe=self.seleImage.layer.frame;
    subLayer.frame = fixframe;
    subLayer.cornerRadius = kAUTOHEIGHT(8);
    subLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    subLayer.masksToBounds=NO;
    subLayer.shadowColor=[UIColor grayColor].CGColor;
    subLayer.shadowOffset=CGSizeMake(0,5);
    subLayer.shadowOpacity=0.9f;
    subLayer.shadowRadius= 4;
    [self.label.layer insertSublayer:subLayer below:self.seleImage.layer];
    
    //    self.seleImage.layer.cornerRadius = kAUTOHEIGHT(8);
    [_label addSubview:self.seleImage];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_seleImage.frame) + kAUTOWIDTH(30), 0, _label.frame.size.width - kAUTOWIDTH(140), _label.frame.size.height)];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font =  [UIFont fontWithName:@"FZBANGSHUXINGJW--GB1-0" size:25];
    self.titleLabel.numberOfLines = 0;
    [_label addSubview:self.titleLabel];

    
}

- (void)setContentModel:(LZDataModel *)model{
    self.model = model;
    
    UIImage *image = [ChuLiImageManager decodeEchoImageBaseWith:model.pcmData];
    self.seleImage.image = image;
    
    self.dateLabel.text = self.model.contentString;
    
    self.titleLabel.text = self.model.titleString;
   
}



- (void)clickPlayBtn:(UIButton*)sender{
    sender.selected = YES;
    sender.enabled = NO;
    [self.playBtn setImage:[UIImage imageNamed:@"播放-暂停"] forState:UIControlStateNormal];

    // 先缩小
    sender.transform = CGAffineTransformMakeScale(0.8, 0.8);
    
    // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
    [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
        // 放大
        sender.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
    
    
    
//    NSData *pcmData =  [self decodeEchoImageBaseWith:self.model.pcmData];
//    [self playPcmWith:pcmData];
    _waveView.hidden = NO;
    [_waveView Animating];
    _waveView.targetWaveHeight = 0.4;
    
    __weak typeof(self) weakSelf = self;
//    _audioPlayer.playEnd = ^(BOOL playEnd) {
//        sender.selected = NO;
//        sender.enabled = YES;
//        weakSelf.waveView.hidden = YES;
//        [weakSelf.waveView stopAnimating];
//        [self.playBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
//    };
    
    if (_cellPlayBlock != nil) {
        _cellPlayBlock();
    }
}
- (void)playPcmWith:(NSData *)pcmData{
    
    NSError *error = nil;
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
//    _audioPlayer = [[PcmPlayer alloc] initWithData:pcmData sampleRate:[@"16000" integerValue]];
//    [_audioPlayer play];
    
}

//-(NSData *)decodeEchoImageBaseWith:(NSString *)str{
//    //先解base64
//    NSData * decompressData =[[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
//    //在解GZIP压缩
//    NSData * decompressResultData = [BCShanNianKaPianManager decompressData:decompressData];
//    return  decompressResultData;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

