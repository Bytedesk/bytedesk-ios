//
//  KFDSUIApis.h
//  bdui
//
//  Created by 萝卜丝 on 2018/7/15.
//  Copyright © 2018年 Bytedesk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <bytedesk-core/bdcore.h>

@interface BDUIApis : NSObject

+ (BDUIApis *)sharedInstance;

//- (void) connect;
//
//- (void) connectWithUsername:(NSString *)username withPassword:(NSString *)password;


#pragma mark - 访客端接口


+ (void)visitorPushWorkGroupChat:(UINavigationController *)navigationController
                    withWorkGroupWid:(NSString *)wId
              withTitle:(NSString *)title;

+ (void)visitorPushWorkGroupChat:(UINavigationController *)navigationController
                withWorkGroupWid:(NSString *)wId
                       withTitle:(NSString *)title
                      withCustom:(NSDictionary *)custom;

+ (void)visitorPresentWorkGroupChat:(UINavigationController *)navigationController
                       withWorkGroupWid:(NSString *)wId
              withTitle:(NSString *)title;

+ (void)visitorPresentWorkGroupChat:(UINavigationController *)navigationController
                   withWorkGroupWid:(NSString *)wId
                          withTitle:(NSString *)title
                         withCustom:(NSDictionary *)custom;


+ (void)visitorPushAppointChat:(UINavigationController *)navigationController
                  withAgentUid:(NSString *)uId
                    withTitle:(NSString *)title;

+ (void)visitorPushAppointChat:(UINavigationController *)navigationController
                  withAgentUid:(NSString *)uId
                     withTitle:(NSString *)title
                    withCustom:(NSDictionary *)custom;


+ (void)visitorPresentAppointChat:(UINavigationController *)navigationController
                     withAgentUid:(NSString *)uId
                        withTitle:(NSString *)title;

+ (void)visitorPresentAppointChat:(UINavigationController *)navigationController
                     withAgentUid:(NSString *)uId
                        withTitle:(NSString *)title
                       withCustom:(NSDictionary *)custom;

+ (void)visitorPushFeedback:(UINavigationController *)navigationController;


#pragma mark - 客服端接口

+ (void)agentPushChat:(UINavigationController *)navigationController
       withThreadModel:(BDThreadModel *)threadModel;

+ (void)agentPushChat:(UINavigationController *)navigationController
      withThreadModel:(BDThreadModel *)threadModel
           withCustom:(NSDictionary *)custom;

+ (void)agentPresentChat:(UINavigationController *)navigationController
      withThreadModel:(BDThreadModel *)threadModel;

+ (void)agentPresentChat:(UINavigationController *)navigationController
         withThreadModel:(BDThreadModel *)threadModel
              withCustom:(NSDictionary *)custom;

+ (void)agentPushChat:(UINavigationController *)navigationController
      withContactModel:(BDContactModel *)contactModel;

+ (void)agentPushChat:(UINavigationController *)navigationController
     withContactModel:(BDContactModel *)contactModel
           withCustom:(NSDictionary *)custom;

+ (void)agentPresentChat:(UINavigationController *)navigationController
      withContactModel:(BDContactModel *)contactModel;

+ (void)agentPresentChat:(UINavigationController *)navigationController
        withContactModel:(BDContactModel *)contactModel
              withCustom:(NSDictionary *)custom;

+ (void)agentPushChat:(UINavigationController *)navigationController
      withGroupModel:(BDGroupModel *)groupModel;

+ (void)agentPushChat:(UINavigationController *)navigationController
       withGroupModel:(BDGroupModel *)groupModel
           withCustom:(NSDictionary *)custom;

+ (void)agentPresentChat:(UINavigationController *)navigationController
      withGroupModel:(BDGroupModel *)groupModel;

+ (void)agentPresentChat:(UINavigationController *)navigationController
          withGroupModel:(BDGroupModel *)groupModel
              withCustom:(NSDictionary *)custom;




#pragma mark - 公共接口




@end






