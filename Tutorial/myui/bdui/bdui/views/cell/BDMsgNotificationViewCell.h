//
//  KFDSNotificationViewCell.h
//  feedback
//
//  Created by 萝卜丝 on 2018/2/21.
//  Copyright © 2018年 萝卜丝. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>
#import <bytedesk-core/bdcore.h>

@interface BDMsgNotificationViewCell : QMUITableViewCell

@property(nonatomic, strong) QMUILabel                   *timestampLabel;
@property(nonatomic, strong) QMUILabel                   *contentLabel;
@property(nonatomic, strong) BDMessageModel            *messageModel;

- (void)initWithMessageModel:(BDMessageModel *)messageModel;

@end
