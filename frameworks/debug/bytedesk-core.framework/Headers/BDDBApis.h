//
//  KFDSDBApis.h
//  bdcore
//
//  Created by 萝卜丝 on 2018/11/18.
//  Copyright © 2018年 Bytedesk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BDThreadModel;
@class BDQueueModel;
@class BDMessageModel;
@class BDGroupModel;
@class BDWorkGroupModel;
@class BDContactModel;

typedef void (^SuccessCallbackBlock)(NSDictionary *dict);
typedef void (^FailedCallbackBlock)(NSError *error);

@interface BDDBApis : NSObject

+ (BDDBApis *)sharedInstance;

#pragma mark - 访客端接口


#pragma mark - 客服端接口

- (BOOL) insertThread:(BDThreadModel *)thread;
- (BOOL) deleteThread:(NSString *)tId;

/**
 为保证会话列表中同一个访客、联系人、群组，只保留一条记录

 @param uId <#uId description#>
 @return <#return value description#>
 */
- (BOOL) deleteThreadUser:(NSString *)uId;
- (NSMutableArray *) getThreads;
- (BOOL) clearThreads;
- (BOOL) clearThreadUnreadCount:(NSString *)tId;

- (BOOL) markTopThread:(NSString *)tId;
- (BOOL) unmarkTopThread:(NSString *)tId;

- (BOOL) markDisturbThread:(NSString *)tId;
- (BOOL) unmarkDisturbThread:(NSString *)tId;

- (BOOL) markUnreadThread:(NSString *)tId;
- (BOOL) unmarkUnreadThread:(NSString *)tId;

- (BOOL) markDeletedThread:(NSString *)tId;

- (BOOL) markDeletedMessage:(NSString *)mId;
// TODO: 根据tid标记所有消息已删除
- (BOOL) markClearMessage:(NSString *)tId;

- (BOOL) insertQueue:(BDQueueModel *)queue;
- (BOOL) deleteQueue:(NSString *)qId;
- (NSMutableArray *) getQueues;
- (NSNumber *) getQueueCount;
- (BOOL) clearQueues;

- (BDMessageModel *) insertTextMessageLocal:(NSString *)tid
                           withWorkGroupWid:(NSString *)wid
                                withContent:(NSString *)content
                                withLocalId:(NSString *)localId
                            withSessionType:(NSString *)sessionType;

- (BDMessageModel *) insertImageMessageLocal:(NSString *)tid
                            withWorkGroupWid:(NSString *)wid
                                 withContent:(NSString *)content
                                 withLocalId:(NSString *)localId
                             withSessionType:(NSString *)sessionType;

- (BDMessageModel *) insertVoiceMessageLocal:(NSString *)tid
                            withWorkGroupWid:(NSString *)wid
                                withContent:(NSString *)content
                                 withLocalId:(NSString *)localId
                            withSessionType:(NSString *)sessionType
                             withVoiceLength:(int)voiceLength
                                  withFormat:format;

- (BDMessageModel *) insertFileMessageLocal:(NSString *)tid
                           withWorkGroupWid:(NSString *)wid
                                withContent:(NSString *)content
                                withLocalId:(NSString *)localId
                            withSessionType:(NSString *)sessionType
                                 withFormat:format
                               withFileName:(NSString *)fileName
                               withFileSize:(NSString *)fileSize;

- (BDMessageModel *) insertCommodityMessageLocal:(NSString *)tid
                                withWorkGroupWid:(NSString *)wid
                                     withContent:(NSString *)content
                                     withLocalId:(NSString *)localId
                                 withSessionType:(NSString *)sessionType;

- (BDMessageModel *) insertRedPacketMessageLocal:(NSString *)tid
                                withWorkGroupWid:(NSString *)wid
                                withContent:(NSString *)content
                                     withLocalId:(NSString *)localId
                            withSessionType:(NSString *)sessionType;


/**
 插入消息到本地
  TODO: 加频率限制，每秒1条

 @param tid <#tid description#>
 @param wid <#wid description#>
 @param content <#content description#>
 @param localId <#localId description#>
 @param type <#type description#>
 @param sessionType <#sessionType description#>
 @param voiceLength <#voiceLength description#>
 @param format <#format description#>
 @param fileName <#fileName description#>
 @param fileSize <#fileSize description#>
 @return <#return value description#>
 */
- (BDMessageModel *) insertMessageLocal:(NSString *)tid
                       withWorkGroupWid:(NSString *)wid
                            withContent:(NSString *)content
                            withLocalId:(NSString *)localId
                               withType:(NSString *)type
                        withSessionType:(NSString *)sessionType
                        withVoiceLength:(int)voiceLength
                             withFormat:(NSString *)format
                           withFileName:(NSString *)fileName
                           withFileSize:(NSString *)fileSize;

/**
  TODO: 加频率限制，每秒1条

 @param message <#message description#>
 @return <#return value description#>
 */
- (BOOL) insertMessage:(BDMessageModel *)message;

/**
  TODO: 加频率限制，每秒1条

 @param message <#message description#>
 @return <#return value description#>
 */
- (BOOL) insertMessageLocal:(BDMessageModel *)message;

- (NSMutableArray *)getMessagesWithType:(NSString *)type withUid:(NSString *)uid;
- (NSMutableArray *)getMessagesPage:(NSUInteger)page withSize:(NSUInteger)size withType:(NSString *)type withUid:(NSString *)uid;

- (BOOL) updateMessage:(NSString *)localId withServerId:(NSNumber *)serverId withMid:(NSString *)mid withStatus:(NSString *)status;

- (BOOL) updateMessageSuccess:(NSString *)localId;
- (BOOL) updateMessageError:(NSString *)localId;
- (BOOL) updateMessage:(NSString *)localId withStatus:(NSString *)status;
- (BOOL) updateMessage:(NSString *)mId withLocalFilePath:(NSString *)localFilePath;
- (BOOL) updateMessageLocal:(NSString *)localId withLocalFilePath:(NSString *)localFilePath;

- (BOOL) deleteMessage:(NSString *)mid;

- (BOOL) deleteThreadMessages:(NSString *)tid;
- (BOOL) deleteContactMessages:(NSString *)uid;
- (BOOL) deleteGroupMessages:(NSString *)gid;
- (BOOL) clearMessages;


- (BOOL) insertContact:(BDContactModel *)contact;
- (NSMutableArray *) getContacts;
- (BOOL) clearContacts;

- (BOOL) insertGroup:(BDGroupModel *)group;
- (NSMutableArray *) getGroups;
- (BOOL) clearGroups;

- (BOOL) insertWorkGroup:(BDWorkGroupModel *)workGroup;
- (NSMutableArray *) getWorkGroups;
- (BOOL) clearWorkGroups;

#pragma mark - 公共接口

- (void) clearAll;



@end
