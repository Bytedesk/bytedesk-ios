//
//  KFDSMsgTextContentView.m
//  feedback
//
//  Created by 萝卜丝 on 2018/2/18.
//  Copyright © 2018年 萝卜丝. All rights reserved.
//

#import "BDMsgTextContentView.h"
//#import "KFDSMessageModel.h"
#import "KFDSUConstants.h"

#import <M80AttributedLabel/M80AttributedLabel.h>
#import "M80AttributedLabel+KFDSUI.h"

#import "KFDSInputEmotionManager.h"
#import "KFDSInputEmotionParser.h"

#import <bytedesk-core/bdcore.h>

@interface BDMsgTextContentView()<M80AttributedLabelDelegate>

@end

@implementation BDMsgTextContentView

- (instancetype)initMessageContentView {
    //
    if (self = [super initMessageContentView]) {
        //
        _textLabel = [[M80AttributedLabel alloc] initWithFrame:CGRectZero];
        _textLabel.delegate = self;
        _textLabel.underLineForLink = YES;
//        _textLabel.numberOfLines = 0;
//        _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.font = [UIFont systemFontOfSize:12.0f];
        //
        [self addSubview:_textLabel];
    }
    //
    return self;
}

//- (BOOL)canBecomeFirstResponder {
//    return YES;
//}

- (void)refresh:(BDMessageModel *)data {
    [super refresh:data];
//    DDLogInfo(@"%s, type: %@, content: %@", __PRETTY_FUNCTION__, self.model.type, self.model.content);

    NSString *text = self.model.content;
    // FIXME: 放在bdui_setText函数中表情无法显示，暂时复制代码到此处，bug未知？？
//   [_textLabel bdui_setText:text];
    
    [_textLabel setText:@""];
    NSArray *tokens = [[KFDSInputEmotionParser currentParser] tokens:text];
    for (KFDSInputTextToken *token in tokens) {
        if (token.type == KFDSInputTokenTypeEmoticon) {
            KFDSInputEmotion *emoticon = [[KFDSInputEmotionManager sharedManager] emotionByText:token.text];
            if (emoticon) {
                UIImage *image = [UIImage imageNamed:emoticon.filename inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
                if (image) {
                    [_textLabel appendImage:image
                              maxSize:CGSizeMake(18, 18)
                               margin:UIEdgeInsetsZero
                            alignment:M80ImageAlignmentCenter];
                }
                else {
                    NSString *text = token.text;
                    [_textLabel appendText:text];
                }
            }
        }
        else {
            NSString *text = token.text;
            [_textLabel appendText:text];
        }
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
   
    UIEdgeInsets contentInsets = self.model.contentViewInsets;
    CGSize size = [_textLabel sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)];
    self.model.contentSize = size;

    CGRect labelFrame = CGRectZero;
    CGRect bubbleFrame = CGRectZero;
    CGRect boundsFrame = CGRectZero;

    if ([self.model isSend]) {
        labelFrame = CGRectMake(contentInsets.left+2, contentInsets.top, size.width, size.height);
        bubbleFrame = CGRectMake(0, 0, contentInsets.left + size.width + contentInsets.right + 5, contentInsets.top + size.height + contentInsets.bottom );
        boundsFrame = CGRectMake(KFDSScreen.width - bubbleFrame.size.width - 55, 23, bubbleFrame.size.width,  bubbleFrame.size.height);
    }
    else {
        labelFrame = CGRectMake(contentInsets.left+3, contentInsets.top, size.width, size.height);
        bubbleFrame = CGRectMake(0, 0, contentInsets.left + size.width + contentInsets.right + 5, contentInsets.top + size.height + contentInsets.bottom );
        boundsFrame = CGRectMake(50, 40, bubbleFrame.size.width, bubbleFrame.size.height);
    }
    self.frame = boundsFrame;
    //
    self.textLabel.frame = labelFrame;
    self.bubbleImageView.frame = bubbleFrame;
    self.model.contentSize = boundsFrame.size;
}

#pragma mark - M80AttributedLabelDelegate

// FIXME: 没有调用？
- (void)m80AttributedLabel:(M80AttributedLabel *)label clickedOnLink:(id)linkData {
    //
    NSString *url = [NSString stringWithFormat:@"%@", linkData];
    DDLogInfo(@"%s url:%@", __PRETTY_FUNCTION__, url);
    //
    if ([self.delegate respondsToSelector:@selector(linkUrlClicked:)]) {
        [self.delegate linkUrlClicked:url];
    }
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    DDLogInfo(@"touch text view %s", __PRETTY_FUNCTION__);
//}

@end
