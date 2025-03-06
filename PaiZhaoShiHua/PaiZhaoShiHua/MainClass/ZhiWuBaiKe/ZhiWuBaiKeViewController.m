//
//  ZhiWuBaiKeViewController.m
//  PaiZhaoShiHua
//
//  Created by 北城 on 2018/11/12.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import "ZhiWuBaiKeViewController.h"

@interface ZhiWuBaiKeViewController ()

@end

@implementation ZhiWuBaiKeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (_urlstring.length > 0) {
        self.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://baike.baidu.com/item/",self.urlstring]];
    }else{
        self.url = [NSURL URLWithString:@"https://baike.baidu.com"];
    }
   
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
