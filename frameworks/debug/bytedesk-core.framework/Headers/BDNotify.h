//
//  KFDSCNotify.h
//  bdcore
//
//  Created by 宁金鹏 on 2017/11/23.
//  Copyright © 2017年 Bytedesk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BDQueueModel;
@class BDThreadModel;
@class BDMessageModel;


@interface BDNotify : NSObject

+ (void)registerOAuthResult:(id)observer;
+ (void)unregisterOAuthResult:(id)observer;


+ (void)notifyOAuthResult:(BOOL)isSuccess;

+ (void)notifyInitStatus:(NSString *)status;


//
+ (void)notifyThreadAdd:(BDThreadModel *)threadModel;

+ (void)notifyThreadDelete:(NSNumber *)threadId;

+ (void)notifyThreadClose:(NSNumber *)threadId;


//
+ (void)notifyQueueAdd:(BDQueueModel *)queueModel;

+ (void)notifyQueueDelete:(NSNumber *)queueId;

+ (void)notifyQueueAccept:(NSNumber *)queueId;


//
+ (void)notifyMessageAdd:(BDMessageModel *)messageModel;

+ (void)notifyMessageTextSend:(NSNumber *)threadId withContent:(NSString *)content withLocalId:(NSNumber *)localId;

+ (void)notifyMessageImageSend:(NSNumber *)threadId withImageUrl:(NSString *)imageUrl withLocalId:(NSNumber *)localId;

+ (void)notifyMessageDelete:(NSNumber *)messageId;

+ (void)notifyMessageRetract:(NSNumber *)messageId;

+ (void)notifyMessage:(NSNumber *)localId withStatus:(NSString *)status;


@end












