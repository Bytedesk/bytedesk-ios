//
//  AppDelegate.m
//  demo
//
//  Created by 萝卜丝 on 2018/11/22.
//  Copyright © 2018年 Bytedesk.com. All rights reserved.
//

#import "AppDelegate.h"
#import <bytedesk-core/bdcore.h>

#import "BDApisTableViewController.h"
#import "KFKeFuApiViewController.h"
#import "KFIMApiViewController.h"

//#import "KFNavigationController.h"
#import "QDCommonUI.h"
#import "QDNavigationController.h"
#import "QMUIConfigurationTemplateGrapefruit.h"
#import "QMUIConfigurationTemplateGrass.h"
#import "QMUIConfigurationTemplatePinkRose.h"
#import "QMUIConfigurationTemplateDark.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 添加DDASLLogger，你的日志语句将被发送到Xcode控制台
//    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    // 添加DDTTYLogger，你的日志语句将被发送到Console.app
    // [DDLog addLogger:[DDASLLogger sharedInstance]];
    
    [self initQMUI];
    
//    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(userDidTakeScreenshot:)
//                                                 name:UIApplicationUserDidTakeScreenshotNotification object:nil];

    [UINavigationBar appearance].barTintColor = UIColor.qd_tintColor;
    // 界面
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //
    BDApisTableViewController *apisTableViewController = [[BDApisTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    QDNavigationController *aipNavigationController = [[QDNavigationController alloc] initWithRootViewController:apisTableViewController];
    self.window.rootViewController = aipNavigationController;
    [self.window makeKeyAndVisible];
    
    if ([BDSettings isAlreadyLogin]) {
        // 建立长连接
        [BDCoreApis connect];
        // 注册离线消息推送
        if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            // iOS 8 Notifications
            [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
            
            [application registerForRemoteNotifications];
        }
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [BDCoreApis didEnterBackground];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [BDCoreApis willEnterForground];
    // TODO: 增加网络检测，如果无网络则提示
    // TODO: 根据实际未读数目设置AppIcon数字
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //
    if ([BDSettings isAlreadyLogin]) {
        // 建立长连接
        [BDCoreApis connect];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [BDCoreApis willTerminate];
}

#pragma mark - 离线消息推送

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //
    NSString *uploadToken;
    if (@available(iOS 13.0, *)) {
        NSMutableString *deviceTokenString = [NSMutableString string];
        const char *bytes = deviceToken.bytes;
        NSInteger count = deviceToken.length;
        for (int i = 0; i < count; i++) {
            [deviceTokenString appendFormat:@"%02x", bytes[i]&0x000000FF];
        }
        //
        NSLog(@"token 13 %@", deviceTokenString);
        uploadToken = deviceTokenString;
    } else {
        //同步deviceToken便于离线消息推送, 同时必须在管理后台上传 .pem文件才能生效
        NSString* newToken = [deviceToken description];
        DDLogInfo(@"%s, newToken %@", __PRETTY_FUNCTION__, newToken);
        newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
        // upload deviceToken: 4a89d8b0e971a3ff0ae6d1712ac62fa6bc1d6099756fa71b5d98d1708d12dfca
        DDLogInfo(@"%s, deviceToken:%@", __PRETTY_FUNCTION__, newToken);
        uploadToken = newToken;
    }
    // TODO: 判断是否已经上传，无需重复上传；如果没有上传，则引导提示用户开启推送
    [BDCoreApis updateDeviceToken:uploadToken resultSuccess:^(NSDictionary *dict) {
        //
        NSString *message = [dict objectForKey:@"message"];
        NSNumber *status_code = [dict objectForKey:@"status_code"];
        DDLogInfo(@"%s, message: %@, code: %@", __PRETTY_FUNCTION__, message, status_code);
        
        if ([status_code isEqualToNumber:[NSNumber numberWithInt:200]]) {
            
        } else {
//            [self showLoginVC];
        }
        
    } resultFailed:^(NSError *error) {
        DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, error);
    }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"收到推送消息。%@", userInfo);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //NSLog(@"注册推送失败，原因：%@",error);
}


#pragma mark - 初始化QMUI

-(void) initQMUI {
    
    // 1. 先注册主题监听，在回调里将主题持久化存储，避免启动过程中主题发生变化时读取到错误的值
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleThemeDidChangeNotification:) name:QMUIThemeDidChangeNotification object:nil];
    
    // 2. 然后设置主题的生成器
    QMUIThemeManagerCenter.defaultThemeManager.themeGenerator = ^__kindof NSObject * _Nonnull(NSString * _Nonnull identifier) {
        if ([identifier isEqualToString:QDThemeIdentifierDefault]) return QMUIConfigurationTemplate.new;
        if ([identifier isEqualToString:QDThemeIdentifierGrapefruit]) return QMUIConfigurationTemplateGrapefruit.new;
        if ([identifier isEqualToString:QDThemeIdentifierGrass]) return QMUIConfigurationTemplateGrass.new;
        if ([identifier isEqualToString:QDThemeIdentifierPinkRose]) return QMUIConfigurationTemplatePinkRose.new;
        if ([identifier isEqualToString:QDThemeIdentifierDark]) return QMUIConfigurationTemplateDark.new;
        return nil;
    };
    
    // 3. 再针对 iOS 13 开启自动响应系统的 Dark Mode 切换
    // 如果不需要这个功能，则不需要这一段代码
    if (@available(iOS 13.0, *)) {
        // 做这个 if(currentThemeIdentifier) 的保护只是为了避免 QD 里的配置表没启动时，没人为 currentTheme/currentThemeIdentifier 赋值，导致后续的逻辑会 crash，业务项目里理论上不会有这种情况出现，所以可以省略这个 if 块
        if (QMUIThemeManagerCenter.defaultThemeManager.currentThemeIdentifier) {
            QMUIThemeManagerCenter.defaultThemeManager.identifierForTrait = ^__kindof NSObject<NSCopying> * _Nonnull(UITraitCollection * _Nonnull trait) {
                if (trait.userInterfaceStyle == UIUserInterfaceStyleDark) {
                    return QDThemeIdentifierDark;
                }
                
                if ([QMUIThemeManagerCenter.defaultThemeManager.currentThemeIdentifier isEqual:QDThemeIdentifierDark]) {
                    return QDThemeIdentifierDefault;
                }
                
                return QMUIThemeManagerCenter.defaultThemeManager.currentThemeIdentifier;
            };
            QMUIThemeManagerCenter.defaultThemeManager.respondsSystemStyleAutomatically = YES;
        }
    }
    
//    QMUIThemeManagerCenter.defaultThemeManager.currentThemeIdentifier = @"Default";
    // QMUIConsole 默认只在 DEBUG 下会显示，作为 Demo，改为不管什么环境都允许显示
//    [QMUIConsole sharedInstance].canShow = YES;
    // QD自定义的全局样式渲染
    [QDCommonUI renderGlobalAppearances];

}

- (void)handleThemeDidChangeNotification:(NSNotification *)notification {
    
    QMUIThemeManager *manager = notification.object;
    if (![manager.name isEqual:QMUIThemeManagerNameDefault]) return;
    
    [[NSUserDefaults standardUserDefaults] setObject:manager.currentThemeIdentifier forKey:QDSelectedThemeIdentifier];
    
    [QDThemeManager.currentTheme applyConfigurationTemplate];
    
    // 主题发生变化，在这里更新全局 UI 控件的 appearance
    [QDCommonUI renderGlobalAppearances];
    // 更新表情 icon 的颜色
//    [QDUIHelper updateEmotionImages];
}


//#pragma mark - 截屏响应
//
//- (void)userDidTakeScreenshot:(NSNotification *)notification {
//    //
//    DDLogInfo(@"检测到截屏");
//    //人为截屏, 模拟用户截屏行为, 获取所截图片
//    UIImage *image_ = [self imageWithScreenshot];
//    //添加显示
//    UIImageView *imgvPhoto = [[UIImageView alloc]initWithImage:image_];
//    imgvPhoto.frame = CGRectMake(self.window.frame.size.width/2, self.window.frame.size.height/2, self.window.frame.size.width/2, self.window.frame.size.height/2);
//    //添加边框
//    CALayer * layer = [imgvPhoto layer];
//    layer.borderColor = [[UIColor whiteColor] CGColor];
//    layer.borderWidth = 5.0f;
//    //添加四个边阴影
//    imgvPhoto.layer.shadowColor = [UIColor blackColor].CGColor;
//    imgvPhoto.layer.shadowOffset = CGSizeMake(0, 0);
//    imgvPhoto.layer.shadowOpacity = 0.5;
//    imgvPhoto.layer.shadowRadius = 10.0;
//    //添加两个边阴影
//    imgvPhoto.layer.shadowColor = [UIColor blackColor].CGColor;
//    imgvPhoto.layer.shadowOffset = CGSizeMake(4, 4);
//    imgvPhoto.layer.shadowOpacity = 0.5;
//    imgvPhoto.layer.shadowRadius = 2.0;
//
//    [self.window addSubview:imgvPhoto];
//}
//
///**
// *  截取当前屏幕
// *
// *  @return NSData *
// */
//- (NSData *)dataWithScreenshotInPNGFormat {
//    //
//    CGSize imageSize = CGSizeZero;
//    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//    if (UIInterfaceOrientationIsPortrait(orientation))
//        imageSize = [UIScreen mainScreen].bounds.size;
//    else
//        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
//
//    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    for (UIWindow *window in [[UIApplication sharedApplication] windows])
//    {
//        CGContextSaveGState(context);
//        CGContextTranslateCTM(context, window.center.x, window.center.y);
//        CGContextConcatCTM(context, window.transform);
//        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
//        if (orientation == UIInterfaceOrientationLandscapeLeft)
//        {
//            CGContextRotateCTM(context, M_PI_2);
//            CGContextTranslateCTM(context, 0, -imageSize.width);
//        }
//        else if (orientation == UIInterfaceOrientationLandscapeRight)
//        {
//            CGContextRotateCTM(context, -M_PI_2);
//            CGContextTranslateCTM(context, -imageSize.height, 0);
//        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
//            CGContextRotateCTM(context, M_PI);
//            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
//        }
//        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
//        {
//            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
//        }
//        else{
//            [window.layer renderInContext:context];
//        }
//        CGContextRestoreGState(context);
//    }
//
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    return UIImagePNGRepresentation(image);
//}
//
///**
// *  返回截取到的图片
// *
// *  @return UIImage *
// */
//- (UIImage *)imageWithScreenshot {
//    NSData *imageData = [self dataWithScreenshotInPNGFormat];
//    return [UIImage imageWithData:imageData];
//}

@end
