//
//  KFDSMessageModel.h
//  bdcore
//
//  Created by 萝卜丝 on 2018/11/24.
//  Copyright © 2018年 Bytedesk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BDMessageModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

// 本地表主键id
@property(nonatomic, strong) NSNumber *local_id;

@property(nonatomic, strong) NSNumber *server_id;
@property(nonatomic, strong) NSString *mid;
@property(nonatomic, strong) NSString *wid;

@property(nonatomic, strong) NSNumber *thread_tid;
//@property(nonatomic, strong) NSNumber *queue_id;
//@property(nonatomic, strong) NSNumber *workgroup_id;

@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSString *client;

// 文本消息
@property(nonatomic, strong) NSString *content; // 文本消息
// 图片消息
@property(nonatomic, strong) NSString *pic_url; // 微信pic_url，web版容易引起跨域访问问题，所以要使用pic_url
@property(nonatomic, strong) NSString *image_url; // 存储在自己服务器之后的url
// 语音消息
@property(nonatomic, strong) NSString *media_id; // 图片+语音+视频+短视频 公用字段
@property(nonatomic, strong) NSString *format; // 语音格式amr等
@property(nonatomic, strong) NSString *voice_url; // 语音url
@property(nonatomic, strong) NSNumber *length; // 时间长度
@property(nonatomic, strong) NSNumber *played; // 是否播放过
// 视频消息 & 短视频消息
@property(nonatomic, strong) NSString *thumb_media_id;
@property(nonatomic, strong) NSString *video_or_short_url; // 视频和短视频 url
@property(nonatomic, strong) NSString *video_or_short_thumb_url; // 视频和短视频 thumb url
// 地理位置消息
@property(nonatomic, strong) NSString *location_x;
@property(nonatomic, strong) NSString *location_y;
@property(nonatomic, strong) NSString *scale;
@property(nonatomic, strong) NSString *label;
// 链接消息
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *mdescription;
@property(nonatomic, strong) NSString *url;
//
@property(nonatomic, strong) NSString *createdAt;
@property(nonatomic, strong) NSString *send_status; // 命名为status会跟objective-c系统默认命名冲突
//
@property(nonatomic, assign) CGSize     contentSize;
@property(nonatomic, assign) UIEdgeInsets  contentViewInsets;
//@property(nonatomic, assign) UIEdgeInsets  bubbleViewInsets;

@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *nickname;
@property(nonatomic, strong) NSString *avatar;
@property(nonatomic, strong) NSNumber *visitor;

@property(nonatomic, strong) NSString *myusername;

//
- (BOOL)isSend;
- (BOOL)isNotification;

@end








