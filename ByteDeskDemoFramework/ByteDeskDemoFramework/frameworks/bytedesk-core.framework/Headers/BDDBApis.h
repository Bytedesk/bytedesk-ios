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
@class BDProfileModel;
@class BDContactModel;

typedef void (^SuccessCallbackBlock)(NSDictionary *dict);
typedef void (^FailedCallbackBlock)(NSError *error);

@interface BDDBApis : NSObject

+ (BDDBApis *)sharedInstance;

#pragma mark - 访客端接口


#pragma mark - 客服端接口

- (BOOL) insertThread:(BDThreadModel *)thread;
- (BOOL) deleteThread:(NSNumber *)threadId;
- (NSMutableArray *) getThreads;
- (BOOL) clearThreads;

- (BOOL) insertQueue:(BDQueueModel *)queue;
- (BOOL) deleteQueue:(NSNumber *)queueId;
- (NSMutableArray *) getQueues;
- (NSNumber *) getQueueCount;
- (BOOL) clearQueues;

- (BOOL) insertMessage:(BDMessageModel *)message;
- (NSNumber *) insertSendTextMessageToThread:(NSNumber *)threadId withContent:(NSString *)content;
- (NSNumber *) insertSendImageMessageToThread:(NSNumber *)threadId withImageUrl:(NSString *)imageUrl;
- (NSNumber *) insertSendVoiceMessageToThread:(NSNumber *)threadId withVoiceUrl:(NSString *)voiceUrl;
- (BOOL) updateMessage:(NSNumber *)localId withStatus:(NSString *)status;
- (BOOL) updateMessage:(NSNumber *)localId withMessageId:(NSNumber *)messageId;
- (BOOL) deleteMessage:(NSString *)mid;

// TODO: 分页查询
- (NSMutableArray *)getMessagesWithThread:(NSNumber *)threadId;
- (NSMutableArray *)getMessagesWithWorkgroup:(NSString *)wId;

- (BOOL) insertProfile:(BDProfileModel *)profile;
- (BDProfileModel *) getProfile;

- (BOOL) insertContact:(BDContactModel *)contact;
- (NSMutableArray *) getContacts;
- (BOOL) clearContacts;

#pragma mark - 公共接口



@end
