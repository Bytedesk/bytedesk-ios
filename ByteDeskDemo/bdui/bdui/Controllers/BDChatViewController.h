//
//  KFDSChatViewController.h
//  bdui
//
//  Created by 宁金鹏 on 2017/11/29.
//  Copyright © 2017年 Bytedesk.com. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>

@import bdcore;

@interface BDChatViewController : QMUICommonTableViewController

#pragma mark - 访客端接口
/**
 访客端SDK请求会话初始化参数
 */
- (void) initWithUid:(NSString *)uId wId:(NSString *)wId withTitle:(NSString *)title withPush:(BOOL)isPush;


#pragma mark - 客服端接口
/**
 客服端打开会话的时候传入初始化数据
 */
- (void) initWithThreadModel:(BDThreadModel *)threadModel withPush:(BOOL)isPush;


#pragma mark - 公共接口



@end





