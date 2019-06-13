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

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 @param wId <#wId description#>
 @param title <#title description#>
 */
+ (void)visitorPushWorkGroupChat:(UINavigationController *)navigationController
                    withWorkGroupWid:(NSString *)wId
              withTitle:(NSString *)title;

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 @param wId <#wId description#>
 @param title <#title description#>
 @param custom <#custom description#>
 */
+ (void)visitorPushWorkGroupChat:(UINavigationController *)navigationController
                withWorkGroupWid:(NSString *)wId
                       withTitle:(NSString *)title
                      withCustom:(NSDictionary *)custom;

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 @param wId <#wId description#>
 @param title <#title description#>
 */
+ (void)visitorPresentWorkGroupChat:(UINavigationController *)navigationController
                       withWorkGroupWid:(NSString *)wId
              withTitle:(NSString *)title;

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 @param wId <#wId description#>
 @param title <#title description#>
 @param custom <#custom description#>
 */
+ (void)visitorPresentWorkGroupChat:(UINavigationController *)navigationController
                   withWorkGroupWid:(NSString *)wId
                          withTitle:(NSString *)title
                         withCustom:(NSDictionary *)custom;

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 @param uId <#uId description#>
 @param title <#title description#>
 */
+ (void)visitorPushAppointChat:(UINavigationController *)navigationController
                  withAgentUid:(NSString *)uId
                    withTitle:(NSString *)title;

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 @param uId <#uId description#>
 @param title <#title description#>
 @param custom <#custom description#>
 */
+ (void)visitorPushAppointChat:(UINavigationController *)navigationController
                  withAgentUid:(NSString *)uId
                     withTitle:(NSString *)title
                    withCustom:(NSDictionary *)custom;

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 @param uId <#uId description#>
 @param title <#title description#>
 */
+ (void)visitorPresentAppointChat:(UINavigationController *)navigationController
                     withAgentUid:(NSString *)uId
                        withTitle:(NSString *)title;

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 @param uId <#uId description#>
 @param title <#title description#>
 @param custom <#custom description#>
 */
+ (void)visitorPresentAppointChat:(UINavigationController *)navigationController
                     withAgentUid:(NSString *)uId
                        withTitle:(NSString *)title
                       withCustom:(NSDictionary *)custom;

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 */
+ (void)visitorPushFeedback:(UINavigationController *)navigationController;

#pragma mark - IM打开聊天界面接口

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 @param threadModel <#threadModel description#>
 */
+ (void)pushChat:(UINavigationController *)navigationController
      withThreadModel:(BDThreadModel *)threadModel;

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 @param threadModel <#threadModel description#>
 @param custom <#custom description#>
 */
+ (void)pushChat:(UINavigationController *)navigationController
      withThreadModel:(BDThreadModel *)threadModel
           withCustom:(NSDictionary *)custom;

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 @param threadModel <#threadModel description#>
 */
+ (void)presentChat:(UINavigationController *)navigationController
         withThreadModel:(BDThreadModel *)threadModel;

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 @param threadModel <#threadModel description#>
 @param custom <#custom description#>
 */
+ (void)presentChat:(UINavigationController *)navigationController
         withThreadModel:(BDThreadModel *)threadModel
              withCustom:(NSDictionary *)custom;

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 @param contactModel <#contactModel description#>
 */
+ (void)pushChat:(UINavigationController *)navigationController
     withContactModel:(BDContactModel *)contactModel;

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 @param contactModel <#contactModel description#>
 @param custom <#custom description#>
 */
+ (void)pushChat:(UINavigationController *)navigationController
     withContactModel:(BDContactModel *)contactModel
           withCustom:(NSDictionary *)custom;

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 @param contactModel <#contactModel description#>
 */
+ (void)presentChat:(UINavigationController *)navigationController
        withContactModel:(BDContactModel *)contactModel;

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 @param contactModel <#contactModel description#>
 @param custom <#custom description#>
 */
+ (void)presentChat:(UINavigationController *)navigationController
        withContactModel:(BDContactModel *)contactModel
              withCustom:(NSDictionary *)custom;

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 @param groupModel <#groupModel description#>
 */
+ (void)pushChat:(UINavigationController *)navigationController
       withGroupModel:(BDGroupModel *)groupModel;

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 @param groupModel <#groupModel description#>
 @param custom <#custom description#>
 */
+ (void)pushChat:(UINavigationController *)navigationController
       withGroupModel:(BDGroupModel *)groupModel
           withCustom:(NSDictionary *)custom;

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 @param groupModel <#groupModel description#>
 */
+ (void)presentChat:(UINavigationController *)navigationController
          withGroupModel:(BDGroupModel *)groupModel;

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 @param groupModel <#groupModel description#>
 @param custom <#custom description#>
 */
+ (void)presentChat:(UINavigationController *)navigationController
          withGroupModel:(BDGroupModel *)groupModel
              withCustom:(NSDictionary *)custom;


#pragma mark - 客服端接口

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 @param threadModel <#threadModel description#>
 */
+ (void)agentPushChat:(UINavigationController *)navigationController
       withThreadModel:(BDThreadModel *)threadModel DEPRECATED_ATTRIBUTE;

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 @param threadModel <#threadModel description#>
 @param custom <#custom description#>
 */
+ (void)agentPushChat:(UINavigationController *)navigationController
      withThreadModel:(BDThreadModel *)threadModel
           withCustom:(NSDictionary *)custom DEPRECATED_ATTRIBUTE;

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 @param threadModel <#threadModel description#>
 */
+ (void)agentPresentChat:(UINavigationController *)navigationController
      withThreadModel:(BDThreadModel *)threadModel DEPRECATED_ATTRIBUTE;

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 @param threadModel <#threadModel description#>
 @param custom <#custom description#>
 */
+ (void)agentPresentChat:(UINavigationController *)navigationController
         withThreadModel:(BDThreadModel *)threadModel
              withCustom:(NSDictionary *)custom DEPRECATED_ATTRIBUTE;

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 @param contactModel <#contactModel description#>
 */
+ (void)agentPushChat:(UINavigationController *)navigationController
      withContactModel:(BDContactModel *)contactModel DEPRECATED_ATTRIBUTE;

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 @param contactModel <#contactModel description#>
 @param custom <#custom description#>
 */
+ (void)agentPushChat:(UINavigationController *)navigationController
     withContactModel:(BDContactModel *)contactModel
           withCustom:(NSDictionary *)custom DEPRECATED_ATTRIBUTE;

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 @param contactModel <#contactModel description#>
 */
+ (void)agentPresentChat:(UINavigationController *)navigationController
      withContactModel:(BDContactModel *)contactModel DEPRECATED_ATTRIBUTE;

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 @param contactModel <#contactModel description#>
 @param custom <#custom description#>
 */
+ (void)agentPresentChat:(UINavigationController *)navigationController
        withContactModel:(BDContactModel *)contactModel
              withCustom:(NSDictionary *)custom DEPRECATED_ATTRIBUTE;

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 @param groupModel <#groupModel description#>
 */
+ (void)agentPushChat:(UINavigationController *)navigationController
      withGroupModel:(BDGroupModel *)groupModel DEPRECATED_ATTRIBUTE;

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 @param groupModel <#groupModel description#>
 @param custom <#custom description#>
 */
+ (void)agentPushChat:(UINavigationController *)navigationController
       withGroupModel:(BDGroupModel *)groupModel
           withCustom:(NSDictionary *)custom DEPRECATED_ATTRIBUTE;

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 @param groupModel <#groupModel description#>
 */
+ (void)agentPresentChat:(UINavigationController *)navigationController
      withGroupModel:(BDGroupModel *)groupModel DEPRECATED_ATTRIBUTE;

/**
 <#Description#>

 @param navigationController <#navigationController description#>
 @param groupModel <#groupModel description#>
 @param custom <#custom description#>
 */
+ (void)agentPresentChat:(UINavigationController *)navigationController
          withGroupModel:(BDGroupModel *)groupModel
              withCustom:(NSDictionary *)custom DEPRECATED_ATTRIBUTE;

#pragma mark - 公共接口


@end






