//
//  SearchViewController.m
//  PaiZhaoShiHua
//
//  Created by 北城 on 2018/10/25.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()<UIWebViewDelegate>

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *urlString = [NSString stringWithFormat:@"https://wapbaike.baidu.com/item/%@",[self encodeParameter:_keyWords]];
    NSURL *url = [NSURL URLWithString:urlString];//创建URL
    self.url = url;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}

- (NSString *)encodeParameter:(NSString *)originalPara {
    CFStringRef encodeParaCf = CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)originalPara, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8);
    NSString *encodePara = (__bridge NSString *)(encodeParaCf);
    CFRelease(encodeParaCf);
    return encodePara;
}


@end
