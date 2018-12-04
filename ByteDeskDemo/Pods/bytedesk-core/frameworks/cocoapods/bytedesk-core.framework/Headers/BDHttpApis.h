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
- (void)visitorRequestThreadWithUid:(NSString *)uId
                                wId:(NSString *)wId
                      resultSuccess:(SuccessCallbackBlock)success
                       resultFailed:(FailedCallbackBlock)failed;


/**
 一对一会话
 */
- (void)visitorRequestThreadWithAgent:(NSString *)agentName
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


#pragma mark - 群组接口





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

//
- (void)getProfileResultSuccess:(SuccessCallbackBlock)success
                   resultFailed:(FailedCallbackBlock)failed;
/**
 获取某个工作组的聊天记录
 */
- (void)getMessageWithUser:(NSString *)uid
                  withPage:(NSInteger)page
               resultSuccess:(SuccessCallbackBlock)success
                resultFailed:(FailedCallbackBlock)failed;


- (void)uploadImageData:(NSData *)imageData
          withImageName:(NSString *)imageName
          resultSuccess:(SuccessCallbackBlock)success
           resultFailed:(FailedCallbackBlock)failed;


- (void)uploadVoice:(NSString *)voicePath
      resultSuccess:(SuccessCallbackBlock)success
       resultFailed:(FailedCallbackBlock)failed;


- (void)uploadDeviceInfo;


- (void)logoutResultSuccess:(SuccessCallbackBlock)success
               resultFailed:(FailedCallbackBlock)failed;


@end







