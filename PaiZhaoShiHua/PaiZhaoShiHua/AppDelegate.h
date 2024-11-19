//
//  AppDelegate.h
//  PaiZhaoShiHua
//
//  Created by 北城 on 2018/10/24.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

