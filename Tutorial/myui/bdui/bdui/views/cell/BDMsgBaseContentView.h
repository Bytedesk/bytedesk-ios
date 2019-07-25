//
//  KFDSMsgBaseContentView.h
//  feedback
//
//  Created by 萝卜丝 on 2018/2/18.
//  Copyright © 2018年 萝卜丝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <bytedesk-core/bdcore.h>


@protocol KFDSMsgBaseContentViewDelegate <NSObject>

// TODO: 点击客服/访客头像，显示其相关信息
//- (void)avatarClicked:(BDMessageModel *)messageModel;

// TODO: text点击超链接
- (void) linkUrlClicked:(NSString *)url;

// TODO: 打开放大图片
- (void) imageViewClicked:(UIImageView *)imageView;

// TODO: 点击文件消息
- (void) fileViewClicked:(NSString *)fileUrl;

// 机器人问答
- (void) robotLinkClicked:(NSString *)label withKey:(NSString *)key;

@end


@interface BDMsgBaseContentView : UIControl

@property (nonatomic, strong, readonly)  BDMessageModel   *model;

@property (nonatomic, strong) UIImageView * bubbleImageView;

//@property (nonatomic, strong) UIActivityIndicatorView   *sendingStatusIndicatorView;
//@property (nonatomic, strong) UIButton                  *sendErrorStatusButton;

@property (nonatomic, weak) id<KFDSMsgBaseContentViewDelegate> delegate;

/**
 *  contentView初始化方法
 *
 *  @return content实例
 */
- (instancetype)initMessageContentView;

/**
 *  刷新方法
 *
 *  @param data 刷新数据
 */
- (void)refresh:(BDMessageModel*)data;


///**
// *  手指从contentView内部抬起
// */
//- (void)onTouchUpInside:(id)sender;
//
//
///**
// *  手指从contentView外部抬起
// */
//- (void)onTouchUpOutside:(id)sender;
//
///**
// *  手指按下contentView
// */
//- (void)onTouchDown:(id)sender;

/**
 *  聊天气泡图
 *
 *  @param state    目前的按压状态
 *  @param outgoing 是否是发出去的消息
 *
 */
- (UIImage *)chatBubbleImageForState:(UIControlState)state outgoing:(BOOL)outgoing;


@end






