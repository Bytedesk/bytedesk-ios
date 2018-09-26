//
//  AppDelegate.m
//  demo
//
//  Created by 宁金鹏 on 2018/9/26.
//  Copyright © 2018年 宁金鹏. All rights reserved.
//

#import "AppDelegate.h"
#import <bytedesk-core/bdcore.h>
#import "ViewController.h"

#import "KFVisitorApiViewController.h"
#import "KFNavigationController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 需要替换为真实的
#define DEFAULT_TEST_APPKEY @"201809171553111"
#define DEFAULT_TEST_SUBDOMAIN @"vip"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //自定义UINavigationBar
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        // Uncomment to change the background color of navigation bar
        [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x067AB5)];
        // Uncomment to change the color of back button
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    }
    
    // Override point for customization after application launch.
    ViewController *sampleViewController = [[ViewController alloc] init];
    self.navigationController = [[KFNavigationController alloc] initWithRootViewController:sampleViewController];
    
    //适用于全屏App，需要隐藏导航条的情况，比如：游戏类
    //[self.navigationController setNavigationBarHidden:TRUE animated:FALSE];
    
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
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
}


@end
