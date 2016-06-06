//
//  AppDelegate.m
//  WanZhuanDaiKuan
//
//  Created by 张保国 on 15/7/20.
//  Copyright © 2015年 ZhangBaoGuo. All rights reserved.
//

#import "AppDelegate.h"
#import "EntryRETVC.h"
#import "WXApi.h"
#import "ShareRETVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //添加以下语句才能运行
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    UINavigationController *navigationController=[[UINavigationController alloc] initWithRootViewController:[[EntryRETVC alloc] initWithStyle:UITableViewStyleGrouped]];
    self.window.rootViewController=navigationController;
    
    //向微信注册id
    [WXApi registerApp:@"wxa5ccf3b12ec95621"];
    return YES;
}


-(BOOL)application:(nonnull UIApplication *)application openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation{
    NSLog(@"%@",url);                  // myUrl://11
    NSLog(@"%@",sourceApplication);    // 访问url app的bundle identifier,例如：com.youCompany.appName
    //NSLog(@"%@",annotation);           // (null)
    return [WXApi handleOpenURL:url delegate:[ShareRETVC new]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
