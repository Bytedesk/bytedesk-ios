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
  发送消息送达通知

 @param mId 消息唯一mid
 */
- (void)sendReceiptReceivedMessage:(NSString *)mId;

/**
  发送消息已读通知

 @param mId 消息唯一mid
 */
- (void)sendReceiptReadMessage:(NSString *)mId;

/**
 发送消息销毁通知

 @param mId 消息唯一mid
 */
- (void)sendReceiptDestroyedMessage:(NSString *)mId;


/**
 发送消息回执通知

 @param mId mid
 @param status status
 */
- (void)sendReceiptMessage:(NSString *)mId status:(NSString *)status;


- (void)sendWebRTCKeFuInviteMessage:(NSString *)uuid;

- (void)sendWebRTCKeFuMessage:(NSString *)uuid type:(NSString *)type;

- (void)sendWebRTCContactInviteMessage:(NSString *)uuid;

- (void)sendWebRTCContactOfferMessage:(NSString *)uuid sdp:(NSString *)sdp;

- (void)sendWebRTCContactAnswerMessage:(NSString *)uuid sdp:(NSString *)sdp;

- (void)sendWebRTCContactCandidateMessage:(NSString *)uuid candidate:(NSString *)candidate;

- (void)sendWebRTCContactCancelMessage:(NSString *)uuid;

- (void)sendWebRTCContactAcceptMessage:(NSString *)uuid;

- (void)sendWebRTCContactRejectMessage:(NSString *)uuid;

- (void)sendWebRTCContactCloseMessage:(NSString *)uuid;

- (void)sendWebRTCContactMessage:(NSString *)uuid type:(NSString *)type;

- (void)sendWebRTCGroupInviteMessage:(NSString *)uuid;

- (void)sendWebRTCGroupMessage:(NSString *)uuid type:(NSString *)type;


/**
 发送webrtc消息

 @param uuid 会话tid、用户uid 或者 群组gid
 @param type 消息类型：invite、sdp、ice等
 @param sessionType 会话类型：客服会话、单聊、群组
 */
- (void)sendWebRTCMessage:(NSString *)uuid type:(NSString *)type sessionType:(NSString *)sessionType content:(NSString *)content;

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
