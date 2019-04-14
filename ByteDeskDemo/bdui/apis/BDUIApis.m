//
//  KFDSUIApis.m
//  bdui
//
//  Created by 萝卜丝 on 2018/7/15.
//  Copyright © 2018年 Bytedesk.com. All rights reserved.
//

#import "BDUIApis.h"
#import "BDChatViewController.h"
#import "BDChatWxViewController.h"
#import "BDFeedbackCategoryViewController.h"

#import <bytedesk-core/BDConfig.h>

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
    [BDConfig switchToKF];
    //
    BDChatViewController *chatViewController = [[BDChatViewController alloc] init];
    chatViewController.navigationItem.backBarButtonItem.title = @"";
    //
    [chatViewController initWithWorkGroupWid:wId withTitle:title withPush:YES];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)visitorPushWorkGroupChat:(UINavigationController *)navigationController
                withWorkGroupWid:(NSString *)wId
                       withTitle:(NSString *)title
                      withCustom:(NSDictionary *)custom {
    //
    [BDConfig switchToKF];
    //
    BDChatViewController *chatViewController = [[BDChatViewController alloc] init];
    chatViewController.navigationItem.backBarButtonItem.title = @"";
    //
    [chatViewController initWithWorkGroupWid:wId withTitle:title withPush:YES withCustom:custom];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)visitorPresentWorkGroupChat:(UINavigationController *)navigationController
                   withWorkGroupWid:(NSString *)wId
                          withTitle:(NSString *)title{
    //
    [BDConfig switchToKF];
    //
    BDChatViewController *chatViewController = [[BDChatViewController alloc] init];
    [chatViewController initWithWorkGroupWid:wId withTitle:title withPush:NO];
    //
    QMUINavigationController *chatNavigationController = [[QMUINavigationController alloc] initWithRootViewController:chatViewController];
    [navigationController presentViewController:chatNavigationController animated:YES completion:^{
        
    }];
}


+ (void)visitorPresentWorkGroupChat:(UINavigationController *)navigationController
                   withWorkGroupWid:(NSString *)wId
                          withTitle:(NSString *)title
                         withCustom:(NSDictionary *)custom {
    //
    [BDConfig switchToKF];
    //
    BDChatViewController *chatViewController = [[BDChatViewController alloc] init];
    [chatViewController initWithWorkGroupWid:wId withTitle:title withPush:NO withCustom:custom];
    //
    QMUINavigationController *chatNavigationController = [[QMUINavigationController alloc] initWithRootViewController:chatViewController];
    [navigationController presentViewController:chatNavigationController animated:YES completion:^{
        
    }];
}


+ (void)visitorPushAppointChat:(UINavigationController *)navigationController
                  withAgentUid:(NSString *)uId
                     withTitle:(NSString *)title {
    //
    [BDConfig switchToKF];
    //
    BDChatViewController *chatViewController = [[BDChatViewController alloc] init];
    chatViewController.navigationItem.backBarButtonItem.title = @"";
    //
    [chatViewController initWithAgentUid:uId withTitle:title withPush:YES];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)visitorPushAppointChat:(UINavigationController *)navigationController
                  withAgentUid:(NSString *)uId
                     withTitle:(NSString *)title
                    withCustom:(NSDictionary *)custom {
    //
    [BDConfig switchToKF];
    //
    BDChatViewController *chatViewController = [[BDChatViewController alloc] init];
    chatViewController.navigationItem.backBarButtonItem.title = @"";
    //
    [chatViewController initWithAgentUid:uId withTitle:title withPush:YES withCustom:custom];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)visitorPresentAppointChat:(UINavigationController *)navigationController
                     withAgentUid:(NSString *)uId
                        withTitle:(NSString *)title {
    //
    [BDConfig switchToKF];
    //
    BDChatViewController *chatViewController = [[BDChatViewController alloc] init];
    [chatViewController initWithAgentUid:uId withTitle:title withPush:NO];
    //
    QMUINavigationController *chatNavigationController = [[QMUINavigationController alloc] initWithRootViewController:chatViewController];
    [navigationController presentViewController:chatNavigationController animated:YES completion:^{
        
    }];
}

+ (void)visitorPresentAppointChat:(UINavigationController *)navigationController
                     withAgentUid:(NSString *)uId
                        withTitle:(NSString *)title
                       withCustom:(NSDictionary *)custom {
    //
    [BDConfig switchToKF];
    //
    BDChatViewController *chatViewController = [[BDChatViewController alloc] init];
    [chatViewController initWithAgentUid:uId withTitle:title withPush:NO withCustom:custom];
    //
    QMUINavigationController *chatNavigationController = [[QMUINavigationController alloc] initWithRootViewController:chatViewController];
    [navigationController presentViewController:chatNavigationController animated:YES completion:^{
        
    }];
}

+ (void)visitorPushFeedback:(UINavigationController *)navigationController {
    //
    [BDConfig switchToKF];
    //
    BDFeedbackCategoryViewController *categoryViewController = [[BDFeedbackCategoryViewController alloc] init];
    [navigationController pushViewController:categoryViewController animated:YES];
}

#pragma mark - IM接口

+ (void)pushChat:(UINavigationController *)navigationController
      withThreadModel:(BDThreadModel *)threadModel {
    //
    [BDConfig switchToIM];
    //
    BDChatWxViewController *chatViewController = [[BDChatWxViewController alloc] init];
    [chatViewController initWithThreadModel:threadModel withPush:YES];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)pushChat:(UINavigationController *)navigationController
      withThreadModel:(BDThreadModel *)threadModel
           withCustom:(NSDictionary *)custom {
    //
    [BDConfig switchToIM];
    //
    BDChatWxViewController *chatViewController = [[BDChatWxViewController alloc] init];
    [chatViewController initWithThreadModel:threadModel withPush:YES withCustom:custom];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)presentChat:(UINavigationController *)navigationController
         withThreadModel:(BDThreadModel *)threadModel {
    //
    [BDConfig switchToIM];
    //
    BDChatWxViewController *chatViewController = [[BDChatWxViewController alloc] init];
    [chatViewController initWithThreadModel:threadModel withPush:NO];
    //
    QMUINavigationController *chatNavigationController = [[QMUINavigationController alloc] initWithRootViewController:chatViewController];
    [navigationController presentViewController:chatNavigationController animated:YES completion:^{
        
    }];
}

+ (void)presentChat:(UINavigationController *)navigationController
         withThreadModel:(BDThreadModel *)threadModel
              withCustom:(NSDictionary *)custom {
    //
    [BDConfig switchToIM];
    //
    BDChatWxViewController *chatViewController = [[BDChatWxViewController alloc] init];
    [chatViewController initWithThreadModel:threadModel withPush:NO withCustom:custom];
    //
    QMUINavigationController *chatNavigationController = [[QMUINavigationController alloc] initWithRootViewController:chatViewController];
    [navigationController presentViewController:chatNavigationController animated:YES completion:^{
        
    }];
}

+ (void)pushChat:(UINavigationController *)navigationController
     withContactModel:(BDContactModel *)contactModel {
    //
    [BDConfig switchToIM];
    //
    BDChatWxViewController *chatViewController = [[BDChatWxViewController alloc] init];
    [chatViewController initWithContactModel:contactModel withPush:YES];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)pushChat:(UINavigationController *)navigationController
     withContactModel:(BDContactModel *)contactModel
           withCustom:(NSDictionary *)custom {
    //
    [BDConfig switchToIM];
    //
    BDChatWxViewController *chatViewController = [[BDChatWxViewController alloc] init];
    [chatViewController initWithContactModel:contactModel withPush:YES withCustom:custom];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)presentChat:(UINavigationController *)navigationController
        withContactModel:(BDContactModel *)contactModel {
    //
    [BDConfig switchToIM];
    //
    BDChatWxViewController *chatViewController = [[BDChatWxViewController alloc] init];
    [chatViewController initWithContactModel:contactModel withPush:NO];
    //
    QMUINavigationController *chatNavigationController = [[QMUINavigationController alloc] initWithRootViewController:chatViewController];
    [navigationController presentViewController:chatNavigationController animated:YES completion:^{
        
    }];
}

+ (void)presentChat:(UINavigationController *)navigationController
        withContactModel:(BDContactModel *)contactModel
              withCustom:(NSDictionary *)custom {
    //
    [BDConfig switchToIM];
    //
    BDChatWxViewController *chatViewController = [[BDChatWxViewController alloc] init];
    [chatViewController initWithContactModel:contactModel withPush:NO withCustom:custom];
    //
    QMUINavigationController *chatNavigationController = [[QMUINavigationController alloc] initWithRootViewController:chatViewController];
    [navigationController presentViewController:chatNavigationController animated:YES completion:^{
        
    }];
}

+ (void)pushChat:(UINavigationController *)navigationController
       withGroupModel:(BDGroupModel *)groupModel {
    //
    [BDConfig switchToIM];
    //
    BDChatWxViewController *chatViewController = [[BDChatWxViewController alloc] init];
    [chatViewController initWithGroupModel:groupModel withPush:YES];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)pushChat:(UINavigationController *)navigationController
       withGroupModel:(BDGroupModel *)groupModel
           withCustom:(NSDictionary *)custom {
    //
    [BDConfig switchToIM];
    //
    BDChatWxViewController *chatViewController = [[BDChatWxViewController alloc] init];
    [chatViewController initWithGroupModel:groupModel withPush:YES withCustom:custom];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)presentChat:(UINavigationController *)navigationController
          withGroupModel:(BDGroupModel *)groupModel {
    //
    [BDConfig switchToIM];
    //
    BDChatWxViewController *chatViewController = [[BDChatWxViewController alloc] init];
    [chatViewController initWithGroupModel:groupModel withPush:NO];
    //
    QMUINavigationController *chatNavigationController = [[QMUINavigationController alloc] initWithRootViewController:chatViewController];
    [navigationController presentViewController:chatNavigationController animated:YES completion:^{
        
    }];
}

+ (void)presentChat:(UINavigationController *)navigationController
          withGroupModel:(BDGroupModel *)groupModel
              withCustom:(NSDictionary *)custom {
    //
    [BDConfig switchToIM];
    //
    BDChatWxViewController *chatViewController = [[BDChatWxViewController alloc] init];
    [chatViewController initWithGroupModel:groupModel withPush:NO withCustom:custom];
    //
    QMUINavigationController *chatNavigationController = [[QMUINavigationController alloc] initWithRootViewController:chatViewController];
    [navigationController presentViewController:chatNavigationController animated:YES completion:^{
        
    }];
}

#pragma mark - 客服端接口

+ (void)agentPushChat:(UINavigationController *)navigationController
      withThreadModel:(BDThreadModel *)threadModel {
    //
    [BDConfig switchToIM];
    //
    BDChatWxViewController *chatViewController = [[BDChatWxViewController alloc] init];
    [chatViewController initWithThreadModel:threadModel withPush:YES];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)agentPushChat:(UINavigationController *)navigationController
      withThreadModel:(BDThreadModel *)threadModel
           withCustom:(NSDictionary *)custom {
    //
    [BDConfig switchToIM];
    //
    BDChatWxViewController *chatViewController = [[BDChatWxViewController alloc] init];
    [chatViewController initWithThreadModel:threadModel withPush:YES withCustom:custom];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)agentPresentChat:(UINavigationController *)navigationController
         withThreadModel:(BDThreadModel *)threadModel {
    //
    [BDConfig switchToIM];
    //
    BDChatWxViewController *chatViewController = [[BDChatWxViewController alloc] init];
    [chatViewController initWithThreadModel:threadModel withPush:NO];
    //
    QMUINavigationController *chatNavigationController = [[QMUINavigationController alloc] initWithRootViewController:chatViewController];
    [navigationController presentViewController:chatNavigationController animated:YES completion:^{
        
    }];
}

+ (void)agentPresentChat:(UINavigationController *)navigationController
         withThreadModel:(BDThreadModel *)threadModel
              withCustom:(NSDictionary *)custom {
    //
    [BDConfig switchToIM];
    //
    BDChatWxViewController *chatViewController = [[BDChatWxViewController alloc] init];
    [chatViewController initWithThreadModel:threadModel withPush:NO withCustom:custom];
    //
    QMUINavigationController *chatNavigationController = [[QMUINavigationController alloc] initWithRootViewController:chatViewController];
    [navigationController presentViewController:chatNavigationController animated:YES completion:^{
        
    }];
}

+ (void)agentPushChat:(UINavigationController *)navigationController
     withContactModel:(BDContactModel *)contactModel {
    //
    [BDConfig switchToIM];
    //
    BDChatWxViewController *chatViewController = [[BDChatWxViewController alloc] init];
    [chatViewController initWithContactModel:contactModel withPush:YES];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)agentPushChat:(UINavigationController *)navigationController
     withContactModel:(BDContactModel *)contactModel
           withCustom:(NSDictionary *)custom {
    //
    [BDConfig switchToIM];
    //
    BDChatWxViewController *chatViewController = [[BDChatWxViewController alloc] init];
    [chatViewController initWithContactModel:contactModel withPush:YES withCustom:custom];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)agentPresentChat:(UINavigationController *)navigationController
        withContactModel:(BDContactModel *)contactModel {
    //
    [BDConfig switchToIM];
    //
    BDChatWxViewController *chatViewController = [[BDChatWxViewController alloc] init];
    [chatViewController initWithContactModel:contactModel withPush:NO];
    //
    QMUINavigationController *chatNavigationController = [[QMUINavigationController alloc] initWithRootViewController:chatViewController];
    [navigationController presentViewController:chatNavigationController animated:YES completion:^{
        
    }];
}

+ (void)agentPresentChat:(UINavigationController *)navigationController
        withContactModel:(BDContactModel *)contactModel
              withCustom:(NSDictionary *)custom {
    //
    [BDConfig switchToIM];
    //
    BDChatWxViewController *chatViewController = [[BDChatWxViewController alloc] init];
    [chatViewController initWithContactModel:contactModel withPush:NO withCustom:custom];
    //
    QMUINavigationController *chatNavigationController = [[QMUINavigationController alloc] initWithRootViewController:chatViewController];
    [navigationController presentViewController:chatNavigationController animated:YES completion:^{
        
    }];
}

+ (void)agentPushChat:(UINavigationController *)navigationController
       withGroupModel:(BDGroupModel *)groupModel {
    //
    [BDConfig switchToIM];
    //
    BDChatWxViewController *chatViewController = [[BDChatWxViewController alloc] init];
    [chatViewController initWithGroupModel:groupModel withPush:YES];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)agentPushChat:(UINavigationController *)navigationController
       withGroupModel:(BDGroupModel *)groupModel
           withCustom:(NSDictionary *)custom {
    //
    [BDConfig switchToIM];
    //
    BDChatWxViewController *chatViewController = [[BDChatWxViewController alloc] init];
    [chatViewController initWithGroupModel:groupModel withPush:YES withCustom:custom];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)agentPresentChat:(UINavigationController *)navigationController
          withGroupModel:(BDGroupModel *)groupModel {
    //
    [BDConfig switchToIM];
    //
    BDChatWxViewController *chatViewController = [[BDChatWxViewController alloc] init];
    [chatViewController initWithGroupModel:groupModel withPush:NO];
    //
    QMUINavigationController *chatNavigationController = [[QMUINavigationController alloc] initWithRootViewController:chatViewController];
    [navigationController presentViewController:chatNavigationController animated:YES completion:^{
        
    }];
}

+ (void)agentPresentChat:(UINavigationController *)navigationController
          withGroupModel:(BDGroupModel *)groupModel
              withCustom:(NSDictionary *)custom {
    //
    [BDConfig switchToIM];
    //
    BDChatWxViewController *chatViewController = [[BDChatWxViewController alloc] init];
    [chatViewController initWithGroupModel:groupModel withPush:NO withCustom:custom];
    //
    QMUINavigationController *chatNavigationController = [[QMUINavigationController alloc] initWithRootViewController:chatViewController];
    [navigationController presentViewController:chatNavigationController animated:YES completion:^{
        
    }];
}

#pragma mark - 公共接口




@end







