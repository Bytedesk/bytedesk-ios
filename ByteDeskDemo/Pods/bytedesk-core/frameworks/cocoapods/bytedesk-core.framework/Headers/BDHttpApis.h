//
//  KFDSHttpApis.h
//  bdcore
//
//  Created by 萝卜丝 on 2018/11/18.
//  Copyright © 2018年 Bytedesk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessCallbackBlock)(NSDictionary *dict);
typedef void (^FailedCallbackBlock)(NSError *error);

@interface BDHttpApis : NSObject

+ (BDHttpApis *)sharedInstance;

#pragma mark - Bytedesk.com接口


#pragma mark - 访客端接口

/**
 从服务器请求用户名
 */
- (void)visitorGenerateUsernameWithAppkey:(NSString *)appkey
                            withSubdomain:(NSString *)subdomain
                            resultSuccess:(SuccessCallbackBlock)success
                             resultFailed:(FailedCallbackBlock)failed;

/**
 工作组会话
 */
- (void)visitorRequestThreadWithWorkGroupWid:(NSString *)wId
                      resultSuccess:(SuccessCallbackBlock)success
                       resultFailed:(FailedCallbackBlock)failed;


/**
 指定坐席

 @param uid <#uid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
- (void)visitorRequestThreadWithAgentUid:(NSString *)uid
                              resultSuccess:(SuccessCallbackBlock)success
                               resultFailed:(FailedCallbackBlock)failed;


- (void)visitorSetNickname:(NSString *)nickname
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;


- (void)visitorGetUserinfoWithUid:(NSString *)uid
                    resultSuccess:(SuccessCallbackBlock)success
                     resultFailed:(FailedCallbackBlock)failed;


- (void)visitorSetUserinfo:(NSString *)name
                   withKey:(NSString *)key
                 withValue:(NSString *)value
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;


- (void)visitorGetWorkGroupStatus:(NSString *)wId
                    resultSuccess:(SuccessCallbackBlock)success
                     resultFailed:(FailedCallbackBlock)failed;


- (void)visitorGetAgentStatus:(NSString *)agentUid
                resultSuccess:(SuccessCallbackBlock)success
                 resultFailed:(FailedCallbackBlock)failed;


- (void)visitorGetThreadsPage:(NSInteger)page
                resultSuccess:(SuccessCallbackBlock)success
                resultFailed:(FailedCallbackBlock)failed;


- (void)visitorRate:(NSString *)tId
          withScore:(NSInteger)score
           withNote:(NSString *)note
         withInvite:(BOOL)invite
      resultSuccess:(SuccessCallbackBlock)success
       resultFailed:(FailedCallbackBlock)failed;


#pragma mark - 客服端接口

/**
 初始化从服务器获取：
 1. 客服个人信息
 2. 队列信息
 3. 会话信息

 @param success <#success description#>
 @param failed <#failed description#>
 */
- (void)agentInitResultSuccess:(SuccessCallbackBlock)success
                  resultFailed:(FailedCallbackBlock)failed;

/**
 <#Description#>

 @param success <#success description#>
 @param failed <#failed description#>
 */
- (void)agentThreadsResultSuccess:(SuccessCallbackBlock)success
                       resultFailed:(FailedCallbackBlock)failed;

- (void)agentUpdateProfile:(NSString *)nickname
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;

- (void)agentUpdateAutoReply:(BOOL)isAutoReply
                 withContent:(NSString *)content
               resultSuccess:(SuccessCallbackBlock)success
                resultFailed:(FailedCallbackBlock)failed;

- (void)agentSetAcceptStatus:(NSString *)acceptStatus
               resultSuccess:(SuccessCallbackBlock)success
                resultFailed:(FailedCallbackBlock)failed;

/**
 Description
 */
- (void)agentCloseThread:(NSString *)tid
           resultSuccess:(SuccessCallbackBlock)success
            resultFailed:(FailedCallbackBlock)failed;

/**
 获取好友列表
 
 @param success success description
 @param failed <#failed description#>
 */
- (void)agentContactsResultSuccess:(SuccessCallbackBlock)success
                      resultFailed:(FailedCallbackBlock)failed;

/**
 获取当前进行中会话
 
 @param success <#success description#>
 @param failed <#failed description#>
 */
- (void)agentQueuesPage:(NSUInteger)page
          resultSuccess:(SuccessCallbackBlock)success
           resultFailed:(FailedCallbackBlock)failed;


- (void)agentUpdateCurrentThread:(NSString *)preTid
                      currentTid:(NSString *)tid
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
 检测网络是否可用
 */
- (BOOL)isNetworkReachable;


/**
 通过passport授权
 */
- (void)authWithRole:(NSString *)role
        withUsername:(NSString *)username
        withPassword:(NSString *)password
          withAppkey:(NSString *)appkey
       withSubdomain:(NSString *)subdomain
       resultSuccess:(SuccessCallbackBlock)success
        resultFailed:(FailedCallbackBlock)failed;

/**
 获取某个访客的聊天记录
 */
- (void)getMessageWithUser:(NSString *)uid
                  withPage:(NSInteger)page
               resultSuccess:(SuccessCallbackBlock)success
                resultFailed:(FailedCallbackBlock)failed;

- (void)getMessageWithContact:(NSString *)cid
                  withPage:(NSInteger)page
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;

- (void)getMessageWithGroup:(NSString *)gid
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
- (void)uploadImageData:(NSData *)imageData
          withImageName:(NSString *)imageName
          resultSuccess:(SuccessCallbackBlock)success
           resultFailed:(FailedCallbackBlock)failed;


/**
 <#Description#>

 @param voicePath <#voicePath description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
- (void)uploadVoice:(NSString *)voicePath
      resultSuccess:(SuccessCallbackBlock)success
       resultFailed:(FailedCallbackBlock)failed;


/**
 <#Description#>
 */
- (void)uploadDeviceInfo;


/**
 <#Description#>

 @param success <#success description#>
 @param failed <#failed description#>
 */
- (void)logoutResultSuccess:(SuccessCallbackBlock)success
               resultFailed:(FailedCallbackBlock)failed;


@end







