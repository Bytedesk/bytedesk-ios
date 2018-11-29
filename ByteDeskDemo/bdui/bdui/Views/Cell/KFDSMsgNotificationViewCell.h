//
//  KFDSNotificationViewCell.h
//  feedback
//
//  Created by 萝卜丝 · bytedesk.com on 2018/2/21.
//  Copyright © 2018年 萝卜丝 · bytedesk.com. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import <QMUIKit/QMUIKit.h>
#import <bytedesk-core/bdcore.h>

@interface KFDSMsgNotificationViewCell : QMUITableViewCell

@property(nonatomic, strong) QMUILabel                   *timestampLabel;
@property(nonatomic, strong) QMUILabel                   *contentLabel;
@property(nonatomic, strong) BDMessageModel            *messageModel;

- (void)initWithMessageModel:(BDMessageModel *)messageModel;

@end
