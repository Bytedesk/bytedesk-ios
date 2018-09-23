//
//  FBLoadProgressView.h
//  feedback
//
//  Created by 萝卜丝·Bytedesk.com on 2017/2/24.
//  Copyright © 2017年 萝卜丝·Bytedesk.com. All rights reserved.
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
