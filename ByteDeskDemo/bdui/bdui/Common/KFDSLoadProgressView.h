//
//  FBLoadProgressView.h
//  feedback
//
//  Created by 萝卜丝 · bytedesk.com on 2018/2/24.
//  Copyright © 2018年 萝卜丝 · bytedesk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KFDSLoadProgressView : UIView {
    UIImageView             *_maskView;
    UILabel                 *_progressLabel;
    UIActivityIndicatorView *_activity;
}

@property (nonatomic, assign)CGFloat maxProgress;

- (void)setProgress:(CGFloat)progress;

@end
