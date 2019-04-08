//
//  KFDSCNotify.h
//  bdcore
//
//  Created by 萝卜丝 on 2018/11/23.
//  Copyright © 2018年 Bytedesk.com. All rights reserved.
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

+ (void)notifyConnnectionStatus:(NSString *)status;

//

+ (void)notifyThreadAdd:(BDThreadModel *)threadModel;

+ (void)notifyThreadDelete:(NSString *)tid;

+ (void)notifyThreadClose:(NSString *)tid;

+ (void)notifyThreadUpdate;


//
+ (void)notifyQueueAdd:(BDQueueModel *)queueModel;

+ (void)notifyQueueDelete:(NSString *)qid;

+ (void)notifyQueueAccept:(NSString *)qid;

+ (void)notifyQueueUpdate;

//
+ (void)notifyMessageAdd:(BDMessageModel *)messageModel;

+ (void)notifyMessageTextSend:(NSString *)tid withContent:(NSString *)content withLocalId:(NSNumber *)localId;

+ (void)notifyMessageImageSend:(NSString *)tid withImageUrl:(NSString *)imageUrl withLocalId:(NSNumber *)localId;

+ (void)notifyMessageDelete:(NSNumber *)messageId;

+ (void)notifyMessageRetract:(NSNumber *)messageId;

+ (void)notifyMessage:(NSNumber *)localId withStatus:(NSString *)status;

//
+ (void)notifyContactUpdate;

+ (void)notifyGroupUpdate;

+ (void)notifyProfileUpdate;

//
+ (void)notifyKickoff:(NSString *)content;


// webrtc
+ (void)notifyWebRTCInvite:(NSDictionary *)dict;

+ (void)notifyWebRTCCancel:(NSDictionary *)dict;

+ (void)notifyWebRTCOfferVideo:(NSDictionary *)dict;

+ (void)notifyWebRTCOfferAudio:(NSDictionary *)dict;

+ (void)notifyWebRTCAnswer:(NSDictionary *)dict;

+ (void)notifyWebRTCCandidate:(NSDictionary *)dict;

+ (void)notifyWebRTCAccept:(NSDictionary *)dict;

+ (void)notifyWebRTCReject:(NSDictionary *)dict;

+ (void)notifyWebRTCReady:(NSDictionary *)dict;

+ (void)notifyWebRTCBusy:(NSDictionary *)dict;

+ (void)notifyWebRTCClose:(NSDictionary *)dict;

@end












