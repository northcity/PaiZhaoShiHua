//
//  AppDelegate.m
//  PaiZhaoShiHua
//
//  Created by 北城 on 2018/10/24.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import "AppDelegate.h"
#import "HomePageViewController.h"

// 10.18
//#import "LZGestureTool.h"
//#import "LZGestureScreen.h"
//#import "TouchIdUnlock.h"
#import "LZSqliteTool.h"
#import "LZiCloud.h"
#import "LaunchViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)jiaZaiVc{
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    LaunchViewController *Lvc = [[LaunchViewController alloc]init];
    UINavigationController*nav = [[UINavigationController alloc]initWithRootViewController:Lvc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [self initRootVc];
    [self jiaZaiVc];
    [self createSqlite];
    return YES;
}

- (void)createSqlite {
    [LZSqliteTool LZCreateSqliteWithName:LZSqliteName];
    [LZSqliteTool LZDefaultDataBase];
    [LZSqliteTool LZCreateDataTableWithName:LZSqliteDataTableName];
    [LZSqliteTool LZCreateGroupTableWithName:LZSqliteGroupTableName];
    [LZSqliteTool createPswTableWithName:LZSqliteDataPasswordKey];
    
    NSInteger groups = [LZSqliteTool LZSelectElementCountFromTable:LZSqliteGroupTableName];
    NSInteger count = [LZSqliteTool LZSelectElementCountFromTable:LZSqliteDataTableName];
    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
    BOOL isDataInit = [[us objectForKey:@"dataAlreadyInit"] boolValue];
        if (count <= 0 && groups <= 0 && !isDataInit) {
            [self creatData];
        }
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    BOOL isPswAlreadySaved = [[df objectForKey:@"pswAlreadySavedKey"] boolValue];
    
    if (!isPswAlreadySaved) {
        NSString *psw = [df objectForKey:@"redomSavedKey"];
        
        if (psw.length > 0) {
            
            [LZSqliteTool LZInsertToPswTable:LZSqliteDataPasswordKey passwordKey:LZSqliteDataPasswordKey passwordValue:psw];
        }
        
        [df setBool:YES forKey:@"pswAlreadySavedKey"];
    }
}


- (void)creatData {
    LZDataModel *model = [[LZDataModel alloc]init];
    model.userName = @"";
    model.nickName = @"";
    model.password = @"";
    model.urlString = @"";
    model.groupName = @"";
    model.email = @"";
    model.dsc = @"";
    //    model.groupID = group2.identifier;
    model.titleString = @"";
    model.contentString = @"";
    model.colorString = @"";
    
    [LZSqliteTool LZInsertToTable:LZSqliteDataTableName model:model];
    
    LZDataModel *model1 = [[LZDataModel alloc]init];
    model1.userName = @"";
    model1.nickName = @"";
    model1.password = @"";
    //    model1.groupID = group1.identifier;
    model1.groupName = @"";
    model1.email = @"";
    model1.dsc = @"QQ号";
    model1.titleString = @"";
    model1.contentString = @"";
    model1.colorString = @"";
    [LZSqliteTool LZInsertToTable:LZSqliteDataTableName model:model1];
    
    LZDataModel *model2 = [[LZDataModel alloc]init];
    model2.userName = @"";
    model2.nickName = @"";
    model2.password = @"";
    
    model2.groupName = @"";
    model2.email = @"";
    //    model2.groupID = group.identifier;
    model2.titleString = @"";
    model2.contentString = @"";
    model2.colorString = @"";
    
    [LZSqliteTool LZInsertToTable:LZSqliteDataTableName model:model2];
    
    LZDataModel *model3 = [[LZDataModel alloc]init];
    model3.userName = @"";
    model3.nickName = @"";
    model3.password = @"";
    model3.urlString = @"";
    model3.groupName = @"";
    //    model3.groupID = group.identifier;
    model3.titleString = @"";
    model3.contentString = @"";
    model3.colorString = @"";
    [LZSqliteTool LZInsertToTable:LZSqliteDataTableName model:model3];
}

- (void)initRootVc{
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    HomePageViewController *Lvc = [[HomePageViewController alloc]init];
    UINavigationController*nav = [[UINavigationController alloc]initWithRootViewController:Lvc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"PaiZhaoShiHua"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
