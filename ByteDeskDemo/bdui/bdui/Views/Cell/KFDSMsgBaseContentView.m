//
//  KFDSMsgBaseContentView.m
//  feedback
//
//  Created by 萝卜丝 on 2018/2/18.
//  Copyright © 2018年 萝卜丝. All rights reserved.
//

#import "KFDSMsgBaseContentView.h"

@interface KFDSMsgBaseContentView ()

@end

@implementation KFDSMsgBaseContentView


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
    
    [self setNeedsLayout];
}

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
//    NSLog(@"%@", NSStringFromSelector(action));
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
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//}
//
//- (void)onTouchDown:(id)sender {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//}
//
//- (void)onTouchUpInside:(id)sender {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//}
//
//- (void)onTouchUpOutside:(id)sender {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
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


- (CGSize)bubbleViewSize:(BDMessageModel *)model {
    CGSize bubbleSize;
    CGSize contentSize  = model.contentSize;
    UIEdgeInsets insets = model.contentViewInsets;
    bubbleSize.width  = contentSize.width + insets.left + insets.right;
    bubbleSize.height = contentSize.height + insets.top + insets.bottom;
    return bubbleSize;
}


- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    _bubbleImageView.highlighted = highlighted;
}



@end
