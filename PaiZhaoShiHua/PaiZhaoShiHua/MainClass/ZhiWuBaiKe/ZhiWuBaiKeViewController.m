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
    self.url = [NSURL URLWithString:@"https://baike.baidu.com"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
