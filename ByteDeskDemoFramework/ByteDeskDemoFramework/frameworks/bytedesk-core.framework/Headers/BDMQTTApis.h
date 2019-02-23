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

/**
 建立连接
 */
- (void)connect;

/**
 建立连接

 @param clientId <#clientId description#>
 */
- (void)connect:(NSString *)clientId;

/**
 订阅主题

 @param topic <#topic description#>
 */
- (void)subscribeTopic:(NSString *)topic;

/**
 取消订阅

 @param topic <#topic description#>
 */
- (void)unsubscribeTopic:(NSString *)topic;

/**
 发送文本消息

 @param content <#content description#>
 @param tId <#tId description#>
 @param sessiontype <#stype description#>
 */
- (void)sendTextMessage:(NSString *)content toTid:(NSString *)tId localId:(NSString *)localId sessionType:(NSString *)sessiontype;

/**
 发送图片消息

 @param content <#content description#>
 @param tId <#tId description#>
 @param sessiontype <#stype description#>
 */
- (void)sendImageMessage:(NSString *)content toTid:(NSString *)tId localId:(NSString *)localId sessionType:(NSString *)sessiontype;

/**
 发送语音消息

 @param content <#content description#>
 @param tId <#tId description#>
 @param sessiontype <#stype description#>
 */
- (void)sendVoiceMessage:(NSString *)content toTid:(NSString *)tId localId:(NSString *)localId sessionType:(NSString *)sessiontype;

/**
 发送消息预知通知

 @param content <#content description#>
 @param tId <#tId description#>
 @param localId <#localId description#>
 @param sessiontype <#sessiontype description#>
 */
- (void)sendPreviewMessage:(NSString *)content toTid:(NSString *)tId localId:(NSString *)localId sessionType:(NSString *)sessiontype;

/**
 发送消息回执通知

 @param content <#content description#>
 @param tId <#tId description#>
 @param localId <#localId description#>
 @param sessiontype <#sessiontype description#>
 */
- (void)sendReceiptMessage:(NSString *)content toTid:(NSString *)tId localId:(NSString *)localId sessionType:(NSString *)sessiontype;

/**
 发送消息

 @param content <#content description#>
 @param type <#type description#>
 @param tId <#tId description#>
 @param sessiontype <#stype description#>
 */
- (void)sendMessage:(NSString *)content type:(NSString *)type toTid:(NSString *)tId localId:(NSString *)localId sessionType:(NSString *)sessiontype;

/**
 设置在线状态

 @param status <#status description#>
 */
- (void)setStatus:(NSString *)status;

/**
 断开连接
 */
- (void)disconnect;


- (BOOL)isConnected;


@end
