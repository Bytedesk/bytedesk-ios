//
//  KFDSMsgViewCell.h
//  feedback
//
//  Created by 萝卜丝·Bytedesk.com on 2017/2/18.
//  Copyright © 2017年 萝卜丝·Bytedesk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QMUIKit/QMUIKit.h>

//@class KFDSMessage;
@import bdcore;

@protocol KFDSMsgViewCellDelegate <NSObject>

@optional

//- (void)tapCellWith:(NSInteger)tag;
- (void)removeCellWith:(NSInteger)tag;
- (void)avatarClicked:(BDMessageModel *)messageModel;

//- (void)onTapCell:(NIMKitEvent *)event;
//- (void)onLongPressCell:(KFDSMessage *)message
//                 inView:(UIView *)view;
//- (void)onRetryMessage:(KFDSMessage *)message;
//- (void)onTapAvatar:(NSString *)userId;
//- (void)onTapLinkData:(id)linkData;

// TODO: 打开放大图片
- (void) imageViewClicked:(UIImageView *)imageView;

@end


@class KFDSMsgBaseContentView;
@class KFDSBadgeView;

@interface KFDSMsgViewCell : QMUITableViewCell

@property (nonatomic, strong) QMUILabel                   *timestampLabel;
@property (nonatomic, strong) QMUILabel                   *nicknameLabel;          //姓名（群显示 个人不显示）
@property (nonatomic, strong) UIImageView                 *avatarImageView;
@property (nonatomic, strong) KFDSMsgBaseContentView      *bubbleView;             //内容区域
@property (nonatomic, strong) UIActivityIndicatorView     *sendingStatusActivityIndicator;  //发送loading
@property (nonatomic, strong) QMUIButton                  *resendButton;             //重试
@property (nonatomic, strong) KFDSBadgeView               *audioUnplayedIcon;         //语音未读红点
@property (nonatomic, strong) QMUILabel                   *readLabel;               //已读
@property (nonatomic, strong) BDMessageModel            *messageModel;

@property(nonatomic, assign) id<KFDSMsgViewCellDelegate>  delegate;

- (void)initWithMessageModel:(BDMessageModel *)messageModel;

@end






