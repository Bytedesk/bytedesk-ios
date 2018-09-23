//
//  KFDSNotificationViewCell.h
//  feedback
//
//  Created by 萝卜丝·Bytedesk.com on 2017/2/21.
//  Copyright © 2017年 萝卜丝·Bytedesk.com. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import <QMUIKit/QMUIKit.h>


@import bdcore;


@interface KFDSMsgNotificationViewCell : QMUITableViewCell

@property(nonatomic, strong) QMUILabel                   *timestampLabel;
@property(nonatomic, strong) QMUILabel                   *contentLabel;
@property(nonatomic, strong) BDMessageModel            *messageModel;

- (void)initWithMessageModel:(BDMessageModel *)messageModel;

@end
