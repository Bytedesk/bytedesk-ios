//
//  UIView+FeedBack.h
//  feedback
//
//  Created by 萝卜丝 on 2017/2/18.
//  Copyright © 2017年 萝卜丝. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FeedBack)

@property (nonatomic) CGFloat fb_left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat fb_top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat fb_right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat fb_bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat fb_width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat fb_height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat fb_centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat fb_centerY;
/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint fb_origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize fb_size;

//找到自己的vc
- (UIViewController *)fb_viewController;

@end
