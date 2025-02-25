//
//  HeaderDefines.h
//
//
//  Created by chenxi on 2018/3/12.
//  Copyright © 2018年 chenxi. All rights reserved.
//

#ifndef HeaderDefines_h
#define HeaderDefines_h

#import "ThirdPathKey.h"
#import <Social/Social.h> // 导入苹果自带分享的头文件

///阿里云OSS配置
#define AccessKeyId  @""
#define AccessKeySecret @""
#define OSS_Bucket @"lajifenleipic"
#define OSS_endpoint  @"oss-cn-shanghai.aliyuncs.com"
#define Yu_Ming @"https://lajifenleipic.oss-cn-shanghai.aliyuncs.com/"
#define Yu_Ming_HTTP @"http:lajifenleipic.oss-cn-shanghai.aliyuncs.com/"

#define TouXiang_URL @"timepills/"
#define PostPicture_URL @"postpicture/"

#define PostMp3_URL @"postmp3/"

#define UserAudio_URL @"useraudio/"




// iOS10 及以上需导  UserNotifications.framework
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

#define LZNavigationHeight 64
#define LZTabBarHeight 49

    //定义RGB值
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]
#define RGB(r, g, b) RGBA(r, g, b, 1.f)
#define RandomColor RGB(arc4random()%256, arc4random()%256, arc4random()%256)

//44是一个特殊的常量，默认行高和NavigationBar的高度为44
#define Default 44
//距离左边边距为10
#define LeftDistance 10
//控件间的距离
#define ControlDistance 20
//定义屏幕宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
//定义屏幕高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#pragma mark - Color
#define WhiteColor [UIColor whiteColor]
#define BlackColor [UIColor blackColor]
#define BlueColor [UIColor blueColor]
#define YellowColor [UIColor yellowColor]
#define GreenColor [UIColor greenColor]
#define OrangeColor [UIColor orangeColor]
#define ClearColor [UIColor clearColor]
#define GrayColor [UIColor grayColor]
#define CyanColor [UIColor cyanColor]
#define SkyColor RGB(38, 187, 251)
#define RedColor [UIColor redColor]
#define FenSeColor RGB(255,189,180)


//  Color
//////////////////////////////////////////////////

/**
 *    @brief    RGB颜色.
 */
#define PNCColor(r,g,b) PNCColorRGBA(r,g,b,1.0)

/**
 *    @brief    RGBA颜色.
 */
#define PNCColorRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

/**
 *    @brief    颜色设置(UIColorFromRGB(0xffee00)).
 */
#define PNCColorWithHexA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define PNCColorWithHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


/*
 *  iPhoneX判断
 */
#ifndef PNCisIPHONEX
#define PNCisIPHONEX  ((CGRectGetHeight([[UIScreen mainScreen] bounds]) == 812.0f)? (YES):(NO))
#endif

#ifndef PNCisIPAD
#define PNCisIPAD  ([[UIDevice currentDevice].model isEqualToString:@"iPad"]? (YES):(NO))
#endif


#define KAUTOSIZE(_wid,_hei)   CGSizeMake(_wid * ScreenWidth / 375.0, _hei * ScreenHeight / 667.0)
#define kAUTOWIDTH(_wid)  _wid * ScreenWidth / 375.0
#define kAUTOHEIGHT(_hei)      (PNCisIPHONEX ? _hei * 1 : _hei * ScreenHeight / 667.0)


// NSLocalizedString(key, comment) 本质
// NSlocalizeString 第一个参数是内容,根据第一个参数去对应语言的文件中取对应的字符串，第二个参数将会转化为字符串文件里的注释，可以传nil，也可以传空字符串@""。
#define NSLocalizedString(key, comment) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]

#define BCUserDeafaults [NSUserDefaults standardUserDefaults]

//是否ios7编译环境
#define BuildWithIOS7Flag YES

#ifndef PNCisIOS7Later
#define PNCisIOS7Later  !([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedAscending)
#endif

#define PCTopBarHeight                      (PNCisIPHONEX ?88.0f:((BuildWithIOS7Flag && PNCisIOS7Later) ?64.0f:44.0f))

#define PNCisIOS11Later  (([[[UIDevice currentDevice] systemVersion] floatValue] >=11.0)? (YES):(NO))

#define current_ZHUTI   @"currentzhuti"

#define current_BEIJING @"ZHUTIBEIJING"

#define PNCWeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self


// weak
#define WeakSelf __weak typeof(self)weakSelf = self
#define StrongSelf __strong typeof(weakSelf)self = weakSelf
#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
// RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
#define rgb(r,g,b) RGBA(r,g,b,1.0f)
#define rgba(r,g,b,a) RGBA(r,g,b,a)


#define KScienceTechnologyBlue  RGB(59,185,222)
#define kBackColor              RGB(9, 33, 62)
#define kVCBackColor            RGB(28, 42, 60)
#define kPicBackColor           RGB(0, 40, 90)

#define LZWeakSelf(ws) __weak typeof(self) ws = self;

#define LZWeak(sf, value) __weak typeof(value) sf = value;
//判断是否是ipad
#define isIpad ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
// Hex色值
#define LZColorFromHex(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//R G B 颜色
#define LZColorFromRGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

//008e14 三叶草绿
//09c628
#define LZColorBase LZColorFromHex(0xffffff)
#define LZFontDefaulte [UIFont systemFontOfSize:14]
#define LZColorGray LZColorFromHex(0x555555)

#define LZNavigationHeight 64
#define LZTabBarHeight 49

//数据库表格
#define LZSqliteName @"userData"
#define LZSqliteDataTableName @"newUserAccountData"
#define LZSqliteGroupTableName @"userAccountGroup"
#define LZSqliteDataPasswordKey @"passwordKey"
//数据库数据有更新的通知key
#define LZSqliteValuesChangedKey @"sqliteValuesChanged"

//////////////////////////////////////////////////
//是否ios7编译环境
#define BuildWithIOS7Flag YES
/**
 *  ios 7判断
 */
#ifndef PNCisIOS7Later
#define PNCisIOS7Later  !([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedAscending)
#endif

/**
 *  ios 8判断
 */
#ifndef PNCisIOS8Later
#define PNCisIOS8Later  !([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending)
#endif

/**
 *  ios 9判断
 */
#ifndef PNCisIOS9Later
#define PNCisIOS9Later  !([[[UIDevice currentDevice] systemVersion] compare:@"9.0" options:NSNumericSearch] == NSOrderedAscending)


#endif

/**
 *  ios 10判断
 */
#ifndef PNCisIOS10Later
#define PNCisIOS10Later  !([[[UIDevice currentDevice] systemVersion] compare:@"10.0" options:NSNumericSearch] == NSOrderedAscending)

#endif
/**
 *  ios 11判断
 */
#ifndef PNCisIOS11Later
//#define PNCisIOS11Later  !([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] == NSOrderedAscending)
#define PNCisIOS11Later  (([[[UIDevice currentDevice] systemVersion] floatValue] >=11.0)? (YES):(NO))
#endif

/**
 *  ios 11.2判断
 */
#ifndef PNCisIOS11_2Later
//#define PNCisIOS11Later  !([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] == NSOrderedAscending)
#define PNCisIOS11_2Later  (([[[UIDevice currentDevice] systemVersion] floatValue] >=11.2)? (YES):(NO))
#endif



#endif /* HeaderDefines_h */
