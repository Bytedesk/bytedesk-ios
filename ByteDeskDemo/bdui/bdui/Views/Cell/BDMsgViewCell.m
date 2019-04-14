//
//  KFDSMsgViewCell.m
//  feedback
//
//  Created by 萝卜丝 on 2018/2/18.
//  Copyright © 2018年 萝卜丝. All rights reserved.
//

#import "BDMsgViewCell.h"
#import "KFDSBadgeView.h"
#import "KFDSUConstants.h"

#import "BDMsgBaseContentView.h"
#import "BDMsgTextContentView.h"
#import "BDMsgImageContentView.h"
#import "BDMsgVoiceContentView.h"
#import "BDMsgFileContentView.h"

#import "BDMsgQuestionnairViewCell.h"
#import "BDRedPacketTableViewCell.h"
#import "BDCommodityTableViewCell.h"


@import AFNetworking;
//#import <AFNetworking/UIImageView+AFNetworking.h>

#define AVATAR_WIDTH_HEIGHT       40.0f
#define TIMESTAMp_HEIGHT          20.0f

@interface BDMsgViewCell ()<KFDSMsgBaseContentViewDelegate> {
    UILongPressGestureRecognizer *_longPressGesture;
}

@end

@implementation BDMsgViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        [self setQmui_shouldShowDebugColor:YES];
        
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesturePress:)]];
    }
    return self;
}

- (void)initWithMessageModel:(BDMessageModel *)messageModel {
    _messageModel = messageModel;
    
    [self addSubviews];
    [self setNeedsLayout];
}

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    // Configure the view for the selected state
//}
//
//- (void)dealloc {
////    [self removeGestureRecognizer:_longPressGesture];
//}

- (BOOL)canBecomeFirstResponder  {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
//    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    if (action == @selector(mycopy:)) {
        return YES;
    }
    else if (action == @selector(mydelete:)) {
        return YES;
    }
    
    return NO;
}

- (void)mycopy:(id)sender {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    if ([_messageModel.type isEqualToString:BD_MESSAGE_TYPE_TEXT]) {
        [[UIPasteboard generalPasteboard] setString:_messageModel.content];
    } else if ([_messageModel.type isEqualToString:BD_MESSAGE_TYPE_IMAGE]){
        if (_messageModel.image_url) {
            [[UIPasteboard generalPasteboard] setString:_messageModel.image_url];
        }
        else if (_messageModel.pic_url){
            [[UIPasteboard generalPasteboard] setString:_messageModel.pic_url];
        }
    } else if ([_messageModel.type isEqualToString:BD_MESSAGE_TYPE_VOICE]) {
        [[UIPasteboard generalPasteboard] setString:_messageModel.voice_url];
    } else if ([_messageModel.type isEqualToString:BD_MESSAGE_TYPE_FILE]) {
        [[UIPasteboard generalPasteboard] setString:_messageModel.file_url];
    } else if ([_messageModel.type isEqualToString:BD_MESSAGE_TYPE_QUESTIONNAIRE]) {
        //
    }
    // TODO：其他类型消息记录
    //
    [self resignFirstResponder];
    _bubbleView.highlighted = NO;
}

-(void)mydelete:(id)sender {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    if ([_delegate respondsToSelector:@selector(removeCellWith:)]) {
        [_delegate removeCellWith:self.tag];
    }
}

- (void)addSubviews {
//    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    if (self.timestampLabel) {
        [self.timestampLabel removeFromSuperview];
        self.timestampLabel = nil;
    }
    if (self.avatarImageView) {
        [self.avatarImageView removeFromSuperview];
        self.avatarImageView = nil;
    }
    if (self.nicknameLabel) {
        [self.nicknameLabel removeFromSuperview];
        self.nicknameLabel = nil;
    }
    if (self.bubbleView) {
        [self.bubbleView removeFromSuperview];
        self.bubbleView = nil;
    }
    if (self.sendingStatusActivityIndicator) {
        [self.sendingStatusActivityIndicator removeFromSuperview];
        self.sendingStatusActivityIndicator = nil;
    }
    if (self.resendButton) {
        [self.resendButton removeFromSuperview];
        self.resendButton = nil;
    }
    if (self.audioUnplayedIcon) {
        [self.audioUnplayedIcon removeFromSuperview];
        self.audioUnplayedIcon = nil;
    }
    if (self.readLabel) {
        [self.readLabel removeFromSuperview];
        self.readLabel = nil;
    }
    
    if ([_messageModel.type isEqualToString:BD_MESSAGE_TYPE_TEXT]) {
        //
        _bubbleView = [[BDMsgTextContentView alloc] initMessageContentView];
    } else if ([_messageModel.type isEqualToString:BD_MESSAGE_TYPE_IMAGE]) {
        //
        _bubbleView = [[BDMsgImageContentView alloc] initMessageContentView];
    } else if ([_messageModel.type isEqualToString:BD_MESSAGE_TYPE_VOICE]) {
        //
        _bubbleView = [[BDMsgVoiceContentView alloc] initMessageContentView];
    } else if ([_messageModel.type isEqualToString:BD_MESSAGE_TYPE_FILE]) {
        //
        _bubbleView = [[BDMsgFileContentView alloc] initMessageContentView];
    } else if ([_messageModel.type isEqualToString:BD_MESSAGE_TYPE_QUESTIONNAIRE]) {
        //
        _bubbleView = [[BDMsgQuestionnairViewCell alloc] initMessageContentView];
    } else if ([_messageModel.type isEqualToString:BD_MESSAGE_TYPE_RED_PACKET]) {
        //
        _bubbleView = [[BDRedPacketTableViewCell alloc] initMessageContentView];
    } else {
        // TODO: 当前版本暂不支持查看此消息, 请升级
        // 暂未处理的类型，全部当做text类型处理
        _bubbleView = [[BDMsgTextContentView alloc] initMessageContentView];
    }
    //
    _bubbleView.delegate = self;
    
    [self.contentView addSubview:self.timestampLabel];
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.nicknameLabel];
    [self.contentView addSubview:self.bubbleView];
    
    [self.contentView addSubview:self.sendingStatusActivityIndicator];
    [self.contentView addSubview:self.resendButton];
    
    [self.contentView addSubview:self.audioUnplayedIcon];
    [self.contentView addSubview:self.readLabel];
}


- (QMUILabel *)timestampLabel {
    if (!_timestampLabel) {
        _timestampLabel = [QMUILabel new];
        _timestampLabel.textColor = [UIColor grayColor];
        _timestampLabel.font = [UIFont systemFontOfSize:11.0f];
    }
    return _timestampLabel;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 5;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.userInteractionEnabled = YES;
        //
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAvatarClicked:)];
        [singleTap setNumberOfTapsRequired:1];
        [_avatarImageView addGestureRecognizer:singleTap];
    }
    return _avatarImageView;
}

- (QMUILabel *)nicknameLabel {
    if (!_nicknameLabel) {
        _nicknameLabel = [QMUILabel new];
        _nicknameLabel.textColor = [UIColor grayColor];
        _nicknameLabel.font = [UIFont systemFontOfSize:11.0f];
        _nicknameLabel.backgroundColor = [UIColor clearColor];
    }
    return _nicknameLabel;
}

//- (KFDSMsgBaseContentView *)bubbleView {
//    if (!_bubbleView) {
//        _bubbleView = [[KFDSMsgBaseContentView alloc] init];
//    }
//    return _bubbleView;
//}

- (UIActivityIndicatorView *)sendingStatusActivityIndicator {
    if (!_sendingStatusActivityIndicator) {
        _sendingStatusActivityIndicator = [UIActivityIndicatorView new];
        _sendingStatusActivityIndicator.color = [UIColor grayColor];
    }
    [_sendingStatusActivityIndicator startAnimating];
    return _sendingStatusActivityIndicator;
}

- (QMUIButton *)resendButton {
    if (!_resendButton) {
        _resendButton = [[QMUIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        [_resendButton setImage:[UIImage imageNamed:@"appkefu_error.png" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [_resendButton addTarget:self action:@selector(sendErrorStatusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resendButton;
}

- (KFDSBadgeView *)audioUnplayedIcon {
    if (!_audioUnplayedIcon) {
        _audioUnplayedIcon = [KFDSBadgeView new];
    }
    return _audioUnplayedIcon;
}

- (QMUILabel *)readLabel {
    if (!_readLabel) {
        _readLabel = [QMUILabel new];
    }
    return _readLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    [self layoutTimestampLabel];
    [self layoutAvatarImageView];
    [self layoutNicknameLabel];
    [self layoutContentView];
    [self layoutSendingStatusActivityIndicator];
    [self layoutResendButton];
    [self layoutAudioUnplayedIcon];
    [self layoutReadLabel];
}


- (void)layoutTimestampLabel {
    //
    NSString *timestampString = [BDUtils getOptimizedTimestamp:_messageModel.created_at];
    CGSize timestampSize = [timestampString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f]}];
    _timestampLabel.frame = CGRectMake((self.bounds.size.width - timestampSize.width - 10)/2,
                                       0.5f, timestampSize.width + 10.0f, timestampSize.height+1);
    [_timestampLabel setText:timestampString];
}

- (void)layoutAvatarImageView {
//    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    if ([_messageModel isSend]) {
        _avatarImageView.frame = CGRectMake(KFDSScreen.width - 50, TIMESTAMp_HEIGHT, AVATAR_WIDTH_HEIGHT, AVATAR_WIDTH_HEIGHT);
    }
    else {
        _avatarImageView.frame = CGRectMake(5, TIMESTAMp_HEIGHT, AVATAR_WIDTH_HEIGHT, AVATAR_WIDTH_HEIGHT);
    }
    [_avatarImageView setImageWithURL:[NSURL URLWithString:_messageModel.avatar] placeholderImage:[UIImage imageNamed:@"avatar"]];
}

- (void)layoutNicknameLabel {
    
    if ([_messageModel isSend]) {
        _nicknameLabel.frame = CGRectZero;
    }
    else {
        _nicknameLabel.frame = CGRectMake(50, TIMESTAMp_HEIGHT, 100, 20);
        _nicknameLabel.text = _messageModel.nickname;
    }
}

- (void)layoutContentView {
    //
    [_bubbleView refresh:_messageModel];
    [_bubbleView setNeedsLayout];
}

- (void)layoutSendingStatusActivityIndicator {
    
    DDLogInfo(@"%s, status: %@, content: %@", __PRETTY_FUNCTION__, self.messageModel.status, self.messageModel.content);
    
//    if ([self.messageModel isSend]) {
        if ([self.messageModel.status isKindOfClass:[NSString class]] &&
            [self.messageModel.status isEqualToString:BD_MESSAGE_STATUS_SENDING]) {
            
            _sendingStatusActivityIndicator.frame = CGRectMake(_avatarImageView.frame.origin.x - self.messageModel.contentSize.width - self.messageModel.contentViewInsets.left - self.messageModel.contentViewInsets.right - 30,
                                                               _avatarImageView.frame.origin.y,
                                                               15, 15);
            
        } else {
            _sendingStatusActivityIndicator.frame = CGRectMake(-50, -50, 0, 0);
        }
        [_sendingStatusActivityIndicator setNeedsLayout];
//    }
}

- (void)layoutResendButton {
    
    DDLogInfo(@"%s, status: %@, content: %@", __PRETTY_FUNCTION__, self.messageModel.status, self.messageModel.content);
    
//    if ([self.messageModel isSend]) {
        if ([self.messageModel.status isKindOfClass:[NSString class]] &&
            [self.messageModel.status isEqualToString:BD_MESSAGE_STATUS_ERROR]) {
            
            _resendButton.frame = CGRectMake(_avatarImageView.frame.origin.x - self.messageModel.contentSize.width - self.messageModel.contentViewInsets.left - self.messageModel.contentViewInsets.right - 30,
                                             _avatarImageView.frame.origin.y,
                                             15, 15);
            
//            DDLogInfo(@"x: %f, y:%f, w: %f, h: %f",
//                      _resendButton.frame.origin.x, _resendButton.frame.origin.y,
//                      _resendButton.frame.size.width, _resendButton.frame.size.height);
        } else {
            _resendButton.frame = CGRectZero;
        }
        [_resendButton setNeedsLayout];
//    }
}

- (void)layoutAudioUnplayedIcon {
    
}

- (void)layoutReadLabel {
    
}

#pragma mark - UILongPressGestureRecognizer

- (void)longGesturePress:(UIGestureRecognizer*)gestureRecognizer
{
//    if (gestureRecognizer.state != UIGestureRecognizerStateBegan || ![self becomeFirstResponder]) {
//        return;
//    }

    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] &&
        gestureRecognizer.state == UIGestureRecognizerStateBegan) {
    
        DDLogInfo(@"%s", __PRETTY_FUNCTION__);
        
        [self becomeFirstResponder];//报错
        _bubbleView.highlighted = YES;
//        
////        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMenuWillShowNotification:) name:UIMenuControllerWillShowMenuNotification object:nil];
//
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setTargetRect:_bubbleView.frame inView:_bubbleView.superview];

        //添加你要自定义的MenuItem
        UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(mycopy:)];
        UIMenuItem *item2 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(mydelete:)];
        menu.menuItems = [NSArray arrayWithObjects:item,item2,nil];
        [menu setMenuVisible:YES animated:YES];
        
        if ([menu isMenuVisible]) {
            DDLogInfo(@"menu visible");
        }
        else {
            DDLogInfo(@"menu invisible");
        }
    }
}

#pragma mark - Notifications

- (void)handleMenuWillHideNotification:(NSNotification *)notification {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    _bubbleView.highlighted = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillHideMenuNotification object:nil];
}

- (void)handleMenuWillShowNotification:(NSNotification *)notification {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillShowMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMenuWillHideNotification:) name:UIMenuControllerWillHideMenuNotification object:nil];
}


- (void)handleAvatarClicked:(UIGestureRecognizer *)recognizer {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    if ([_delegate respondsToSelector:@selector(avatarClicked:)]) {
        [_delegate avatarClicked:_messageModel];
    }
}

#pragma mark - KFDSMsgBaseContentViewDelegate

// TODO: 点击客服/访客头像，显示其相关信息

// TODO: text点击超链接

// TODO: 长按复制、删除消息

// TODO: 打开放大图片
- (void) imageViewClicked:(UIImageView *)imageView {
//    DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, imageUrl);
    
    if ([_delegate respondsToSelector:@selector(imageViewClicked:)]) {
        [_delegate imageViewClicked:imageView];
    }
}

- (void)sendErrorStatusButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(sendErrorStatusButtonClicked:)]) {
        [self.delegate sendErrorStatusButtonClicked:_messageModel];
    }
}


@end












