//
//  KFDSMsgBaseContentView.m
//  feedback
//
//  Created by 萝卜丝 on 2018/2/18.
//  Copyright © 2018年 萝卜丝. All rights reserved.
//

#import "BDMsgBaseContentView.h"

@interface BDMsgBaseContentView ()

@end

@implementation BDMsgBaseContentView

//@synthesize sendingStatusIndicatorView, sendErrorStatusButton;

- (instancetype) initMessageContentView {
    //
    self.backgroundColor = [UIColor darkGrayColor];
    
    if (self = [self initWithFrame:CGRectZero]) {
//        self.backgroundColor = [UIColor redColor];
//        [self addTarget:self action:@selector(onTouchDown:) forControlEvents:UIControlEventTouchDown];
//        [self addTarget:self action:@selector(onTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
//        [self addTarget:self action:@selector(onTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        
        _bubbleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bubbleImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        _bubbleImageView.backgroundColor = [UIColor blueColor];
        [self addSubview:_bubbleImageView];
        
    }
    return self;
}

- (void)refresh:(BDMessageModel*)data{
    _model = data;
    
    [_bubbleImageView setImage:[self chatBubbleImageForState:UIControlStateNormal outgoing:[_model isSend]]];
    [_bubbleImageView setHighlightedImage:[self chatBubbleImageForState:UIControlStateHighlighted outgoing:[_model isSend]]];
    _bubbleImageView.frame = self.bounds;
    
//    if ([_model.status isEqualToString:BD_MESSAGE_STATUS_SENDING]) {
//
//        [self addSubview:[self sendingStatusIndicatorView]];
//    } else if ([_model.status isEqualToString:BD_MESSAGE_STATUS_ERROR]){
//
//        [self addSubview:[self sendErrorStatusButton]];
//    }
//
    [self setNeedsLayout];
}
//
//-(UIActivityIndicatorView *)kfSendingStatusIndicatorView
//{
//    if (!sendingStatusIndicatorView) {
//        sendingStatusIndicatorView = [[UIActivityIndicatorView alloc] init];
//        [sendingStatusIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
//    }
//    [sendingStatusIndicatorView startAnimating];
//
//    return sendingStatusIndicatorView;
//}
//
//-(UIButton *)kfSendErrorStatusButton
//{
//    if (!sendErrorStatusButton) {
//        sendErrorStatusButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
//        [sendErrorStatusButton setImage:[UIImage imageNamed:@"appkefu_error.png" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
//        [sendErrorStatusButton addTarget:self action:@selector(sendErrorStatusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    }
//
//    return sendErrorStatusButton;
//}

//
//- (void)sendErrorStatusButtonClicked:(id)sender {
//    if ([self.delegate respondsToSelector:@selector(sendErrorStatusButtonClicked:)]) {
//        [self.delegate sendErrorStatusButtonClicked:_model];
//    }
//}

//- (BOOL)canBecomeFirstResponder {
//    return YES;
//}

//
///**
// * 通过这个方法告诉UIMenuController它内部应该显示什么内容
// * 返回YES，就代表支持action这个操作
// */
//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
//{
//    DDLogInfo(@"%@", NSStringFromSelector(action));
//    if (action == @selector(cut:)
//        || action == @selector(copy:)
//        || action == @selector(paste:)) {
//        return YES; // YES ->  代表我们只监听 cut: / copy: / paste:方法
//    }
//    return NO; // 除了上面的操作，都不支持
//}

- (void)layoutSubviews {
    [super layoutSubviews];
}

//- (void)updateProgress:(float)progress {
//    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
//}
//
//- (void)onTouchDown:(id)sender {
//    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
//}
//
//- (void)onTouchUpInside:(id)sender {
//    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
//}
//
//- (void)onTouchUpOutside:(id)sender {
//    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
//}

#pragma mark - Private

- (UIImage *)chatBubbleImageForState:(UIControlState)state outgoing:(BOOL)outgoing{

    NSString *imageName = @"";
    if (outgoing) {
        if (state == UIControlStateNormal) {
            imageName = @"SenderTextNodeBkg";
        }
        else {
            imageName = @"SenderTextNodeBkgHL";
        }
    }
    else {
        if (state == UIControlStateNormal) {
            imageName = @"ReceiverTextNodeBkg";
        }
        else {
            imageName = @"ReceiverTextNodeBkgHL";
        }
    }
    
    return [[UIImage imageNamed:imageName inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] stretchableImageWithLeftCapWidth:50 topCapHeight:30];
}


//- (CGSize)bubbleViewSize {
//    CGSize bubbleSize;
//    CGSize contentSize  = _model.contentSize;
//    UIEdgeInsets insets = _model.contentViewInsets;
//    bubbleSize.width  = contentSize.width + insets.left + insets.right;
//    bubbleSize.height = contentSize.height + insets.top + insets.bottom;
//    return bubbleSize;
//}


- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    _bubbleImageView.highlighted = highlighted;
}



@end
