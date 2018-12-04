//
//  WXMQTTApis.h
//  bdcore
//
//  Created by 萝卜丝 on 2018/5/20.
//  Copyright © 2018年 KeFuDaShi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDMQTTApis : NSObject

+ (BDMQTTApis *)sharedInstance;

- (void)connect;

- (void)connect:(NSString *)clientId;

- (void)subscribeTopic:(NSString *)topic;

- (void)unsubscribeTopic:(NSString *)topic;

- (void)sendTextMessage:(NSString *)content toTid:(NSString *)tId sessionType:(NSString *)stype;
- (void)sendImageMessage:(NSString *)content toTid:(NSString *)tId sessionType:(NSString *)stype;
- (void)sendVoiceMessage:(NSString *)content toTid:(NSString *)tId sessionType:(NSString *)stype;
- (void)sendMessage:(NSString *)content type:(NSString *)type toTid:(NSString *)tId sessionType:(NSString *)stype;

- (void)setStatus:(NSString *)status;

- (void)logout;

@end
