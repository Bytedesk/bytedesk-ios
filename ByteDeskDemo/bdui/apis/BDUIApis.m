//
//  KFDSUIApis.m
//  bdui
//
//  Created by 萝卜丝 on 2018/7/15.
//  Copyright © 2018年 Bytedesk.com. All rights reserved.
//

#import "BDUIApis.h"
#import "BDChatKFViewController.h"
#import "BDChatIMViewController.h"
#import "BDFeedbackViewController.h"
#import "BDTicketViewController.h"
#import "BDSupportApiViewController.h"

#import <SafariServices/SafariServices.h>
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

+ (void)pushWorkGroupChat:(UINavigationController *)navigationController
                withWorkGroupWid:(NSString *)wId
                       withTitle:(NSString *)title {
    //
    [BDConfig switchToKF];
    //
    BDChatKFViewController *chatViewController = [[BDChatKFViewController alloc] init];
    chatViewController.navigationItem.backBarButtonItem.title = @"";
    //
    [chatViewController initWithWorkGroupWid:wId withTitle:title withPush:YES];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)pushWorkGroupChat:(UINavigationController *)navigationController
                withWorkGroupWid:(NSString *)wId
                       withTitle:(NSString *)title
                      withCustom:(NSDictionary *)custom {
    //
    [BDConfig switchToKF];
    //
    BDChatKFViewController *chatViewController = [[BDChatKFViewController alloc] init];
    chatViewController.navigationItem.backBarButtonItem.title = @"";
    //
    [chatViewController initWithWorkGroupWid:wId withTitle:title withPush:YES withCustom:custom];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)presentWorkGroupChat:(UINavigationController *)navigationController
                   withWorkGroupWid:(NSString *)wId
                          withTitle:(NSString *)title{
    //
    [BDConfig switchToKF];
    //
    BDChatKFViewController *chatViewController = [[BDChatKFViewController alloc] init];
    [chatViewController initWithWorkGroupWid:wId withTitle:title withPush:NO];
    //
    QMUINavigationController *chatNavigationController = [[QMUINavigationController alloc] initWithRootViewController:chatViewController];
    [navigationController presentViewController:chatNavigationController animated:YES completion:^{
        
    }];
}


+ (void)presentWorkGroupChat:(UINavigationController *)navigationController
                   withWorkGroupWid:(NSString *)wId
                          withTitle:(NSString *)title
                         withCustom:(NSDictionary *)custom {
    //
    [BDConfig switchToKF];
    //
    BDChatKFViewController *chatViewController = [[BDChatKFViewController alloc] init];
    [chatViewController initWithWorkGroupWid:wId withTitle:title withPush:NO withCustom:custom];
    //
    QMUINavigationController *chatNavigationController = [[QMUINavigationController alloc] initWithRootViewController:chatViewController];
    [navigationController presentViewController:chatNavigationController animated:YES completion:^{
        
    }];
}


+ (void)pushAppointChat:(UINavigationController *)navigationController
                  withAgentUid:(NSString *)uId
                     withTitle:(NSString *)title {
    //
    [BDConfig switchToKF];
    //
    BDChatKFViewController *chatViewController = [[BDChatKFViewController alloc] init];
    chatViewController.navigationItem.backBarButtonItem.title = @"";
    //
    [chatViewController initWithAgentUid:uId withTitle:title withPush:YES];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)pushAppointChat:(UINavigationController *)navigationController
                  withAgentUid:(NSString *)uId
                     withTitle:(NSString *)title
                    withCustom:(NSDictionary *)custom {
    //
    [BDConfig switchToKF];
    //
    BDChatKFViewController *chatViewController = [[BDChatKFViewController alloc] init];
    chatViewController.navigationItem.backBarButtonItem.title = @"";
    //
    [chatViewController initWithAgentUid:uId withTitle:title withPush:YES withCustom:custom];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)presentAppointChat:(UINavigationController *)navigationController
                     withAgentUid:(NSString *)uId
                        withTitle:(NSString *)title {
    //
    [BDConfig switchToKF];
    //
    BDChatKFViewController *chatViewController = [[BDChatKFViewController alloc] init];
    [chatViewController initWithAgentUid:uId withTitle:title withPush:NO];
    //
    QMUINavigationController *chatNavigationController = [[QMUINavigationController alloc] initWithRootViewController:chatViewController];
    [navigationController presentViewController:chatNavigationController animated:YES completion:^{
        
    }];
}

+ (void)presentAppointChat:(UINavigationController *)navigationController
                     withAgentUid:(NSString *)uId
                        withTitle:(NSString *)title
                       withCustom:(NSDictionary *)custom {
    //
    [BDConfig switchToKF];
    //
    BDChatKFViewController *chatViewController = [[BDChatKFViewController alloc] init];
    [chatViewController initWithAgentUid:uId withTitle:title withPush:NO withCustom:custom];
    //
    QMUINavigationController *chatNavigationController = [[QMUINavigationController alloc] initWithRootViewController:chatViewController];
    [navigationController presentViewController:chatNavigationController animated:YES completion:^{
        
    }];
}

+ (void)pushFeedback:(UINavigationController *)navigationController withAdminUid:(NSString *)uid {
    //
    [BDConfig switchToKF];
    //
    BDFeedbackViewController *feedbackViewController = [[BDFeedbackViewController alloc] init];
    [feedbackViewController initWithUid:uid];
    //
    [navigationController pushViewController:feedbackViewController animated:YES];
}

+ (void)pushTicket:(UINavigationController *)navigationController withAdminUid:(NSString *)uid {
    //
    [BDConfig switchToKF];
    //
    BDTicketViewController *ticketViewController = [[BDTicketViewController alloc] init];
    [ticketViewController initWithUid:uid];
    //
    [navigationController pushViewController:ticketViewController animated:YES];
}

+ (void)pushSupportApi:(UINavigationController *)navigationController withAdminUid:(NSString *)uid {
    //
    [BDConfig switchToKF];
    //
    BDSupportApiViewController *supportViewController = [[BDSupportApiViewController alloc] init];
    [supportViewController initWithUid:uid];
    //
    [navigationController pushViewController:supportViewController animated:YES];
}

+ (void)presentSupportURL:(UINavigationController *)navigationController withAdminUid:(NSString *)uid {
    //
    [BDConfig switchToKF];
    //
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.bytedesk.com/support?uid=%@&ph=ph", uid]];
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
//    safariVC.delegate = self;
//    [navigationController pushViewController:safariVC animated:YES];
    // 建议
    [navigationController presentViewController:safariVC animated:YES completion:^{
    }];
}


#pragma mark - IM接口

+ (void)pushChat:(UINavigationController *)navigationController
      withThreadModel:(BDThreadModel *)threadModel {
    //
    [BDConfig switchToIM];
    //
    BDChatIMViewController *chatViewController = [[BDChatIMViewController alloc] init];
    [chatViewController initWithThreadModel:threadModel withPush:YES];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)pushChat:(UINavigationController *)navigationController
      withThreadModel:(BDThreadModel *)threadModel
           withCustom:(NSDictionary *)custom {
    //
    [BDConfig switchToIM];
    //
    BDChatIMViewController *chatViewController = [[BDChatIMViewController alloc] init];
    [chatViewController initWithThreadModel:threadModel withPush:YES withCustom:custom];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)presentChat:(UINavigationController *)navigationController
         withThreadModel:(BDThreadModel *)threadModel {
    //
    [BDConfig switchToIM];
    //
    BDChatIMViewController *chatViewController = [[BDChatIMViewController alloc] init];
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
    BDChatIMViewController *chatViewController = [[BDChatIMViewController alloc] init];
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
    BDChatIMViewController *chatViewController = [[BDChatIMViewController alloc] init];
    [chatViewController initWithContactModel:contactModel withPush:YES];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)pushChat:(UINavigationController *)navigationController
     withContactModel:(BDContactModel *)contactModel
           withCustom:(NSDictionary *)custom {
    //
    [BDConfig switchToIM];
    //
    BDChatIMViewController *chatViewController = [[BDChatIMViewController alloc] init];
    [chatViewController initWithContactModel:contactModel withPush:YES withCustom:custom];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)presentChat:(UINavigationController *)navigationController
        withContactModel:(BDContactModel *)contactModel {
    //
    [BDConfig switchToIM];
    //
    BDChatIMViewController *chatViewController = [[BDChatIMViewController alloc] init];
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
    BDChatIMViewController *chatViewController = [[BDChatIMViewController alloc] init];
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
    BDChatIMViewController *chatViewController = [[BDChatIMViewController alloc] init];
    [chatViewController initWithGroupModel:groupModel withPush:YES];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)pushChat:(UINavigationController *)navigationController
       withGroupModel:(BDGroupModel *)groupModel
           withCustom:(NSDictionary *)custom {
    //
    [BDConfig switchToIM];
    //
    BDChatIMViewController *chatViewController = [[BDChatIMViewController alloc] init];
    [chatViewController initWithGroupModel:groupModel withPush:YES withCustom:custom];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)presentChat:(UINavigationController *)navigationController
          withGroupModel:(BDGroupModel *)groupModel {
    //
    [BDConfig switchToIM];
    //
    BDChatIMViewController *chatViewController = [[BDChatIMViewController alloc] init];
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
    BDChatIMViewController *chatViewController = [[BDChatIMViewController alloc] init];
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
    BDChatIMViewController *chatViewController = [[BDChatIMViewController alloc] init];
    [chatViewController initWithThreadModel:threadModel withPush:YES];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)agentPushChat:(UINavigationController *)navigationController
      withThreadModel:(BDThreadModel *)threadModel
           withCustom:(NSDictionary *)custom {
    //
    [BDConfig switchToIM];
    //
    BDChatIMViewController *chatViewController = [[BDChatIMViewController alloc] init];
    [chatViewController initWithThreadModel:threadModel withPush:YES withCustom:custom];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)agentPresentChat:(UINavigationController *)navigationController
         withThreadModel:(BDThreadModel *)threadModel {
    //
    [BDConfig switchToIM];
    //
    BDChatIMViewController *chatViewController = [[BDChatIMViewController alloc] init];
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
    BDChatIMViewController *chatViewController = [[BDChatIMViewController alloc] init];
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
    BDChatIMViewController *chatViewController = [[BDChatIMViewController alloc] init];
    [chatViewController initWithContactModel:contactModel withPush:YES];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)agentPushChat:(UINavigationController *)navigationController
     withContactModel:(BDContactModel *)contactModel
           withCustom:(NSDictionary *)custom {
    //
    [BDConfig switchToIM];
    //
    BDChatIMViewController *chatViewController = [[BDChatIMViewController alloc] init];
    [chatViewController initWithContactModel:contactModel withPush:YES withCustom:custom];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)agentPresentChat:(UINavigationController *)navigationController
        withContactModel:(BDContactModel *)contactModel {
    //
    [BDConfig switchToIM];
    //
    BDChatIMViewController *chatViewController = [[BDChatIMViewController alloc] init];
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
    BDChatIMViewController *chatViewController = [[BDChatIMViewController alloc] init];
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
    BDChatIMViewController *chatViewController = [[BDChatIMViewController alloc] init];
    [chatViewController initWithGroupModel:groupModel withPush:YES];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)agentPushChat:(UINavigationController *)navigationController
       withGroupModel:(BDGroupModel *)groupModel
           withCustom:(NSDictionary *)custom {
    //
    [BDConfig switchToIM];
    //
    BDChatIMViewController *chatViewController = [[BDChatIMViewController alloc] init];
    [chatViewController initWithGroupModel:groupModel withPush:YES withCustom:custom];
    [navigationController pushViewController:chatViewController animated:YES];
}

+ (void)agentPresentChat:(UINavigationController *)navigationController
          withGroupModel:(BDGroupModel *)groupModel {
    //
    [BDConfig switchToIM];
    //
    BDChatIMViewController *chatViewController = [[BDChatIMViewController alloc] init];
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
    BDChatIMViewController *chatViewController = [[BDChatIMViewController alloc] init];
    [chatViewController initWithGroupModel:groupModel withPush:NO withCustom:custom];
    //
    QMUINavigationController *chatNavigationController = [[QMUINavigationController alloc] initWithRootViewController:chatViewController];
    [navigationController presentViewController:chatNavigationController animated:YES completion:^{

    }];
}

#pragma mark - 公共接口




@end







