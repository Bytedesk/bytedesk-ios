//
//  KFDSUIApis.m
//  bdui
//
//  Created by 萝卜丝 on 2018/7/15.
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

+ (void)visitorPushWorkGroupChat:(UINavigationController *)navigationController
                withWorkGroupWid:(NSString *)wId
                       withTitle:(NSString *)title {
    //
    BDChatViewController *chatViewController = [[BDChatViewController alloc] init];
    chatViewController.navigationItem.backBarButtonItem.title = @"";
    //
    [chatViewController initWithWorkGroupWid:wId withTitle:title withPush:YES];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)visitorPresentWorkGroupChat:(UINavigationController *)navigationController
                   withWorkGroupWid:(NSString *)wId
                          withTitle:(NSString *)title{
    
    BDChatViewController *chatViewController = [[BDChatViewController alloc] init];
    [chatViewController initWithWorkGroupWid:wId withTitle:title withPush:NO];
    //
    QMUINavigationController *chatNavigationController = [[QMUINavigationController alloc] initWithRootViewController:chatViewController];
    [navigationController presentViewController:chatNavigationController animated:YES completion:^{
        
    }];
}

+ (void)visitorPushAppointChat:(UINavigationController *)navigationController
                  withAgentUid:(NSString *)uId
                     withTitle:(NSString *)title {
    //
    BDChatViewController *chatViewController = [[BDChatViewController alloc] init];
    chatViewController.navigationItem.backBarButtonItem.title = @"";
    //
    [chatViewController initWithAgentUid:uId withTitle:title withPush:YES];
    [navigationController pushViewController:chatViewController animated:YES];
}


+ (void)visitorPresentAppointChat:(UINavigationController *)navigationController
                     withAgentUid:(NSString *)uId
                        withTitle:(NSString *)title {
    //
    BDChatViewController *chatViewController = [[BDChatViewController alloc] init];
    [chatViewController initWithAgentUid:uId withTitle:title withPush:NO];
    //
    QMUINavigationController *chatNavigationController = [[QMUINavigationController alloc] initWithRootViewController:chatViewController];
    [navigationController presentViewController:chatNavigationController animated:YES completion:^{
        
    }];
}

#pragma mark - 客服端接口

+ (void)agentPushChat:(UINavigationController *)navigationController
      withThreadModel:(BDThreadModel *)threadModel {
    //
    BDChatViewController *chatViewController = [[BDChatViewController alloc] init];
    [chatViewController initWithThreadModel:threadModel withPush:YES];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)agentPresentChat:(UINavigationController *)navigationController
         withThreadModel:(BDThreadModel *)threadModel {
    //
    BDChatViewController *chatViewController = [[BDChatViewController alloc] init];
    [chatViewController initWithThreadModel:threadModel withPush:NO];
    //
    QMUINavigationController *chatNavigationController = [[QMUINavigationController alloc] initWithRootViewController:chatViewController];
    [navigationController presentViewController:chatNavigationController animated:YES completion:^{
        
    }];
}

+ (void)agentPushChat:(UINavigationController *)navigationController
     withContactModel:(BDContactModel *)contactModel {
    //
    BDChatViewController *chatViewController = [[BDChatViewController alloc] init];
    [chatViewController initWithContactModel:contactModel withPush:YES];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)agentPresentChat:(UINavigationController *)navigationController
        withContactModel:(BDContactModel *)contactModel {
    //
    BDChatViewController *chatViewController = [[BDChatViewController alloc] init];
    [chatViewController initWithContactModel:contactModel withPush:NO];
    //
    QMUINavigationController *chatNavigationController = [[QMUINavigationController alloc] initWithRootViewController:chatViewController];
    [navigationController presentViewController:chatNavigationController animated:YES completion:^{
        
    }];
}

+ (void)agentPushChat:(UINavigationController *)navigationController
       withGroupModel:(BDGroupModel *)groupModel {
    //
    BDChatViewController *chatViewController = [[BDChatViewController alloc] init];
    [chatViewController initWithGroupModel:groupModel withPush:YES];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)agentPresentChat:(UINavigationController *)navigationController
          withGroupModel:(BDGroupModel *)groupModel {
    //
    BDChatViewController *chatViewController = [[BDChatViewController alloc] init];
    [chatViewController initWithGroupModel:groupModel withPush:NO];
    //
    QMUINavigationController *chatNavigationController = [[QMUINavigationController alloc] initWithRootViewController:chatViewController];
    [navigationController presentViewController:chatNavigationController animated:YES completion:^{
        
    }];
}

#pragma mark - 公共接口




@end







