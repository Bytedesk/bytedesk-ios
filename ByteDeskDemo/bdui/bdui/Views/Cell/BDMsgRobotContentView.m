//
//  BDMsgRobotContentView.m
//  bytedesk-ui
//
//  Created by 宁金鹏 on 2019/6/14.
//  Copyright © 2019 KeFuDaShi. All rights reserved.
//

#import "BDMsgRobotContentView.h"

#import "KFDSUConstants.h"
#import "KFUIUtils.h"

#import "KFCoreTextView.h"
#import <bytedesk-core/bdcore.h>

@interface BDMsgRobotContentView()<KFCoreTextViewDelegate>

@end

@implementation BDMsgRobotContentView

- (instancetype)initMessageContentView {
    //
    if (self = [super initMessageContentView]) {
        //
        _kfCoreTextView = [[KFCoreTextView alloc] initWithFrame:CGRectZero];
        [_kfCoreTextView setDelegate:self];
        _kfCoreTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _kfCoreTextView.userInteractionEnabled = YES;
        //
        [self addSubview:_kfCoreTextView];
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
    
    [_kfCoreTextView setText:self.model.content];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    
    CGSize size = [KFUIUtils sizeOfRobotContent:self.model.content];
    UIEdgeInsets contentInsets = self.model.contentViewInsets;
    self.model.contentSize = size;
    
    CGRect labelFrame = CGRectZero;
    CGRect bubbleFrame = CGRectZero;
    CGRect boundsFrame = CGRectZero;
    
    if ([self.model isSend]) {
        labelFrame = CGRectMake(contentInsets.left+2, contentInsets.top, size.width, size.height);
        bubbleFrame = CGRectMake(0, 0, contentInsets.left + size.width + contentInsets.right + 5, contentInsets.top + size.height + contentInsets.bottom );
        boundsFrame = CGRectMake(KFDSScreen.width - bubbleFrame.size.width - 55, 23, bubbleFrame.size.width,  bubbleFrame.size.height);
        
        _kfCoreTextView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    }
    else {
        labelFrame = CGRectMake(contentInsets.left+3, contentInsets.top, size.width, size.height);
        bubbleFrame = CGRectMake(0, 0, contentInsets.left + size.width + contentInsets.right + 5, contentInsets.top + size.height + contentInsets.bottom + 5 );
        boundsFrame = CGRectMake(50, 40, bubbleFrame.size.width, bubbleFrame.size.height);
        
        _kfCoreTextView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    }
    self.frame = boundsFrame;
    
    //
//    DDLogInfo(@"labelFrame: x=%f, y=%f, height=%f, width=%f", labelFrame.origin.x, labelFrame.origin.y, labelFrame.size.height, labelFrame.size.width);
    self.kfCoreTextView.frame = labelFrame;
    [_kfCoreTextView fitToSuggestedHeight];
    //
    self.bubbleImageView.frame = bubbleFrame;
    self.model.contentSize = boundsFrame.size;
}

#pragma mark - KFCoreTextViewDelegate

- (void)coreTextView:(KFCoreTextView *)coreTextView receivedTouchOnData:(NSDictionary *)dict {
    // 注意：赋值是故意的，没有错乱
    NSString *label = [dict objectForKey:@"key"];
    NSURL *keyUrl = [dict objectForKey:@"url"];
    NSString *key = [keyUrl absoluteString];
//    DDLogInfo(@"kfcoretext receivedTouchOnData: %@, key: %@, url: %@", dict, label, key);
    
    if ([self.delegate respondsToSelector:@selector(robotLinkClicked:withKey:)]) {
        [self.delegate robotLinkClicked:label withKey:key];
    }
}


@end
