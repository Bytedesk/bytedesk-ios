//
//  KFDSCUtils.h
//  bdcore
//
//  Created by 萝卜丝 on 2018/11/23.
//  Copyright © 2018年 Bytedesk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//如果要禁止发送消息时播放声音，请设置此值为整数2，
//如：[[NSUserDefaults standardUserDefaults] setInteger:2 forKey:APPKEFU_SHOULD_PLAY_SEND_MESSAGE_SOUND];
#define APPKEFU_SHOULD_PLAY_SEND_MESSAGE_SOUND      @"appkefu_should_play_send_message_sound"
//如果要禁止收到消息时播放声音，请设置此值为整数2，
//如：[[NSUserDefaults standardUserDefaults] setInteger:2 forKey:APPKEFU_SHOULD_PLAY_RECEIVE_MESSAGE_SOUND];
#define APPKEFU_SHOULD_PLAY_RECEIVE_MESSAGE_SOUND   @"appkefu_should_play_receive_message_sound"
//如果要禁止收到消息时震动，请设置此值为整数2，
//如：[[NSUserDefaults standardUserDefaults] setInteger:2 forKey:APPKEFU_SHOULD_VIBRATE_ON_RECEIVE_MESSAGE];
#define APPKEFU_SHOULD_VIBRATE_ON_RECEIVE_MESSAGE   @"appkefu_should_vibrate_on_receiving_message"


@interface BDUtils : NSObject

+(NSString *)getCurrentDate;

+ (NSDate *)stringToDate:(NSString *)string;

+ (NSString *) getOptimizedTimestamp:(NSString *)date;

+ (NSString *)getCurrentTimeString;

+ (NSString *)deviceVersion;

+ (NSString *)dictToJson:(NSDictionary *)dict;

+ (NSString *)getQRCodeLogin;

+ (NSString *)getQRCodeUser:(NSString *)uid;

+ (NSString *)getQRCodeGroup:(NSString *)gid;

//函数35: 设置发送消息时是否播放提示音
+(BOOL) shouldRingWhenSendMessage;
+(void) setRingWhenSendMessage:(BOOL)flag;

//函数36: 设置接收到消息时是否播放提示音
+(BOOL) shouldRingWhenReceiveMessage;
+(void) setRingWhenReceiveMessage:(BOOL)flag;

//函数37: 设置接收到消息时是否震动
+(BOOL) shouldVibrateWhenReceiveMessage;
+(void) setVibrateWhenReceiveMessage:(BOOL)flag;

#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber;

//
+ (BOOL)canRecordVoice;
//
+ (BOOL)checkMicrophonePermission;
//
+ (BOOL)isSimulator;

/**
 断开连接，清空缓存
 */
+ (void)clearOut;

@end
