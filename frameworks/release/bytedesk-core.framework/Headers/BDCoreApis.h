//
//  BDCoreApis.h
//  bdcore
//
//  Created by 萝卜丝 on 2018/7/15.
//  Copyright © 2018年 Bytedesk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessCallbackBlock)(NSDictionary *dict);
typedef void (^FailedCallbackBlock)(NSError *error);

@class BDProfileModel;

@interface BDCoreApis : NSObject

+ (BDCoreApis *)sharedInstance;

#pragma mark - 访客端接口

/**
 访客登录

 @param appkey appkey
 @param subdomain 二级域名
 @param success 成功回调
 @param failed 失败回调
 */
+ (void) visitorLoginWithAppkey:(NSString *)appkey
                  withSubdomain:(NSString *)subdomain
                  resultSuccess:(SuccessCallbackBlock)success
                   resultFailed:(FailedCallbackBlock)failed;

+ (void) visitorOAuthWithAppkey:(NSString *)appkey
                  withSubdomain:(NSString *)subdomain
                  resultSuccess:(SuccessCallbackBlock)success
                   resultFailed:(FailedCallbackBlock)failed;

/**
 访客请求会话

 @param wId 工作组id
 @param success 成功回调
 @param failed 失败回调
 */
+ (void)visitorRequestThreadWithUid:(NSString *)uId
                                wId:(NSString *)wId
                      resultSuccess:(SuccessCallbackBlock)success
                       resultFailed:(FailedCallbackBlock)failed;

/**
 @param agentName <#agentName description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
//+ (void)visitorRequestThreadWithAgent:(NSString *)agentName
//                        resultSuccess:(SuccessCallbackBlock)success
//                         resultFailed:(FailedCallbackBlock)failed;

/**
 设置昵称

 @param nickname 昵称
 @param success 成功回调
 @param failed 失败回调
 */
+ (void)visitorSetNickname:(NSString *)nickname
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;

/**
 获取用户信息

 @param success 成功回调
 @param failed 失败回调
 */
+ (void)visitorGetUserinfoWithUid:(NSString *)uid
                    resultSuccess:(SuccessCallbackBlock)success
                     resultFailed:(FailedCallbackBlock)failed;

/**
 自定义设置用户属性
 */
+ (void)visitorSetUserinfo:(NSString *)name
                   withKey:(NSString *)key
                 withValue:(NSString *)value
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;

/**
 获取工作组在线状态
 */
+ (void)visitorGetWorkGroupStatus:(NSString *)wId
                    resultSuccess:(SuccessCallbackBlock)success
                     resultFailed:(FailedCallbackBlock)failed;

/**
 获取某个客服账号的在线状态

 @param success 成功回调
 @param failed 失败回调
 */
+ (void)visitorGetAgentStatus:(NSString *)agentUid
                resultSuccess:(SuccessCallbackBlock)success
                 resultFailed:(FailedCallbackBlock)failed;

/**
 获取用户的所有会话历史

 @param success 成功回调
 @param failed 失败回调
 */
+ (void)visitorGetThreadsPage:(NSInteger)page
                resultSuccess:(SuccessCallbackBlock)success
                 resultFailed:(FailedCallbackBlock)failed;


+ (void)visitorRate:(NSString *)tId
          withScore:(NSInteger)score
           withNote:(NSString *)note
         withInvite:(BOOL)invite
      resultSuccess:(SuccessCallbackBlock)success
       resultFailed:(FailedCallbackBlock)failed;

#pragma mark - 客服端接口

/**
 客服首次登录，需要提供相关信息

 @param username <#username description#>
 @param password <#password description#>
 @param appkey <#appkey description#>
 @param subdomain <#subdomain description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void) adminLoginWithUsername:(NSString *)username
                   withPassword:(NSString *)password
                     withAppkey:(NSString *)appkey
                  withSubdomain:(NSString *)subdomain
                  resultSuccess:(SuccessCallbackBlock)success
                   resultFailed:(FailedCallbackBlock)failed;

/**
 非首次客服登录，利用首次登录保存在本地的token请求数据

 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void) adminLoginResultSuccess:(SuccessCallbackBlock)success
                    resultFailed:(FailedCallbackBlock)failed;

/**
 数据初始化：
 {
     message: "success"
     status_code: 200,
     data: {
         agent: '', // 个人资料
         queues: '', // 排队列表
         rosters: '', // 好友信息
         threads: '' // 当前会话列表
     }
 }
 @param success 成功回调
 @param failed 失败回调
 */
+ (void)adminInitResultSuccess:(SuccessCallbackBlock)success
                  resultFailed:(FailedCallbackBlock)failed;

/**
 <#Description#>

 @param threadId <#threadId description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)adminCloseThread:(NSNumber *)threadId
           resultSuccess:(SuccessCallbackBlock)success
            resultFailed:(FailedCallbackBlock)failed;

/**
 手动接入会话
 
 @param success success description
 @param failed <#failed description#>
 */
+ (void)adminManualAcceptQueueWithQueueId:(NSNumber *)queueId
                            resultSuccess:(SuccessCallbackBlock)success
                             resultFailed:(FailedCallbackBlock)failed;

/**
 自动接入会话
 
 @param queueId <#queueId description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)adminAutoAcceptQueueWithQueueId:(NSNumber *)queueId
                          resultSuccess:(SuccessCallbackBlock)success
                           resultFailed:(FailedCallbackBlock)failed;

/**
 <#Description#>

 @param companyId <#companyId description#>
 @param username <#username description#>
 @param client <#client description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)adminGetUserinfoWithCompanyId:(NSNumber *)companyId
                         withUsername:(NSString *)username
                           withClient:(NSString *)client
                        resultSuccess:(SuccessCallbackBlock)success
                         resultFailed:(FailedCallbackBlock)failed;

/**
 <#Description#>

 @param companyId <#companyId description#>
 @param username <#username description#>
 @param client <#client description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)adminGetTagWithCompanyId:(NSNumber *)companyId
                    withUsername:(NSString *)username
                      withClient:(NSString *)client
                   resultSuccess:(SuccessCallbackBlock)success
                    resultFailed:(FailedCallbackBlock)failed;

#pragma mark - 公共接口

/**
 <#Description#>

 @return <#return value description#>
 */
+ (BOOL)isVisitor;

/**
 <#Description#>

 @return <#return value description#>
 */
+ (BDProfileModel *)getProfile;

/**
 <#Description#>

 @return <#return value description#>
 */
+ (NSMutableArray *)getThreads;

/**
 <#Description#>

 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)getThreadResultSuccess:(SuccessCallbackBlock)success
                  resultFailed:(FailedCallbackBlock)failed;

/**
 <#Description#>

 @return <#return value description#>
 */
+ (NSMutableArray *)getQueues;

/**
 <#Description#>

 @return <#return value description#>
 */
+ (NSNumber *)getQueueCount;

/**
 <#Description#>

 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)getQueueResultSuccess:(SuccessCallbackBlock)success
                 resultFailed:(FailedCallbackBlock)failed;

/**
 <#Description#>

 @return <#return value description#>
 */
+ (NSMutableArray *)getContacts;

/**
 <#Description#>

 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)getContactResultSuccess:(SuccessCallbackBlock)success
                  resultFailed:(FailedCallbackBlock)failed;

/**
 <#Description#>

 @param threadId <#threadId description#>
 @return <#return value description#>
 */
+ (NSMutableArray *)getMessagesWithThread:(NSNumber *)threadId;

/**
 <#Description#>

 @return <#return value description#>
 */
+ (NSMutableArray *)getMessagesWithWorkgroup:(NSString *)wId;

/**
 <#Description#>

 @param threadId <#threadId description#>
 @param offset <#offset description#>
 @param length <#length description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)getMessageWithThread:(NSNumber *)threadId
                  withOffset:(NSInteger)offset
              withStepLength:(NSInteger)length
                resultSuccess:(SuccessCallbackBlock)success
                 resultFailed:(FailedCallbackBlock)failed;


+ (void)getMessageWithUser:(NSString *)uid
                  withPage:(NSInteger)page
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;

/**
 <#Description#>

 @param imageData <#imageData description#>
 @param imageName <#imageName description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)uploadImageData:(NSData *)imageData
          withImageName:(NSString *)imageName
          resultSuccess:(SuccessCallbackBlock)success
           resultFailed:(FailedCallbackBlock)failed;

/**
 <#Description#>

 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)logoutResultSuccess:(SuccessCallbackBlock)success
               resultFailed:(FailedCallbackBlock)failed;;


#pragma mark - Application

- (void)applicationWillResignActive;
- (void)applicationDidEnterBackground;
- (void)applicationWillEnterForeground;
- (void)applicationDidBecomeActive;
- (void)applicationWillTerminate;


@end






