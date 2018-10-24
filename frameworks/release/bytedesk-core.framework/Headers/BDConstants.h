//
//  BDConstants.h
//  bdcore
//
//  Created by 萝卜丝 on 2018/11/22.
//  Copyright © 2018年 Bytedesk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef BDConstants_h
#define BDConstants_h
//
//typedef void (^SuccessCallbackBlock)(NSDictionary *dict)
//typedef void (^FailedCallbackBlock)(NSError *error)

#define BD_MQTT_PORT                        1883
#define BD_MQTT_AUTH_USERNAME               @"mqtt_ios"
#define BD_MQTT_AUTH_PASSWORD               @"mqtt_ios"
#define BD_MQTT_TOPIC_MESSAGE               @"message/mqtt"
#define BD_MQTT_TOPIC_STATUS                @"status/mqtt"
#define BD_MQTT_TOPIC_LASTWILL              @"lastWill/mqtt"

// 测试域名
// web后台此域名非统一的，而是每一家使用自己独特的二级域名
//#define BD_IS_DEBUG                         true
//#define BD_MQTT_HOST                        @"mq.bytedesk.com" // @"47.106.239.170"
//#define HTTP_VISITOR_API_BASE_URL           @"http://vip.kefudashi.cn:8000/visitor/api"
//#define HTTP_API_BASE_URL                   @"http://vip.kefudashi.cn:8000/api"
//#define CLIENT_OAUTH_TOKEN                  @"http://vip.kefudashi.cn:8000/oauth/token"

// 上线发布域名
#define BD_IS_DEBUG                         false
#define BD_MQTT_HOST                        @"mq.bytedesk.com"
#define HTTP_VISITOR_API_BASE_URL           @"https://api.bytedesk.com/visitor/api"
#define HTTP_API_BASE_URL                   @"https://api.bytedesk.com/api"
#define CLIENT_OAUTH_TOKEN                  @"https://api.bytedesk.com/oauth/token"

// 会话类型
#define BD_THREAD_TYPE_WORKGROUP            @"workGroup"  // 工作组会话
#define BD_THREAD_TYPE_VISITOR              @"visitor"    // 一对一会话
#define BD_THREAD_TYPE_GROUP                @"group"      // 群组
#define BD_THREAD_TYPE_CONTACT              @"contact" // 讨论组, 暂未启用

// passport 授权访客端参数
#define CLIENT_ID_VISITOR                   @"ios"
#define CLIENT_SECRET_VISITOR               @"XSf9jKCAPpeMwDZakt8AkvKppHEmXAb5sX0FtXwn"
// passport 授权客服端参数
#define CLIENT_ID_ADMIN                     @"ios"
#define CLIENT_SECRET_ADMIN                 @"XSf9jKCAPpeMwDZakt8AkvKppHEmXAb5sX0FtXwn"
//
#define kTimeOutInterval                    30

// 角色类型
#define BD_ROLE_VISITOR                     @"visitor" // 访客
#define BD_ROLE_ADMIN                       @"admin"   // 管理员
#define BD_ROLE_COMPANY                     @"company"  // 企业
#define BD_ROLE_PROXY                       @"proxy"  // 代理
#define BD_ROLE_AGENT                       @"agent" // 客服人员
#define BD_ROLE_AGENT_ADMIN                 @"agent_admin" // 客服组长
#define BD_ROLE_CHECKER                     @"checker" // 质检人员
#define BD_ROLE_CHECKER_ADMIN               @"checker_admin" // 质检组长
#define BD_ROLE_WECHAT                      @"wechat" // 微信
#define BD_ROLE_MINI_PROGRAM                @"mini_program" // 微信小程序
#define BD_ROLE_WORKGROUP                   @"workgroup" // 工作组
#define BD_ROLE_ROBOT                       @"robot" // 机器人

// 访客端
#define BD_CLIENT_WEB                       @"web"   // 访客pc网站
#define BD_CLIENT_WAP                       @"wap"    // 访客手机网站
#define BD_CLIENT_ANDROID                   @"android"  // 访客安卓
#define BD_CLIENT_IOS                       @"ios"         // 访客苹果
#define BD_CLIENT_WECHAT_MINI               @"wechat_mini"  // 访客小程序
#define BD_CLIENT_WECHAT_MP                 @"wechat_mp"    // 访客微信客服接口
#define BD_CLIENT_WECHAT_URL                @"wechat_url"   // 访客微信自定义菜单

// 客服端
#define BD_CLIENT_WINDOW_ADMIN              @"window_admin"     // Windwow客服端
#define BD_CLIENT_MAC_ADMIN                 @"mac_admin"           // MAC客服端
#define BD_CLIENT_ANDROID_ADMIN             @"android_admin"   // 安卓手机客服端
#define BD_CLIENT_IOS_ADMIN                 @"ios_admin"           // 苹果手机客服端
#define BD_CLIENT_WEB_ADMIN                 @"web_admin"           // web客服端
#define BD_CLIENT_WECHAT_MINI_ADMIN         @"wechat_mini_admin"   // 小程序客服端
//#define BD_CLIENT_POMELO_ADMIN              @"pomelo_admin"     // Pomelo服务器
#define BD_CLIENT_SYSTEM                    @"system"           // 系统端

#define BD_ERROR_WITH_DOMAIN                @"error.ios.bytedesk.com"

#define BD_NOTIFICATION_OAUTH_RESULT        @"bd_notification_oauth_result"

#define BD_NOTIFICATION_INIT_STATUS         @"bd_notification_init_status"
#define BD_NOTIFICATION_INIT_STATUS_LOADING @"bd_notification_init_status_loading"
#define BD_NOTIFICATION_INIT_STATUS_LOADED  @"bd_notification_init_status_loaded"
#define BD_NOTIFICATION_INIT_STATUS_ERROR   @"bd_notification_init_status_error"

// 通知UI thread状态
#define BD_NOTIFICATION_THREAD              @"bd_notification_thread"
#define BD_NOTIFICATION_THREAD_ADD          @"bd_notification_thread_add"
#define BD_NOTIFICATION_THREAD_UPDATE       @"bd_notification_thread_update"
#define BD_NOTIFICATION_THREAD_DELETE       @"bd_notification_thread_delete"
#define BD_NOTIFICATION_THREAD_CLOSE        @"bd_notification_thread_close"

// 通知UI queue状态
#define BD_NOTIFICATION_QUEUE               @"bd_notification_queue"
#define BD_NOTIFICATION_QUEUE_ADD           @"bd_notification_queue_add"
#define BD_NOTIFICATION_QUEUE_UPDATE        @"bd_notification_queue_update"
#define BD_NOTIFICATION_QUEUE_DELETE        @"bd_notification_queue_delete"
#define BD_NOTIFICATION_QUEUE_ACCEPT        @"bd_notification_queue_accept"

// 通知UI message状态
#define BD_NOTIFICATION_MESSAGE_ADD         @"bd_notification_message_add"
#define BD_NOTIFICATION_MESSAGE_DELETE      @"bd_notification_message_delete"
#define BD_NOTIFICATION_MESSAGE_RETRACT     @"bd_notification_message_retract"
#define BD_NOTIFICATION_MESSAGE_STATUS      @"bd_notification_message_status"

/**
 * 用户在线状态：
 */
#define BD_USER_STATUS_CONNECTED            @"connected" //跟服务器建立长连接
#define BD_USER_STATUS_DISCONNECTED         @"disconnected" //断开长连接
#define BD_USER_STATUS_ONLINE               @"online" //在线状态
#define BD_USER_STATUS_OFFLINE              @"offline" //离线状态
#define BD_USER_STATUS_BUSY                 @"busy" //忙
#define BD_USER_STATUS_AWAY                 @"away" //离开
#define BD_USER_STATUS_LOGOUT               @"logout" //登出
#define BD_USER_STATUS_LOGIN                @"login" //登录
#define BD_USER_STATUS_LEAVE                @"leave" //离开
#define BD_USER_STATUS_AFTER                @"after" //话后
#define BD_USER_STATUS_EAT                  @"eat"  //就餐
#define BD_USER_STATUS_REST                 @"rest" //小休

// 消息发送状态
#define BD_MESSAGE_STATUS_SENDING           @"sending"  // 发送中
#define BD_MESSAGE_STATUS_RECEIVED          @"received" // 送达
#define BD_MESSAGE_STATUS_READ              @"read" // 已读
#define BD_MESSAGE_STATUS_STORED            @"stored" // 发送到服务器，成功存储数据库中
#define BD_MESSAGE_STATUS_ERROR             @"error" // 发送错误

// 消息类型
#define BD_MESSAGE_TYPE_TEXT                @"text"  // 文本消息类型
#define BD_MESSAGE_TYPE_IMAGE               @"image"  // 图片消息类型
#define BD_MESSAGE_TYPE_VOICE               @"voice"  // 语音消息类型
#define BD_MESSAGE_TYPE_VIDEO               @"video"  // 视频消息类型
#define BD_MESSAGE_TYPE_SHORTVIDEO          @"shortvideo"    // 短视频消息类型
#define BD_MESSAGE_TYPE_LOCATION            @"location"    // 位置消息类型
#define BD_MESSAGE_TYPE_LINK                @"link"    // 链接消息类型
#define BD_MESSAGE_TYPE_EVENT               @"event"  // 事件消息类型
#define BD_MESSAGE_TYPE_ROBOT               @"robot"
#define BD_MESSAGE_TYPE_NOTIFICATION        @"notification"    // 通知消息类型

#define BD_MESSAGE_TYPE_NOTIFICATION_NON_WORKINGTIME    @"notification_non_workingtime"    // 非工作时间
#define BD_MESSAGE_TYPE_NOTIFICATION_OFFLINE            @"notification_offline"    // 客服离线，当前无客服在线
#define BD_MESSAGE_TYPE_NOTIFICATION_BROWSE             @"notification_browse"  // 访客网页浏览中
#define BD_MESSAGE_TYPE_NOTIFICATION_THREAD             @"notification_thread"  // 新会话thread
#define BD_MESSAGE_TYPE_NOTIFICATION_QUEUE              @"notification_queue"    // 排队通知类型
#define BD_MESSAGE_TYPE_NOTIFICATION_ACCEPT_AUTO        @"notification_accept_auto"    // 自动接入会话
#define BD_MESSAGE_TYPE_NOTIFICATION_ACCEPT_MANUAL      @"notification_accept_manual"    // 手动接入
#define BD_MESSAGE_TYPE_NOTIFICATION_CONNECT            @"notification_connect"    // 上线
#define BD_MESSAGE_TYPE_NOTIFICATION_DISCONNECT         @"notification_disconnect"  // 离线
#define BD_MESSAGE_TYPE_NOTIFICATION_LEAVE              @"notification_leave"    // 离开会话页面
#define BD_MESSAGE_TYPE_NOTIFICATION_CLOSE              @"notification_close"    // 关闭会话
#define BD_MESSAGE_TYPE_NOTIFICATION_INVITE_RATE        @"notification_invite_rate"    // 邀请评价
#define BD_MESSAGE_TYPE_NOTIFICATION_INVITE             @"notification_invite"  // 邀请会话
#define BD_MESSAGE_TYPE_NOTIFICATION_INVITE_ACCEPT      @"notification_invite_accept"    // 接受邀请
#define BD_MESSAGE_TYPE_NOTIFICATION_INVITE_REJECT      @"notification_invite_reject"    // 拒绝邀请
#define BD_MESSAGE_TYPE_NOTIFICATION_TRANSFER           @"notification_transfer"  // 转接会话
#define BD_MESSAGE_TYPE_NOTIFICATION_TRANSFER_ACCEPT    @"notification_transfer_accept"    // 接受转接
#define BD_MESSAGE_TYPE_NOTIFICATION_TRANSFER_REJECT    @"notification_transfer_reject"    // 拒绝转接
#define BD_MESSAGE_TYPE_NOTIFICATION_RATE_REQUEST       @"notification_rate_request"  // 满意度请求
#define BD_MESSAGE_TYPE_NOTIFICATION_RATE               @"notification_rate"  // 评价


#endif /* BDConstants_h */

