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
- (void)registerAnonymousUserWithAppkey:(NSString *)appkey
                            withSubdomain:(NSString *)subdomain
                            resultSuccess:(SuccessCallbackBlock)success
                             resultFailed:(FailedCallbackBlock)failed;

/**
注册自定义普通用户：用于IM

 @param username <#username description#>
 @param nickname <#nickname description#>
 @param password <#password description#>
 @param subDomain <#subDomain description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
- (void)registerUser:(NSString *)username
           withNickname:(NSString *)nickname
           withPassword:(NSString *)password
          withSubDomain:(NSString *)subDomain
          resultSuccess:(SuccessCallbackBlock)success
           resultFailed:(FailedCallbackBlock)failed;


/**
 注册自定义普通用户, 自定义uid

 @param username <#username description#>
 @param nickname <#nickname description#>
 @param uid <#uid description#>
 @param password <#password description#>
 @param subDomain <#subDomain description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
- (void)registerUser:(NSString *)username
        withNickname:(NSString *)nickname
             withUid:(NSString *)uid
        withPassword:(NSString *)password
       withSubDomain:(NSString *)subDomain
       resultSuccess:(SuccessCallbackBlock)success
        resultFailed:(FailedCallbackBlock)failed;

/**
 注册管理员账号，客服管理员

 @param email <#email description#>
 @param password <#password description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
- (void)registerAdmin:(NSString *)email
         withPassword:(NSString *)password
        resultSuccess:(SuccessCallbackBlock)success
         resultFailed:(FailedCallbackBlock)failed;

/**
 工作组会话
 */
- (void)requestThreadWithWorkGroupWid:(NSString *)wId
                      resultSuccess:(SuccessCallbackBlock)success
                       resultFailed:(FailedCallbackBlock)failed;
/**
 指定坐席

 @param uid <#uid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
- (void)requestThreadWithAgentUid:(NSString *)uid
                              resultSuccess:(SuccessCallbackBlock)success
                               resultFailed:(FailedCallbackBlock)failed;

- (void)requestQuestionnairWithTid:(NSString *)tid
                           itemQid:(NSString *)qid
                     resultSuccess:(SuccessCallbackBlock)success
                      resultFailed:(FailedCallbackBlock)failed;

- (void)requestChooseWorkGroup:(NSString *)wid
                 resultSuccess:(SuccessCallbackBlock)success
                  resultFailed:(FailedCallbackBlock)failed;

- (void)setNickname:(NSString *)nickname
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;


- (void)getFingerPrintWithUid:(NSString *)uid
                    resultSuccess:(SuccessCallbackBlock)success
                     resultFailed:(FailedCallbackBlock)failed;


- (void)setFingerPrint:(NSString *)name
                   withKey:(NSString *)key
                 withValue:(NSString *)value
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;


- (void)getWorkGroupStatus:(NSString *)wId
                    resultSuccess:(SuccessCallbackBlock)success
                     resultFailed:(FailedCallbackBlock)failed;


- (void)getAgentStatus:(NSString *)agentUid
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
- (void)initDataResultSuccess:(SuccessCallbackBlock)success
                  resultFailed:(FailedCallbackBlock)failed;

/**
 <#Description#>

 @param success <#success description#>
 @param failed <#failed description#>
 */
- (void)agentThreadsResultSuccess:(SuccessCallbackBlock)success
                       resultFailed:(FailedCallbackBlock)failed;

- (void)updateProfile:(NSString *)nickname
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;

- (void)updateAutoReply:(BOOL)isAutoReply
                 withContent:(NSString *)content
               resultSuccess:(SuccessCallbackBlock)success
                resultFailed:(FailedCallbackBlock)failed;

- (void)setAcceptStatus:(NSString *)acceptStatus
               resultSuccess:(SuccessCallbackBlock)success
                resultFailed:(FailedCallbackBlock)failed;

/**
 Description
 */
- (void)agentCloseThread:(NSString *)tid
           resultSuccess:(SuccessCallbackBlock)success
            resultFailed:(FailedCallbackBlock)failed;

- (void)visitorCloseThread:(NSString *)tid
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;

/**
 获取好友列表
 
 @param success success description
 @param failed <#failed description#>
 */
- (void)getContactsResultSuccess:(SuccessCallbackBlock)success
                      resultFailed:(FailedCallbackBlock)failed;

/**
 获取当前进行中会话
 
 @param success <#success description#>
 @param failed <#failed description#>
 */
- (void)getQueuesPage:(NSUInteger)page
          resultSuccess:(SuccessCallbackBlock)success
           resultFailed:(FailedCallbackBlock)failed;


- (void)updateCurrentThread:(NSString *)preTid
                      currentTid:(NSString *)tid
                   resultSuccess:(SuccessCallbackBlock)success
                    resultFailed:(FailedCallbackBlock)failed;

- (void)markTopThread:(NSString *)tid
        resultSuccess:(SuccessCallbackBlock)success
         resultFailed:(FailedCallbackBlock)failed;

- (void)unmarkTopThread:(NSString *)tid
          resultSuccess:(SuccessCallbackBlock)success
           resultFailed:(FailedCallbackBlock)failed;

- (void)markNoDisturbThread:(NSString *)tid
            resultSuccess:(SuccessCallbackBlock)success
             resultFailed:(FailedCallbackBlock)failed;

- (void)unmarkNoDisturbThread:(NSString *)tid
              resultSuccess:(SuccessCallbackBlock)success
               resultFailed:(FailedCallbackBlock)failed;

- (void)markUnreadThread:(NSString *)tid
           resultSuccess:(SuccessCallbackBlock)success
            resultFailed:(FailedCallbackBlock)failed;

- (void)unmarkUnreadThread:(NSString *)tid
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;

- (void)markDeletedThread:(NSString *)tid
            resultSuccess:(SuccessCallbackBlock)success
             resultFailed:(FailedCallbackBlock)failed;

- (void)markDeletedMessage:(NSString *)mid
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;

- (void)markClearThreadMessage:(NSString *)tid
           resultSuccess:(SuccessCallbackBlock)success
            resultFailed:(FailedCallbackBlock)failed;

- (void)markClearContactMessage:(NSString *)uid
                  resultSuccess:(SuccessCallbackBlock)success
                   resultFailed:(FailedCallbackBlock)failed;

- (void)markClearGroupMessage:(NSString *)gid
                resultSuccess:(SuccessCallbackBlock)success
                 resultFailed:(FailedCallbackBlock)failed;

#pragma mark - 群组接口

/**
 获取群组

 @param success <#success description#>
 @param failed <#failed description#>
 */
- (void)getGroupsResultSuccess:(SuccessCallbackBlock)success
                      resultFailed:(FailedCallbackBlock)failed;

- (void)getGroupDetail:(NSString *)gid
       resultSuccess:(SuccessCallbackBlock)success
        resultFailed:(FailedCallbackBlock)failed;

- (void)getGroupMembers:(NSString *)gid
        resultSuccess:(SuccessCallbackBlock)success
         resultFailed:(FailedCallbackBlock)failed;

- (void)createGroup:(NSString *)nickname
               type:(NSString *)type
        selectedContacts:(NSArray *)selectedContacts
           resultSuccess:(SuccessCallbackBlock)success
            resultFailed:(FailedCallbackBlock)failed;

- (void)updateGroupNickname:(NSString *)nickname
                    withGroupGid:(NSString *)gid
                   resultSuccess:(SuccessCallbackBlock)success
                    resultFailed:(FailedCallbackBlock)failed;

- (void)updateGroupAnnouncement:(NSString *)announcement
                        withGroupGid:(NSString *)gid
                       resultSuccess:(SuccessCallbackBlock)success
                        resultFailed:(FailedCallbackBlock)failed;

- (void)updateGroupDescription:(NSString *)description
                       withGroupGid:(NSString *)gid
                      resultSuccess:(SuccessCallbackBlock)success
                       resultFailed:(FailedCallbackBlock)failed;

- (void)inviteToGroup:(NSString *)uid
            withGroupGid:(NSString *)gid
           resultSuccess:(SuccessCallbackBlock)success
            resultFailed:(FailedCallbackBlock)failed;

- (void)inviteListToGroup:(NSArray *)uidList
         withGroupGid:(NSString *)gid
        resultSuccess:(SuccessCallbackBlock)success
         resultFailed:(FailedCallbackBlock)failed;

- (void)joinGroup:(NSString *)gid
          resultSuccess:(SuccessCallbackBlock)success
           resultFailed:(FailedCallbackBlock)failed;

- (void)applyGroup:(NSString *)gid
          resultSuccess:(SuccessCallbackBlock)success
           resultFailed:(FailedCallbackBlock)failed;

- (void)approveGroupApply:(NSString *)nid
                 resultSuccess:(SuccessCallbackBlock)success
                  resultFailed:(FailedCallbackBlock)failed;

- (void)denyGroupApply:(NSString *)nid
              resultSuccess:(SuccessCallbackBlock)success
               resultFailed:(FailedCallbackBlock)failed;

- (void)kickGroupMember:(NSString *)uid
          withGroupGid:(NSString *)gid
         resultSuccess:(SuccessCallbackBlock)success
          resultFailed:(FailedCallbackBlock)failed;

- (void)muteGroupMember:(NSString *)uid
          withGroupGid:(NSString *)gid
         resultSuccess:(SuccessCallbackBlock)success
          resultFailed:(FailedCallbackBlock)failed;

- (void)unmuteGroupMember:(NSString *)uid
             withGroupGid:(NSString *)gid
            resultSuccess:(SuccessCallbackBlock)success
             resultFailed:(FailedCallbackBlock)failed;

- (void)setGroupAdmin:(NSString *)uid
         withGroupGid:(NSString *)gid
        resultSuccess:(SuccessCallbackBlock)success
         resultFailed:(FailedCallbackBlock)failed;

- (void)unsetGroupAdmin:(NSString *)uid
           withGroupGid:(NSString *)gid
          resultSuccess:(SuccessCallbackBlock)success
           resultFailed:(FailedCallbackBlock)failed;

- (void)transferGroup:(NSString *)uid
              withGroupGid:(NSString *)gid
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;

- (void)acceptGroupTransfer:(NSString *)nid
                   resultSuccess:(SuccessCallbackBlock)success
                    resultFailed:(FailedCallbackBlock)failed;

- (void)rejectGroupTransfer:(NSString *)nid
                   resultSuccess:(SuccessCallbackBlock)success
                    resultFailed:(FailedCallbackBlock)failed;

- (void)withdrawGroup:(NSString *)gid
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;

- (void)dismissGroup:(NSString *)gid
            resultSuccess:(SuccessCallbackBlock)success
             resultFailed:(FailedCallbackBlock)failed;

- (void)filterGroup:(NSString *)keyword
      resultSuccess:(SuccessCallbackBlock)success
       resultFailed:(FailedCallbackBlock)failed;

- (void)filterGroupMembers:(NSString *)gid
        withKeyword:(NSString *)keyword
      resultSuccess:(SuccessCallbackBlock)success
       resultFailed:(FailedCallbackBlock)failed;

- (void)getNoticesPage:(NSUInteger)page
              withSize:(NSUInteger)size
         resultSuccess:(SuccessCallbackBlock)success
          resultFailed:(FailedCallbackBlock)failed;

#pragma mark - 社交关系

- (void)getStrangersPage:(NSUInteger)page
                withSize:(NSUInteger)size
           resultSuccess:(SuccessCallbackBlock)success
            resultFailed:(FailedCallbackBlock)failed;

- (void)getFollowsPage:(NSUInteger)page
              withSize:(NSUInteger)size
         resultSuccess:(SuccessCallbackBlock)success
          resultFailed:(FailedCallbackBlock)failed;

- (void)getFansPage:(NSUInteger)page
           withSize:(NSUInteger)size
      resultSuccess:(SuccessCallbackBlock)success
       resultFailed:(FailedCallbackBlock)failed;

- (void)getFriendsPage:(NSUInteger)page
              withSize:(NSUInteger)size
         resultSuccess:(SuccessCallbackBlock)success
          resultFailed:(FailedCallbackBlock)failed;

- (void)getBlocksPage:(NSUInteger)page
             withSize:(NSUInteger)size
        resultSuccess:(SuccessCallbackBlock)success
         resultFailed:(FailedCallbackBlock)failed;

- (void)addFollow:(NSString *)uid
    resultSuccess:(SuccessCallbackBlock)success
     resultFailed:(FailedCallbackBlock)failed;

- (void)unFollow:(NSString *)uid
   resultSuccess:(SuccessCallbackBlock)success
    resultFailed:(FailedCallbackBlock)failed;

- (void)addFriend:(NSString *)uid
    resultSuccess:(SuccessCallbackBlock)success
     resultFailed:(FailedCallbackBlock)failed;

- (void)removeFriend:(NSString *)uid
       resultSuccess:(SuccessCallbackBlock)success
        resultFailed:(FailedCallbackBlock)failed;

- (void)isFollowed:(NSString *)uid
     resultSuccess:(SuccessCallbackBlock)success
      resultFailed:(FailedCallbackBlock)failed;

- (void)getRelation:(NSString *)uid
      resultSuccess:(SuccessCallbackBlock)success
       resultFailed:(FailedCallbackBlock)failed;

- (void)addBlock:(NSString *)uid
        withType:(NSString *)type
        withNote:(NSString *)note
   resultSuccess:(SuccessCallbackBlock)success
    resultFailed:(FailedCallbackBlock)failed;

- (void)unBlock:(NSString *)bid
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
 同步发送文本消息
 
 @param content <#content description#>
 @param tId <#tId description#>
 @param sessiontype <#stype description#>
 */
- (void)sendTextMessage:(NSString *)content
                  toTid:(NSString *)tId
                localId:(NSString *)localId
            sessionType:(NSString *)sessiontype
          resultSuccess:(SuccessCallbackBlock)success
           resultFailed:(FailedCallbackBlock)failed;

/**
 同步发送图片消息
 
 @param content <#content description#>
 @param tId <#tId description#>
 @param sessiontype <#stype description#>
 */
- (void)sendImageMessage:(NSString *)content
                   toTid:(NSString *)tId
                 localId:(NSString *)localId
             sessionType:(NSString *)sessiontype
           resultSuccess:(SuccessCallbackBlock)success
            resultFailed:(FailedCallbackBlock)failed;

/**
 同步发送语音消息
 
 @param content <#content description#>
 @param tId <#tId description#>
 @param sessiontype <#stype description#>
 */
- (void)sendVoiceMessage:(NSString *)content
                   toTid:(NSString *)tId
                 localId:(NSString *)localId
             sessionType:(NSString *)sessiontype
           resultSuccess:(SuccessCallbackBlock)success
            resultFailed:(FailedCallbackBlock)failed;


- (void)sendCommodityMessage:(NSString *)content
                   toTid:(NSString *)tId
                 localId:(NSString *)localId
             sessionType:(NSString *)sessiontype
           resultSuccess:(SuccessCallbackBlock)success
            resultFailed:(FailedCallbackBlock)failed;


- (void)sendRedPacketMessage:(NSString *)content
                       toTid:(NSString *)tId
                     localId:(NSString *)localId
                 sessionType:(NSString *)sessiontype
               resultSuccess:(SuccessCallbackBlock)success
                resultFailed:(FailedCallbackBlock)failed;


/**
 同步发送预知消息

 @param content <#content description#>
 @param tId <#tId description#>
 @param localId <#localId description#>
 @param sessiontype <#sessiontype description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
- (void)sendPreviewMessage:(NSString *)content
                   toTid:(NSString *)tId
                 localId:(NSString *)localId
             sessionType:(NSString *)sessiontype
           resultSuccess:(SuccessCallbackBlock)success
            resultFailed:(FailedCallbackBlock)failed;

/**
 同步发送消息回执

 @param content <#content description#>
 @param tId <#tId description#>
 @param localId <#localId description#>
 @param sessiontype <#sessiontype description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
- (void)sendReceiptMessage:(NSString *)content
                   toTid:(NSString *)tId
                 localId:(NSString *)localId
             sessionType:(NSString *)sessiontype
           resultSuccess:(SuccessCallbackBlock)success
            resultFailed:(FailedCallbackBlock)failed;

/**
 同步发送消息
 
 @param content <#content description#>
 @param type <#type description#>
 @param tId <#tId description#>
 @param sessiontype <#stype description#>
 */
- (void)sendMessage:(NSString *)content
               type:(NSString *)type
              toTid:(NSString *)tId
            localId:(NSString *)localId
        sessionType:(NSString *)sessiontype
      resultSuccess:(SuccessCallbackBlock)success
       resultFailed:(FailedCallbackBlock)failed;

/**
 获取某个访客的聊天记录
 */
- (void)getMessageWithUser:(NSString *)uid
                  withPage:(NSInteger)page
               resultSuccess:(SuccessCallbackBlock)success
                resultFailed:(FailedCallbackBlock)failed;

- (void)getMessageWithUser:(NSString *)uid
                    withId:(NSInteger)messageid
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;

- (void)getMessageWithContact:(NSString *)cid
                  withPage:(NSInteger)page
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;

- (void)getMessageWithContact:(NSString *)cid
                       withId:(NSInteger)messageid
                resultSuccess:(SuccessCallbackBlock)success
                 resultFailed:(FailedCallbackBlock)failed;

- (void)getMessageWithGroup:(NSString *)gid
                  withPage:(NSInteger)page
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;

- (void)getMessageWithGroup:(NSString *)gid
                     withId:(NSInteger)messageid
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

- (void)uploadAvatarData:(NSData *)imageData
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


#pragma mark - 机器人

- (void)getInitAnswer:(NSString *)uid
        withThreadTid:(NSString *)tid
        resultSuccess:(SuccessCallbackBlock)success
         resultFailed:(FailedCallbackBlock)failed;

- (void)getTopAnswer:(NSString *)uid
       withThreadTid:(NSString *)tid
       resultSuccess:(SuccessCallbackBlock)success
        resultFailed:(FailedCallbackBlock)failed;

- (void)queryAnswer:(NSString *)uid
      withThreadTid:(NSString *)tid
     withQuestinQid:(NSString *)aid
      resultSuccess:(SuccessCallbackBlock)success
       resultFailed:(FailedCallbackBlock)failed;

- (void)messageAnswer:(NSString *)uid
        withThreadTid:(NSString *)tid
          withMessage:(NSString *)content
        resultSuccess:(SuccessCallbackBlock)success
         resultFailed:(FailedCallbackBlock)failed;


#pragma mark - 意见反馈

- (void)getFeedbackCategoriesWithResultSuccess:(SuccessCallbackBlock)success
                                  resultFailed:(FailedCallbackBlock)failed;

- (void)createFeedback:(NSString *)uid
         resultSuccess:(SuccessCallbackBlock)success
          resultFailed:(FailedCallbackBlock)failed;

- (void)getFeedbackHistoriesWithResultSuccess:(SuccessCallbackBlock)success
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


/**
 错误处理

 @param error error
 @param success 成功回调
 @param failed 失败回调
 */
- (void)failError:(NSError *)error
    resultSuccess:(SuccessCallbackBlock)success
     resultFailed:(FailedCallbackBlock)failed;

@end







