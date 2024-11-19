
//
//  YBCustomCameraVC.m
//  YBCustomCamera
//
//  Created by wyb on 2017/5/8.
//  Copyright © 2017年 中天易观. All rights reserved.
//

#import "ShiBieHuaViewController.h"
#import "GSScanView.h"
#import "GSLoadingAnimationView.h"
#import "LZDataModel.h"
#import "LZSqliteTool.h"



#import "HuaClassifier.h"
#import "UIImage+Utils.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>


#define KScreenWidth  [UIScreen mainScreen].bounds.size.width
#define KScreenHeight  [UIScreen mainScreen].bounds.size.height

//导入相机框架
#import <AVFoundation/AVFoundation.h>
//将拍摄好的照片写入系统相册中，所以我们在这里还需要导入一个相册需要的头文件iOS8
#import <Photos/Photos.h>

@interface ShiBieHuaViewController ()<UIAlertViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic)AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic)AVCaptureDeviceInput *input;

//当启动摄像头开始捕获输入
@property(nonatomic)AVCaptureMetadataOutput *output;

//照片输出流
@property (nonatomic)AVCaptureStillImageOutput *ImageOutPut;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic)AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;

// ------------- UI --------------
//拍照按钮
@property (nonatomic)UIButton *photoButton;
//闪光灯按钮
@property (nonatomic)UIButton *flashButton;
//聚焦
@property (nonatomic)UIView *focusView;
//是否开启闪光灯
@property (nonatomic)BOOL isflashOn;

@property (nonatomic,strong)GSScanView *scanLineView;
//加载模型进度条
@property (nonatomic, strong) GSLoadingAnimationView *downLoadAniView;
//北城的定时器
@property (nonatomic , strong)NSTimer *bcTimer;
//北城的进度条
@property (nonatomic , assign)NSInteger bcProgress;

@end

@implementation ShiBieHuaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    if ( [self checkCameraPermission]) {
        [self customCamera];
        [self createScanAnimation];
        [self initSubViews];
        [self focusAtPoint:CGPointMake(0.5, 0.5)];
    }
}

#pragma mark ==== 创建扫描动画 ====
- (void)createScanAnimation{
    self.scanLineView = [[GSScanView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scanLineView];
    [self.scanLineView stratScan];
    
    //    加载模型的进度圈
    if (!self.downLoadAniView) {
        self.downLoadAniView = [[GSLoadingAnimationView alloc]initWithFrame:CGRectMake(0, 0, 144, 144)];
        self.downLoadAniView.center = self.view.center;
        self.downLoadAniView.hidden = YES;
        [self.view addSubview:self.downLoadAniView];
    }
    self.bcProgress = 0;

}


- (void)startTimeGoOn {
    if (self.bcTimer == nil) {
        self.bcTimer = [NSTimer scheduledTimerWithTimeInterval:0.0025f target:self selector:@selector(timeGoOn) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.bcTimer forMode:NSDefaultRunLoopMode];
    }else{
        [self.bcTimer setFireDate:[NSDate distantPast]];
    }
    self.bcProgress = 0;
}

//定时器方法
- (void)timeGoOn {
    int a = 1;
    self.bcProgress += a;
    self.downLoadAniView.content = [NSString stringWithFormat:@"%ld",self.bcProgress];
    if (self.bcProgress >= 100) {
        self.downLoadAniView.content = @"100";
        [self timedestruction];
        [self shiFangDingShiQi];
        [self showfinishUI];
    }
}

//结束UI
- (void)showfinishUI{
    if (self.bcProgress == 100) {
        self.downLoadAniView.content = @"100";
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.downLoadAniView.hidden = YES;
        [self.scanLineView hiddenScan];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.scanLineView removeFromSuperview];
            [self afterTimeEnd];
        });
    });
}

//销毁时间
- (void)timedestruction {
    [self.bcTimer setFireDate:[NSDate distantFuture]];
    self.bcProgress = 0;
}

- (void)shiFangDingShiQi{
    if (self.bcTimer !=nil) {
        [self.bcTimer invalidate];
        self.bcTimer = nil;
    }
}

#pragma mark === 初始化相机 ====
- (void)customCamera{
    //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //使用设备初始化输入
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    //生成输出对象
    self.output = [[AVCaptureMetadataOutput alloc]init];
    
    self.ImageOutPut = [[AVCaptureStillImageOutput alloc]init];
    //生成会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc]init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        [self.session setSessionPreset:AVCaptureSessionPreset1280x720];
    }
    
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.ImageOutPut]) {
        [self.session addOutput:self.ImageOutPut];
    }
    
    //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];
    
    //开始启动
    [self.session startRunning];
    
    //修改设备的属性，先加锁
    if ([self.device lockForConfiguration:nil]) {
        
        //闪光灯自动
        if ([self.device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [self.device setFlashMode:AVCaptureFlashModeOff];
        }
        
        //自动白平衡
        if ([self.device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [self.device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        
        //解锁
        [self.device unlockForConfiguration];
    }
}

#pragma mark ===== 创建子视图 ======
- (void)initSubViews {
    
    
//    UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [chooseButton setFrame:CGRectMake(100, 100, 200, 200)];
//    [self.view addSubview:chooseButton];
//    [chooseButton setTitle:@"添加" forState:UIControlStateNormal];
//    chooseButton.tag = 1004;
//    chooseButton.center = self.view.center;//让button位于屏幕中央
//    //    [chooseButton setImage:[[UIImage imageNamed:@"123.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] forState:UIControlStateNormal];
//
//    [chooseButton addTarget:self action:@selector(selectedXiangCeImage) forControlEvents:UIControlEventTouchUpInside];
//
//    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(chooseButton.frame) +30, 300, 50)];
//    self.label.textColor = [UIColor blackColor];
//    [self.view addSubview:self.label];
//
    
    
    self.paiLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kAUTOHEIGHT(25),ScreenWidth, kAUTOHEIGHT(22))];
    self.paiLabel.text = @"拍照识花";
    self.paiLabel.font = [UIFont fontWithName:@"FZQKBYSJW--GB1-0" size:18];
    self.paiLabel.textColor = [UIColor whiteColor];
    self.paiLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.paiLabel];
    
    self.fanHuiBtn = [UIButton new];
    self.fanHuiBtn.frame = CGRectMake(20, 30, 20, 20);
    [self.fanHuiBtn setTitle:@"" forState:UIControlStateNormal];
    [self.fanHuiBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.fanHuiBtn addTarget:self action:@selector(disMissVc) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.fanHuiBtn];
    
    
    self.photoButton = [UIButton new];
    self.photoButton.frame = CGRectMake(KScreenWidth/2.0-30, KScreenHeight-100, 60, 60);
    [self.photoButton setImage:[UIImage imageNamed:@"photograph"] forState:UIControlStateNormal];
    [self.photoButton addTarget:self action:@selector(shutterCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.photoButton];
    
    self.focusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    self.focusView.center = self.view.center;
    self.focusView.layer.borderWidth = 1.0;
    self.focusView.layer.borderColor = [UIColor greenColor].CGColor;
    [self.view addSubview:self.focusView];
    self.focusView.hidden = YES;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitle:@"切换" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont fontWithName:@"FZQKBYSJW--GB1-0" size:15];
    leftButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [leftButton sizeToFit];
    leftButton.center = CGPointMake((KScreenWidth - 60)/2.0/2.0, KScreenHeight-70);
    [leftButton addTarget:self action:@selector(changeCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    
    
    self.flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ self.flashButton setTitle:@"相册" forState:UIControlStateNormal];
    self.flashButton.titleLabel.font = [UIFont fontWithName:@"FZQKBYSJW--GB1-0" size:15                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ];
    self.flashButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.flashButton sizeToFit];
    self.flashButton.center = CGPointMake(KScreenWidth - (KScreenWidth - 60)/2.0/2.0, KScreenHeight-70);
    [ self.flashButton addTarget:self action:@selector(selectedXiangCeImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.flashButton];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    
}

- (void)focusGesture:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusAtPoint:point];
}
- (void)focusAtPoint:(CGPoint)point{
    CGSize size = self.view.bounds.size;
    // focusPoint 函数后面Point取值范围是取景框左上角（0，0）到取景框右下角（1，1）之间,按这个来但位置就是不对，只能按上面的写法才可以。前面是点击位置的y/PreviewLayer的高度，后面是1-点击位置的x/PreviewLayer的宽度
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1 - point.x/size.width );
    
    if ([self.device lockForConfiguration:nil]) {
        
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            //曝光量调节
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        _focusView.center = point;
        _focusView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                _focusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                _focusView.hidden = YES;
            }];
        }];
    }
    
}

- (void)FlashOn{
    if ([_device lockForConfiguration:nil]) {
        if (_isflashOn) {
            if ([_device isFlashModeSupported:AVCaptureFlashModeOff]) {
                [_device setFlashMode:AVCaptureFlashModeOff];
                _isflashOn = NO;
                [_flashButton setTitle:@"闪光灯关" forState:UIControlStateNormal];
            }
        }else{
            if ([_device isFlashModeSupported:AVCaptureFlashModeOn]) {
                [_device setFlashMode:AVCaptureFlashModeOn];
                _isflashOn = YES;
                [_flashButton setTitle:@"闪光灯开" forState:UIControlStateNormal];
            }
        }
        [_device unlockForConfiguration];
    }
}

- (void)changeCamera{
    //获取摄像头的数量
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    //摄像头小于等于1的时候直接返回
    if (cameraCount <= 1) return;
    
    AVCaptureDevice *newCamera = nil;
    AVCaptureDeviceInput *newInput = nil;
    //获取当前相机的方向(前还是后)
    AVCaptureDevicePosition position = [[self.input device] position];
    
    //为摄像头的转换加转场动画
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.5;
    animation.type = @"oglFlip";
    
    if (position == AVCaptureDevicePositionFront) {
        //获取后置摄像头
        newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
        animation.subtype = kCATransitionFromLeft;
    }else{
        //获取前置摄像头
        newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
        animation.subtype = kCATransitionFromRight;
    }
    
    [self.previewLayer addAnimation:animation forKey:nil];
    //输入流
    newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
    
    
    if (newInput != nil) {
        
        [self.session beginConfiguration];
        //先移除原来的input
        [self.session removeInput:self.input];
        
        if ([self.session canAddInput:newInput]) {
            [self.session addInput:newInput];
            self.input = newInput;
            
        } else {
            //如果不能加现在的input，就加原来的input
            [self.session addInput:self.input];
        }
        
        [self.session commitConfiguration];
        
    }
    
    
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ) return device;
    return nil;
}


#pragma mark- 拍照
- (void)shutterCamera {
    AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (videoConnection ==  nil) {
        return;
    }
    
    [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        if (imageDataSampleBuffer == nil) {
            return;
        }
        
        NSData *imageData =  [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//        [self saveImageWithImage:[UIImage imageWithData:imageData]];
        self.selectedImage = [UIImage imageWithData:imageData];
        [self beginShiBie];
    }];
}

#pragma mark ===== 开始识别 =====
- (void)beginShiBie{
    self.downLoadAniView.hidden = NO;
    [self startTimeGoOn];
}

- (void)afterTimeEnd{
    
    
    
    
    self.photoButton.hidden = YES;
  
    self.bgImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.bgImageView.backgroundColor = PNCColorWithHexA(0x000000, 0.6);
    self.bgImageView.userInteractionEnabled = YES;
    
    self.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:self.effect];
    self.effectView.userInteractionEnabled = YES;
    self.effectView.frame = self.bgImageView.bounds;
    [self.view addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.effectView];
    self.effectView.alpha = 1.f;
    
    self.selectedImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(30), kAUTOHEIGHT(120), ScreenWidth - kAUTOWIDTH(60), ScreenWidth - kAUTOWIDTH(60))];
    self.selectedImageView.center = self.bgImageView.center;
    self.selectedImageView.image = self.selectedImage;
    self.selectedImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.selectedImageView.clipsToBounds = YES;
    [self.bgImageView addSubview:self.selectedImageView];
    
    self.selectedImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.selectedImageView.layer.borderWidth = 3;
    
    self.shiBieLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(10), CGRectGetMaxY(self.selectedImageView.frame) + kAUTOHEIGHT(30), ScreenWidth, kAUTOHEIGHT(22))];
    self.shiBieLabel.text = @"您的图片识别为：玫瑰花";
    self.shiBieLabel.font = [UIFont fontWithName:@"FZQKBYSJW--GB1-0" size:15];
    self.shiBieLabel.textColor = [UIColor whiteColor];
    self.shiBieLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgImageView addSubview:self.shiBieLabel];
    
    self.shiBieCancleBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shiBieCancleBtn.frame = CGRectMake(ScreenWidth/2 - kAUTOWIDTH(20), ScreenHeight - kAUTOHEIGHT(80), kAUTOWIDTH(40), kAUTOHEIGHT(40));
    [self.bgImageView addSubview:self.shiBieCancleBtn];
    [self.shiBieCancleBtn setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [self.shiBieCancleBtn addTarget:self action:@selector(cancleShiBieClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *dict = [self predictImageScene:self.selectedImage];
    self.shiBieLabel.text = [NSString stringWithFormat:@"您的图片识别为：%@",[self usePinYinToZhongWen: [self strPredictImageScene:self.selectedImage]]];
    NSLog(@"Scene label is: %@", dict);
}

- (NSString *)usePinYinToZhongWen:(NSString *)shiBieString{
    NSString *resultString = @"";
    
    if ([shiBieString isEqualToString:@"ChangShouHua"]) {
        resultString = @"长寿花";
    }else if ([shiBieString isEqualToString:@"GuiHua"]){
        resultString = @"桂花";

    }else if ([shiBieString isEqualToString:@"JiDanHua"]){
        resultString = @"鸡蛋花";

    }else if ([shiBieString isEqualToString:@"KangNaiXin"]){
        resultString = @"康乃馨";

    }else if ([shiBieString isEqualToString:@"ManTuoLuoHua"]){
        resultString = @"曼陀罗花";

    }else if ([shiBieString isEqualToString:@"MaTiLian"]){
        resultString = @"马蹄莲";

    }else if ([shiBieString isEqualToString:@"MiDieXiang"]){
        resultString = @"迷迭香";

    }else if ([shiBieString isEqualToString:@"MoLiHua"]){
        resultString = @"茉莉花";

    }else if ([shiBieString isEqualToString:@"ShanChaHua"]){
        resultString = @"山茶花";

    }else if ([shiBieString isEqualToString:@"TaoHua"]){
        resultString = @"桃花";

    }else if ([shiBieString isEqualToString:@"YingChunHua"]){
        resultString = @"迎春花";

    }else if ([shiBieString isEqualToString:@"YueJiHua"]){
        resultString = @"月季花";

    }else{
        resultString = @"weizhi";
    }
    
    return resultString;
    
}

- (void)cancleShiBieClick:(UIButton*)button{
    [self.bgImageView removeFromSuperview];
    self.scanLineView = [[GSScanView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scanLineView];
    [self.view insertSubview:self.scanLineView belowSubview:self.paiLabel];
    [self.scanLineView stratScan];
    self.photoButton.hidden = NO;
    
    [self saveShiBieImage];
}

- (void)saveShiBieImage{
    LZDataModel *model3 = [[LZDataModel alloc]init];
    model3.userName = @"";
    model3.nickName = @"0";
    model3.password = @"";
    model3.urlString = @"noDone";
    model3.dsc = @"noLike";
    model3.groupName = @"";
    //    model3.groupID = group.identifier;
    model3.titleString = self.shiBieLabel.text;
    model3.contentString = [ShiBieHuaViewController getCurrentTimes];
    model3.colorString = @"";
    
    
    UIImage *image = self.selectedImage;
    NSData * imageBackData = UIImageJPEGRepresentation(image, 0.5);
    NSData * compressCardBackStrData = [ChuLiImageManager gzipData:imageBackData];
    NSString *imageBackDataString = [compressCardBackStrData base64EncodedStringWithOptions:0];
    
    model3.pcmData = imageBackDataString;
    [LZSqliteTool LZInsertToTable:LZSqliteDataTableName model:model3];
}

/**
 * 保存图片到相册
 */
- (void)saveImageWithImage:(UIImage *)image {
    // 判断授权状态
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = nil;
            
            // 保存相片到相机胶卷
            __block PHObjectPlaceholder *createdAsset = nil;
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                createdAsset = [PHAssetCreationRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset;
            } error:&error];
            
            if (error) {
                NSLog(@"保存失败：%@", error);
                return;
            }
        });
    }];
}

- (void)disMissVc{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark- 检测相机权限
- (BOOL)checkCameraPermission {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alertView.tag = 100;
        [alertView show];
        return NO;
    }
    else{
        return YES;
    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 && alertView.tag == 100) {
        
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            
            [[UIApplication sharedApplication] openURL:url];
            
        }
    }
    
    if (buttonIndex == 1 && alertView.tag == 100) {
        
//        [self disMiss];
    }
    
}

+(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;

}
















- (NSDictionary *)predictImageScene:(UIImage *)image {
    HuaClassifier *model = [[HuaClassifier alloc] init];
    NSError *error;
    UIImage *scaledImage = [image scaleToSize:CGSizeMake(224, 224)];
    CVPixelBufferRef buffer = [image pixelBufferFromCGImage:scaledImage];
    HuaClassifierInput *input = [[HuaClassifierInput alloc] initWithImage:buffer];
    HuaClassifierOutput *output = [model predictionFromFeatures:input error:&error];
    return output.classLabelProbs;
}

- (NSString *)strPredictImageScene:(UIImage *)image {
    HuaClassifier *model = [[HuaClassifier alloc] init];
    NSError *error;
    UIImage *scaledImage = [image scaleToSize:CGSizeMake(224, 224)];
    CVPixelBufferRef buffer = [image pixelBufferFromCGImage:scaledImage];
    HuaClassifierInput *input = [[HuaClassifierInput alloc] initWithImage:buffer];
    HuaClassifierOutput *output = [model predictionFromFeatures:input error:&error];
    return output.classLabel;
}




#pragma mark  ========== 选择图片 ===========
- (void)selectedXiangCeImage{
    //初始化UIImagePickerController类
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    //判断数据来源为相册
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //设置代理
    picker.delegate = self;
    picker.allowsEditing = YES;
    //打开相册
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark ========== 图片代理回调 ===========
//选择完成回调函数
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //获取图片
    UIImage *resultImage = info[UIImagePickerControllerEditedImage];
    
//    UIButton *button = (UIButton *)[self.view viewWithTag:1004];
    
    
//    [button setImage:[resultImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];//如果按钮创建时用的是系统风格UIButtonTypeSystem，需要在设置图片一栏设置渲染模式为"使用原图"
    
    
    //    裁成边角
//    button.layer.cornerRadius = 100;
//    button.layer.masksToBounds = YES;
    
//    UIImage *image = resultImage;
    self.selectedImage = resultImage;
    [self beginShiBie];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//用户取消选择
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}























@end
