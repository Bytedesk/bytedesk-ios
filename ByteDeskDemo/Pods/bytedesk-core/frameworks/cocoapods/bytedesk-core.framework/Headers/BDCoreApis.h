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

+ (void)registerUser:(NSString *)username
           withNickname:(NSString *)nickname
           withPassword:(NSString *)password
          withSubDomain:(NSString *)subDomain
          resultSuccess:(SuccessCallbackBlock)success
           resultFailed:(FailedCallbackBlock)failed;

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
 工作组会话

 @param wId 工作组id
 @param success 成功回调
 @param failed 失败回调
 */
+ (void)visitorRequestThreadWithWorkGroupWid:(NSString *)wId
                      resultSuccess:(SuccessCallbackBlock)success
                       resultFailed:(FailedCallbackBlock)failed;


/**
 指定坐席会话

 @param uid <#uid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)visitorRequestThreadWithAgentUid:(NSString *)uid
                        resultSuccess:(SuccessCallbackBlock)success
                         resultFailed:(FailedCallbackBlock)failed;

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

 @param username 用户名
 @param password 密码
 @param appkey appkey
 @param subDomain 企业号
 @param success 成功回调
 @param failed 失败回调
 */
+ (void) agentLoginWithUsername:(NSString *)username
                   withPassword:(NSString *)password
                     withAppkey:(NSString *)appkey
                  withSubdomain:(NSString *)subDomain
                  resultSuccess:(SuccessCallbackBlock)success
                   resultFailed:(FailedCallbackBlock)failed;

/**
 非首次客服登录，利用首次登录保存在本地的token请求数据

 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void) agentLoginResultSuccess:(SuccessCallbackBlock)success
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
+ (void)agentInitResultSuccess:(SuccessCallbackBlock)success
                  resultFailed:(FailedCallbackBlock)failed;

+ (void)agentUpdateProfile:(NSString *)nickname
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;

+ (void)agentUpdateAutoReply:(BOOL)isAutoReply
                 withContent:(NSString *)content
               resultSuccess:(SuccessCallbackBlock)success
                resultFailed:(FailedCallbackBlock)failed;

+ (void)agentSetAcceptStatus:(NSString *)acceptStatus
               resultSuccess:(SuccessCallbackBlock)success
                resultFailed:(FailedCallbackBlock)failed;

/**
 <#Description#>
 */
+ (void)agentCloseThread:(NSString *)tid
           resultSuccess:(SuccessCallbackBlock)success
            resultFailed:(FailedCallbackBlock)failed;


#pragma mark - 群组接口

/**
 获取群组
 
 @param success <#success description#>
 @param failed <#failed description#>
 */
- (void)agentGroupsResultSuccess:(SuccessCallbackBlock)success
                    resultFailed:(FailedCallbackBlock)failed;

- (void)agentGroupDetail:(NSString *)gid
           resultSuccess:(SuccessCallbackBlock)success
            resultFailed:(FailedCallbackBlock)failed;

- (void)agentGroupMembers:(NSString *)gid
            resultSuccess:(SuccessCallbackBlock)success
             resultFailed:(FailedCallbackBlock)failed;

- (void)agentGroupCreate:(NSString *)nickname
        selectedContacts:(NSArray *)selectedContacts
           resultSuccess:(SuccessCallbackBlock)success
            resultFailed:(FailedCallbackBlock)failed;

- (void)agentGroupUpdateNickname:(NSString *)nickname
                    withGroupGid:(NSString *)gid
                   resultSuccess:(SuccessCallbackBlock)success
                    resultFailed:(FailedCallbackBlock)failed;

- (void)agentGroupUpdateAnnouncement:(NSString *)announcement
                        withGroupGid:(NSString *)gid
                       resultSuccess:(SuccessCallbackBlock)success
                        resultFailed:(FailedCallbackBlock)failed;

- (void)agentGroupUpdateDescription:(NSString *)description
                       withGroupGid:(NSString *)gid
                      resultSuccess:(SuccessCallbackBlock)success
                       resultFailed:(FailedCallbackBlock)failed;

- (void)agentGroupInvite:(NSString *)uid
            withGroupGid:(NSString *)gid
           resultSuccess:(SuccessCallbackBlock)success
            resultFailed:(FailedCallbackBlock)failed;

- (void)agentGroupApply:(NSString *)gid
          resultSuccess:(SuccessCallbackBlock)success
           resultFailed:(FailedCallbackBlock)failed;

- (void)agentGroupApplyApprove:(NSString *)nid
                 resultSuccess:(SuccessCallbackBlock)success
                  resultFailed:(FailedCallbackBlock)failed;

- (void)agentGroupApplyDeny:(NSString *)nid
              resultSuccess:(SuccessCallbackBlock)success
               resultFailed:(FailedCallbackBlock)failed;

- (void)agentGroupKick:(NSString *)uid
          withGroupGid:(NSString *)gid
         resultSuccess:(SuccessCallbackBlock)success
          resultFailed:(FailedCallbackBlock)failed;

- (void)agentGroupMute:(NSString *)uid
          withGroupGid:(NSString *)gid
         resultSuccess:(SuccessCallbackBlock)success
          resultFailed:(FailedCallbackBlock)failed;

- (void)agentGroupTransfer:(NSString *)uid
              withGroupGid:(NSString *)gid
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;

- (void)agentGroupTransferAccept:(NSString *)nid
                   resultSuccess:(SuccessCallbackBlock)success
                    resultFailed:(FailedCallbackBlock)failed;

- (void)agentGroupTransferReject:(NSString *)nid
                   resultSuccess:(SuccessCallbackBlock)success
                    resultFailed:(FailedCallbackBlock)failed;

- (void)agentGroupWithdraw:(NSString *)gid
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;

- (void)agentGroupDismiss:(NSString *)gid
            resultSuccess:(SuccessCallbackBlock)success
             resultFailed:(FailedCallbackBlock)failed;




#pragma mark - 公共接口

/**
 <#Description#>

 @return <#return value description#>
 */
+ (BOOL)loginAsVisitor;

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

+ (NSMutableArray *)getGroups;

/**
 <#Description#>

 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)getContactsResultSuccess:(SuccessCallbackBlock)success
                  resultFailed:(FailedCallbackBlock)failed;

+ (void)getGroupsResultSuccess:(SuccessCallbackBlock)success
                   resultFailed:(FailedCallbackBlock)failed;

+ (void)updateCurrentThread:(NSString *)preTid
                  currentTid:(NSString *)tid
               resultSuccess:(SuccessCallbackBlock)success
                resultFailed:(FailedCallbackBlock)failed;

/**
 访客端调用，查询当前访客自己的所有聊天记录

 @return <#return value description#>
 */
+ (NSMutableArray *)getMessagesWithUser;

+ (NSMutableArray *)getMessagesWithThread:(NSString *)tid;

+ (NSMutableArray *)getMessagesWithWorkGroup:(NSString *)wid;

/**
 客服端调用

 @param uid <#uid description#>
 @return <#return value description#>
 */
+ (NSMutableArray *)getMessagesWithUser:(NSString *)uid;

+ (NSMutableArray *)getMessagesWithContact:(NSString *)cid;

+ (NSMutableArray *)getMessagesWithGroup:(NSString *)gid;

+ (void)getMessageWithUser:(NSString *)uid
                  withPage:(NSInteger)page
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;

+ (void)getMessageWithContact:(NSString *)cid
                  withPage:(NSInteger)page
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;

+ (void)getMessageWithGroup:(NSString *)gid
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
               resultFailed:(FailedCallbackBlock)failed;


/**
 建立长连接
 */
+ (void)connect;

/**
 断开连接
 */
+ (void)disconnect;


+ (BOOL)isConnected;


#pragma mark - Application

- (void)applicationWillResignActive;
- (void)applicationDidEnterBackground;
- (void)applicationWillEnterForeground;
- (void)applicationDidBecomeActive;
- (void)applicationWillTerminate;


@end






