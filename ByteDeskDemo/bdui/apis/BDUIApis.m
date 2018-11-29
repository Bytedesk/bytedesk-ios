//
//  KFDSUIApis.m
//  bdui
//
//  Created by 萝卜丝 · bytedesk.com on 2018/7/15.
//  Copyright © 2018年 Bytedesk.com. All rights reserved.
//

#import "BDUIApis.h"
#import "BDChatViewController.h"

static BDUIApis *sharedInstance = nil;

@implementation BDUIApis

+ (BDUIApis *)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BDUIApis alloc] init];
    });
    return sharedInstance;
}

#pragma mark - 访客端接口

+ (void)visitorPushChat:(UINavigationController *)navigationController
                    uId:(NSString *)uId
                    wId:(NSString *)wId
              withTitle:(NSString *)title{
    //
    BDChatViewController *chatViewController = [[BDChatViewController alloc] init];
    chatViewController.navigationItem.backBarButtonItem.title = @"";
    [chatViewController initWithUid:uId wId:wId withTitle:title withPush:YES];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)visitorPresentChat:(UINavigationController *)navigationController
                       uId:(NSString *)uId
                       wId:(NSString *)wId
                 withTitle:(NSString *)title{
    
    BDChatViewController *chatViewController = [[BDChatViewController alloc] init];
    [chatViewController initWithUid:uId wId:wId withTitle:title withPush:NO];
    //
    QMUINavigationController *chatNavigationController = [[QMUINavigationController alloc] initWithRootViewController:chatViewController];
    [navigationController presentViewController:chatNavigationController animated:YES completion:^{
        
    }];
}

#pragma mark - 客服端接口

+ (void)adminPushChat:(UINavigationController *)navigationController
      withThreadModel:(BDThreadModel *)threadModel {
    //
    BDChatViewController *chatViewController = [[BDChatViewController alloc] init];
    [chatViewController initWithThreadModel:threadModel withPush:YES];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)adminPresentChat:(UINavigationController *)navigationController
         withThreadModel:(BDThreadModel *)threadModel {
    //
    BDChatViewController *chatViewController = [[BDChatViewController alloc] init];
    [chatViewController initWithThreadModel:threadModel withPush:NO];
    //
    QMUINavigationController *chatNavigationController = [[QMUINavigationController alloc] initWithRootViewController:chatViewController];
    [navigationController presentViewController:chatNavigationController animated:YES completion:^{
        
    }];
}


#pragma mark - 公共接口




@end







