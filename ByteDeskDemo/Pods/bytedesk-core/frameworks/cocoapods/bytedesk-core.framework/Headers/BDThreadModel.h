//
//  KFDSThreadModel.h
//  bdcore
//
//  Created by 萝卜丝 on 2018/11/24.
//  Copyright © 2018年 Bytedesk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDThreadModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

// 本地表主键id
@property(nonatomic, strong) NSNumber *local_id;

@property(nonatomic, strong) NSNumber *server_id;
@property(nonatomic, strong) NSString *tid;
@property(nonatomic, strong) NSString *session_id;

@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSString *timestamp;
@property(nonatomic, strong) NSNumber *unreadcount;
@property(nonatomic, strong) NSString *type;

@property(nonatomic, strong) NSNumber *queue_id;
@property(nonatomic, strong) NSNumber *agent_id;
@property(nonatomic, strong) NSNumber *workgroup_id;

@property(nonatomic, strong) NSString *startedAt;
@property(nonatomic, strong) NSNumber *closed;
@property(nonatomic, strong) NSString *closedAt;

@property(nonatomic, strong) NSNumber *visitor_id;
@property(nonatomic, strong) NSString *nickname;
@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *avatar;
@property(nonatomic, strong) NSString *client;

@property(nonatomic, strong) NSString *myusername;

//@property(nonatomic, strong) NSNumber *wait_timelength;
//@property(nonatomic, strong) NSString *craft; // 草稿, TODO: 暂定保存在content字段中

@end




