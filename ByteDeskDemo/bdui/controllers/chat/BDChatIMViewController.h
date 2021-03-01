//
//  BDChatWxViewController.h
//  bytedesk-ui
//
//  Created by 萝卜丝 on 2019/3/11.
//  Copyright © 2019 bytedesk.com. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>
#import <bytedesk-core/bdcore.h>
#import "BDChatBaseViewController.h"

// IM 对话窗口

NS_ASSUME_NONNULL_BEGIN

@interface BDChatIMViewController : BDChatBaseViewController

/**
 从会话列表进入：访客会话、联系人会话、群组会话
 
 @param threadModel <#threadModel description#>
 @param isPush <#isPush description#>
 */
- (void) initWithThreadModel:(BDThreadModel *)threadModel withPush:(BOOL)isPush;

- (void) initWithThreadModel:(BDThreadModel *)threadModel withPush:(BOOL)isPush withCustom:(NSDictionary *)custom;

/**
 联系人会话，一对一会话、单聊
 
 @param contactModel <#contactModel description#>
 @param isPush <#isPush description#>
 */
- (void) initWithContactModel:(BDContactModel *)contactModel withPush:(BOOL)isPush;

- (void) initWithContactModel:(BDContactModel *)contactModel withPush:(BOOL)isPush withCustom:(NSDictionary *)custom;

/**
 群组会话、群聊
 
 @param groupModel <#groupModel description#>
 @param isPush <#isPush description#>
 */
- (void) initWithGroupModel:(BDGroupModel *)groupModel withPush:(BOOL)isPush;

- (void) initWithGroupModel:(BDGroupModel *)groupModel withPush:(BOOL)isPush withCustom:(NSDictionary *)custom;


@end

NS_ASSUME_NONNULL_END
