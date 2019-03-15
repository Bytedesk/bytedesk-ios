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

+ (void)registerUser:(NSString *)username
        withNickname:(NSString *)nickname
             withUid:(NSString *)uid
        withPassword:(NSString *)password
       withSubDomain:(NSString *)subDomain
       resultSuccess:(SuccessCallbackBlock)success
        resultFailed:(FailedCallbackBlock)failed;

/**
 访客登录: 包含自动注册默认用户

 @param appkey appkey
 @param subdomain 二级域名
 @param success 成功回调
 @param failed 失败回调
 */
+ (void) visitorLoginWithAppkey:(NSString *)appkey
                  withSubdomain:(NSString *)subdomain
                  resultSuccess:(SuccessCallbackBlock)success
                   resultFailed:(FailedCallbackBlock)failed;


/**
 利用本地缓存信息登录

 @param appkey appkey
 @param subdomain 企业号
 @param success 成功回调
 @param failed 失败回调
 */
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
+ (void)requestThreadWithWorkGroupWid:(NSString *)wId
                      resultSuccess:(SuccessCallbackBlock)success
                       resultFailed:(FailedCallbackBlock)failed;


/**
 指定坐席会话

 @param uid <#uid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)requestThreadWithAgentUid:(NSString *)uid
                        resultSuccess:(SuccessCallbackBlock)success
                         resultFailed:(FailedCallbackBlock)failed;


/**
 选择问卷答案

 @param tid <#tid description#>
 @param qid <#qid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)requestQuestionnairWithTid:(NSString *)tid
                           itemQid:(NSString *)qid
                     resultSuccess:(SuccessCallbackBlock)success
                      resultFailed:(FailedCallbackBlock)failed;


/**
 选择工作组

 @param wid <#wid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)requestChooseWorkGroup:(NSString *)wid
                 resultSuccess:(SuccessCallbackBlock)success
                  resultFailed:(FailedCallbackBlock)failed;

/**
 设置昵称

 @param nickname 昵称
 @param success 成功回调
 @param failed 失败回调
 */
+ (void)setNickname:(NSString *)nickname
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;

/**
 获取用户信息

 @param success 成功回调
 @param failed 失败回调
 */
+ (void)getFingerPrintWithUid:(NSString *)uid
                    resultSuccess:(SuccessCallbackBlock)success
                     resultFailed:(FailedCallbackBlock)failed;

/**
 自定义设置用户属性
 */
+ (void)setFingerPrint:(NSString *)name
                   withKey:(NSString *)key
                 withValue:(NSString *)value
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;

/**
 获取工作组在线状态
 */
+ (void)getWorkGroupStatus:(NSString *)wId
                    resultSuccess:(SuccessCallbackBlock)success
                     resultFailed:(FailedCallbackBlock)failed;

/**
 获取某个客服账号的在线状态

 @param success 成功回调
 @param failed 失败回调
 */
+ (void)getAgentStatus:(NSString *)agentUid
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


/**
 满意度评价

 @param tId <#tId description#>
 @param score <#score description#>
 @param note <#note description#>
 @param invite <#invite description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
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
+ (void) loginWithUsername:(NSString *)username
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
+ (void) loginResultSuccess:(SuccessCallbackBlock)success
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
+ (void)initDataResultSuccess:(SuccessCallbackBlock)success
                  resultFailed:(FailedCallbackBlock)failed;

/**
 更新个人资料，目前仅开放nickname

 @param nickname <#nickname description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)updateProfile:(NSString *)nickname
        resultSuccess:(SuccessCallbackBlock)success
         resultFailed:(FailedCallbackBlock)failed;

/**
 更新自动回复内容，和是否启用自动回复
 客服专用

 @param isAutoReply <#isAutoReply description#>
 @param content <#content description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)updateAutoReply:(BOOL)isAutoReply
            withContent:(NSString *)content
          resultSuccess:(SuccessCallbackBlock)success
           resultFailed:(FailedCallbackBlock)failed;

/**
 设置接待状态

 @param acceptStatus <#acceptStatus description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)setAcceptStatus:(NSString *)acceptStatus
          resultSuccess:(SuccessCallbackBlock)success
           resultFailed:(FailedCallbackBlock)failed;

/**
 <#Description#>
 */
+ (void)agentCloseThread:(NSString *)tid
           resultSuccess:(SuccessCallbackBlock)success
            resultFailed:(FailedCallbackBlock)failed;

+ (void)visitorCloseThread:(NSString *)tid
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;

#pragma mark - 群组接口

/**
 获取群组
 
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)getGroupsResultSuccess:(SuccessCallbackBlock)success
                  resultFailed:(FailedCallbackBlock)failed;


/**
 查询群组详情

 @param gid <#gid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)getGroupDetail:(NSString *)gid
         resultSuccess:(SuccessCallbackBlock)success
          resultFailed:(FailedCallbackBlock)failed;

/**
 获取群组成员

 @param gid <#gid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)getGroupMembers:(NSString *)gid
          resultSuccess:(SuccessCallbackBlock)success
           resultFailed:(FailedCallbackBlock)failed;

/**
 创建群组

 @param nickname <#nickname description#>
 @param selectedContacts <#selectedContacts description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)createGroup:(NSString *)nickname
   selectedContacts:(NSArray *)selectedContacts
      resultSuccess:(SuccessCallbackBlock)success
       resultFailed:(FailedCallbackBlock)failed;

+ (void)createGroup:(NSString *)nickname
               type:(NSString *)type
   selectedContacts:(NSArray *)selectedContacts
      resultSuccess:(SuccessCallbackBlock)success
       resultFailed:(FailedCallbackBlock)failed;

/**
 更新群组昵称

 @param nickname <#nickname description#>
 @param gid <#gid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)updateGroupNickname:(NSString *)nickname
               withGroupGid:(NSString *)gid
              resultSuccess:(SuccessCallbackBlock)success
               resultFailed:(FailedCallbackBlock)failed;

/**
 更新群组公告

 @param announcement <#announcement description#>
 @param gid <#gid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)updateGroupAnnouncement:(NSString *)announcement
                   withGroupGid:(NSString *)gid
                  resultSuccess:(SuccessCallbackBlock)success
                   resultFailed:(FailedCallbackBlock)failed;

/**
 更新群组描述

 @param description <#description description#>
 @param gid <#gid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)updateGroupDescription:(NSString *)description
                  withGroupGid:(NSString *)gid
                 resultSuccess:(SuccessCallbackBlock)success
                  resultFailed:(FailedCallbackBlock)failed;

/**
 邀请某个用户到群组

 @param uid <#uid description#>
 @param gid <#gid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)inviteToGroup:(NSString *)uid
         withGroupGid:(NSString *)gid
        resultSuccess:(SuccessCallbackBlock)success
         resultFailed:(FailedCallbackBlock)failed;

+ (void)inviteListToGroup:(NSArray *)uidList
             withGroupGid:(NSString *)gid
            resultSuccess:(SuccessCallbackBlock)success
             resultFailed:(FailedCallbackBlock)failed;

/**
 主动申请加群，无需要群主审核

 @param gid <#gid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)joinGroup:(NSString *)gid
    resultSuccess:(SuccessCallbackBlock)success
     resultFailed:(FailedCallbackBlock)failed;

/**
 主动申请加群，需要群主审核

 @param gid <#gid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)applyGroup:(NSString *)gid
     resultSuccess:(SuccessCallbackBlock)success
      resultFailed:(FailedCallbackBlock)failed;

/**
 同意加群请求

 @param nid <#nid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)approveGroupApply:(NSString *)nid
            resultSuccess:(SuccessCallbackBlock)success
             resultFailed:(FailedCallbackBlock)failed;

/**
 拒绝加群请求

 @param nid <#nid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)denyGroupApply:(NSString *)nid
         resultSuccess:(SuccessCallbackBlock)success
          resultFailed:(FailedCallbackBlock)failed;

/**
 将某用户踢出群组

 @param uid <#uid description#>
 @param gid <#gid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)kickGroupMember:(NSString *)uid
          withGroupGid:(NSString *)gid
         resultSuccess:(SuccessCallbackBlock)success
          resultFailed:(FailedCallbackBlock)failed;

/**
 禁言群内某用户

 @param uid <#uid description#>
 @param gid <#gid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)muteGroupMember:(NSString *)uid
          withGroupGid:(NSString *)gid
         resultSuccess:(SuccessCallbackBlock)success
          resultFailed:(FailedCallbackBlock)failed;


/**
 将某人取消禁言

 @param uid <#uid description#>
 @param gid <#gid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
- (void)unmuteGroupMember:(NSString *)uid
             withGroupGid:(NSString *)gid
            resultSuccess:(SuccessCallbackBlock)success
             resultFailed:(FailedCallbackBlock)failed;


/**
 将某人设置为群组管理员

 @param uid <#uid description#>
 @param gid <#gid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
- (void)setGroupAdmin:(NSString *)uid
         withGroupGid:(NSString *)gid
        resultSuccess:(SuccessCallbackBlock)success
         resultFailed:(FailedCallbackBlock)failed;


/**
 取消某人群组管理员身份

 @param uid <#uid description#>
 @param gid <#gid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
- (void)unsetGroupAdmin:(NSString *)uid
           withGroupGid:(NSString *)gid
          resultSuccess:(SuccessCallbackBlock)success
           resultFailed:(FailedCallbackBlock)failed;

/**
 移交群组

 @param uid <#uid description#>
 @param gid <#gid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)transferGroup:(NSString *)uid
         withGroupGid:(NSString *)gid
        resultSuccess:(SuccessCallbackBlock)success
         resultFailed:(FailedCallbackBlock)failed;

/**
 同意移交群组

 @param nid <#nid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)acceptGroupTransfer:(NSString *)nid
              resultSuccess:(SuccessCallbackBlock)success
               resultFailed:(FailedCallbackBlock)failed;

/**
 拒绝移交群组

 @param nid <#nid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)rejectGroupTransfer:(NSString *)nid
              resultSuccess:(SuccessCallbackBlock)success
               resultFailed:(FailedCallbackBlock)failed;

/**
 退出群组

 @param gid <#gid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)withdrawGroup:(NSString *)gid
        resultSuccess:(SuccessCallbackBlock)success
         resultFailed:(FailedCallbackBlock)failed;

/**
 解散群组

 @param gid <#gid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)dismissGroup:(NSString *)gid
       resultSuccess:(SuccessCallbackBlock)success
        resultFailed:(FailedCallbackBlock)failed;

/**
 搜索群组

 @param keyword <#keyword description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)filterGroup:(NSString *)keyword
      resultSuccess:(SuccessCallbackBlock)success
       resultFailed:(FailedCallbackBlock)failed;

/**
 搜索群组成员

 @param gid <#gid description#>
 @param keyword <#keyword description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)filterGroupMembers:(NSString *)gid
               withKeyword:(NSString *)keyword
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;


/**
 分页获取通知列表

 @param page <#page description#>
 @param size <#size description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)getNoticesPage:(NSUInteger)page
              withSize:(NSUInteger)size
         resultSuccess:(SuccessCallbackBlock)success
          resultFailed:(FailedCallbackBlock)failed;


#pragma mark - 社交关系

/**
 获取陌生人列表（暂未上线）

 @param page <#page description#>
 @param size <#size description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)getStrangersPage:(NSUInteger)page
                withSize:(NSUInteger)size
           resultSuccess:(SuccessCallbackBlock)success
            resultFailed:(FailedCallbackBlock)failed;

/**
 获取关注列表
 分页

 @param page <#page description#>
 @param size <#size description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)getFollowsPage:(NSUInteger)page
              withSize:(NSUInteger)size
         resultSuccess:(SuccessCallbackBlock)success
          resultFailed:(FailedCallbackBlock)failed;

/**
 获取粉丝列表
 分页

 @param page <#page description#>
 @param size <#size description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)getFansPage:(NSUInteger)page
           withSize:(NSUInteger)size
      resultSuccess:(SuccessCallbackBlock)success
       resultFailed:(FailedCallbackBlock)failed;

/**
 获取好友列表
 分页

 @param page <#page description#>
 @param size <#size description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)getFriendsPage:(NSUInteger)page
              withSize:(NSUInteger)size
         resultSuccess:(SuccessCallbackBlock)success
          resultFailed:(FailedCallbackBlock)failed;

/**
 获取黑名单
 分页

 @param page <#page description#>
 @param size <#size description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)getBlocksPage:(NSUInteger)page
             withSize:(NSUInteger)size
        resultSuccess:(SuccessCallbackBlock)success
         resultFailed:(FailedCallbackBlock)failed;

/**
 添加关注

 @param uid <#uid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)addFollow:(NSString *)uid
    resultSuccess:(SuccessCallbackBlock)success
     resultFailed:(FailedCallbackBlock)failed;

/**
 取消关注

 @param uid <#uid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)unFollow:(NSString *)uid
   resultSuccess:(SuccessCallbackBlock)success
    resultFailed:(FailedCallbackBlock)failed;


/**
 添加好友

 @param uid <#uid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)addFriend:(NSString *)uid
    resultSuccess:(SuccessCallbackBlock)success
     resultFailed:(FailedCallbackBlock)failed;


/**
 删除好友

 @param uid <#uid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)removeFriend:(NSString *)uid
       resultSuccess:(SuccessCallbackBlock)success
        resultFailed:(FailedCallbackBlock)failed;

/**
 判断是否已经关注

 @param uid <#uid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)isFollowed:(NSString *)uid
     resultSuccess:(SuccessCallbackBlock)success
      resultFailed:(FailedCallbackBlock)failed;

/**
 获取关系（暂未上线）

 @param uid <#uid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)getRelation:(NSString *)uid
      resultSuccess:(SuccessCallbackBlock)success
       resultFailed:(FailedCallbackBlock)failed;

/**
 拉黑用户

 @param uid <#uid description#>
 @param note <#note description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)addBlock:(NSString *)uid
        withNote:(NSString *)note
   resultSuccess:(SuccessCallbackBlock)success
    resultFailed:(FailedCallbackBlock)failed;

/**
 取消拉黑

 @param uid <#uid description#>
 @param success <#success description#>
 @param failed <#failed description#>
 */
+ (void)unBlock:(NSString *)uid
  resultSuccess:(SuccessCallbackBlock)success
   resultFailed:(FailedCallbackBlock)failed;


#pragma mark - 公共接口

+ (void)registerAdmin:(NSString *)email
         withPassword:(NSString *)password
        resultSuccess:(SuccessCallbackBlock)success
         resultFailed:(FailedCallbackBlock)failed;

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

+ (void)updateCurrentThread:(NSString *)preTid
                  currentTid:(NSString *)tid
               resultSuccess:(SuccessCallbackBlock)success
                resultFailed:(FailedCallbackBlock)failed;

+ (void)markTopThread:(NSString *)tid
        resultSuccess:(SuccessCallbackBlock)success
         resultFailed:(FailedCallbackBlock)failed;

+ (void)unmarkTopThread:(NSString *)tid
          resultSuccess:(SuccessCallbackBlock)success
           resultFailed:(FailedCallbackBlock)failed;

+ (void)markNoDisturbThread:(NSString *)tid
            resultSuccess:(SuccessCallbackBlock)success
             resultFailed:(FailedCallbackBlock)failed;

+ (void)unmarkNoDisturbThread:(NSString *)tid
              resultSuccess:(SuccessCallbackBlock)success
               resultFailed:(FailedCallbackBlock)failed;

+ (void)markUnreadThread:(NSString *)tid
           resultSuccess:(SuccessCallbackBlock)success
            resultFailed:(FailedCallbackBlock)failed;

+ (void)unmarkUnreadThread:(NSString *)tid
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;

+ (void)markDeletedThread:(NSString *)tid
            resultSuccess:(SuccessCallbackBlock)success
             resultFailed:(FailedCallbackBlock)failed;

+ (void)markDeletedMessage:(NSString *)mid
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;

+ (void)markClearThreadMessage:(NSString *)tid
                 resultSuccess:(SuccessCallbackBlock)success
                  resultFailed:(FailedCallbackBlock)failed;

+ (void)markClearContactMessage:(NSString *)uid
                  resultSuccess:(SuccessCallbackBlock)success
                   resultFailed:(FailedCallbackBlock)failed;

+ (void)markClearGroupMessage:(NSString *)gid
                resultSuccess:(SuccessCallbackBlock)success
                 resultFailed:(FailedCallbackBlock)failed;

/**
 同步发送文本消息
 
 @param content content description
 @param tId <#tId description#>
 @param sessiontype <#stype description#>
 */
+ (void)sendTextMessage:(NSString *)content
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
+ (void)sendImageMessage:(NSString *)content
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
+ (void)sendVoiceMessage:(NSString *)content
                   toTid:(NSString *)tId
                 localId:(NSString *)localId
             sessionType:(NSString *)sessiontype
           resultSuccess:(SuccessCallbackBlock)success
            resultFailed:(FailedCallbackBlock)failed;


+ (void)sendCommodityMessage:(NSString *)content
                       toTid:(NSString *)tId
                     localId:(NSString *)localId
                 sessionType:(NSString *)sessiontype
               resultSuccess:(SuccessCallbackBlock)success
                resultFailed:(FailedCallbackBlock)failed;


+ (void)sendRedPacketMessage:(NSString *)content
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
+ (void)sendMessage:(NSString *)content
               type:(NSString *)type
              toTid:(NSString *)tId
            localId:(NSString *)localId
        sessionType:(NSString *)sessiontype
      resultSuccess:(SuccessCallbackBlock)success
       resultFailed:(FailedCallbackBlock)failed;


/**
 访客端调用，查询当前访客自己的所有聊天记录

 @return <#return value description#>
 */
+ (NSMutableArray *)getMessagesWithUser;

+ (NSMutableArray *)getMessagesWithUserPage:(NSUInteger)page;

+ (NSMutableArray *)getMessagesWithThread:(NSString *)tid;

+ (NSMutableArray *)getMessagesWithThread:(NSString *)tid withPage:(NSUInteger)page;

+ (NSMutableArray *)getMessagesWithWorkGroup:(NSString *)wid;

+ (NSMutableArray *)getMessagesWithWorkGroup:(NSString *)wid withPage:(NSUInteger)page;

/**
 客服端调用

 @param uid <#uid description#>
 @return <#return value description#>
 */
+ (NSMutableArray *)getMessagesWithUser:(NSString *)uid;

+ (NSMutableArray *)getMessagesWithUser:(NSString *)uid withPage:(NSUInteger)page;

+ (NSMutableArray *)getMessagesWithContact:(NSString *)cid;

+ (NSMutableArray *)getMessagesWithContact:(NSString *)cid withPage:(NSUInteger)page;

+ (NSMutableArray *)getMessagesWithGroup:(NSString *)gid;

+ (NSMutableArray *)getMessagesWithGroup:(NSString *)gid withPage:(NSUInteger)page;

+ (void)getMessageWithUser:(NSString *)uid
                  withPage:(NSInteger)page
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;

+ (void)getMessageWithUser:(NSString *)uid
                    withId:(NSInteger)messageid
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;

+ (void)getMessageWithContact:(NSString *)cid
                  withPage:(NSInteger)page
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;

+ (void)getMessageWithContact:(NSString *)cid
                       withId:(NSInteger)messageid
                resultSuccess:(SuccessCallbackBlock)success
                 resultFailed:(FailedCallbackBlock)failed;

+ (void)getMessageWithGroup:(NSString *)gid
                  withPage:(NSInteger)page
             resultSuccess:(SuccessCallbackBlock)success
              resultFailed:(FailedCallbackBlock)failed;

+ (void)getMessageWithGroup:(NSString *)gid
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
+ (void)uploadImageData:(NSData *)imageData
          withImageName:(NSString *)imageName
          resultSuccess:(SuccessCallbackBlock)success
           resultFailed:(FailedCallbackBlock)failed;

+ (void)uploadAvatarData:(NSData *)imageData
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

+ (void)applicationWillResignActive;
+ (void)applicationDidEnterBackground;
+ (void)applicationWillEnterForeground;
+ (void)applicationDidBecomeActive;
+ (void)applicationWillTerminate;


@end






