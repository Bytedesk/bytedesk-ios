//
//  KFDSQueueModel.h
//  bdcore
//
//  Created by 宁金鹏 on 2017/11/24.
//  Copyright © 2017年 Bytedesk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDQueueModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

// 本地表主键id
@property(nonatomic, strong) NSNumber *local_id;

@property(nonatomic, strong) NSNumber *server_id;
@property(nonatomic, strong) NSString *qid;

@property(nonatomic, strong) NSNumber *visitor_id;
@property(nonatomic, strong) NSString *visitor_client;

@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *nickname;
@property(nonatomic, strong) NSString *avatar;
@property(nonatomic, strong) NSString *client;

@property(nonatomic, strong) NSNumber *agent_id;
@property(nonatomic, strong) NSString *agent_client;

@property(nonatomic, strong) NSNumber *workgroup_id;

@property(nonatomic, strong) NSString *createdAt;
@property(nonatomic, strong) NSString *acceptedAt;
@property(nonatomic, strong) NSString *leavedAt;

@property(nonatomic, strong) NSString *status;

@property(nonatomic, strong) NSString *myusername;

@end
