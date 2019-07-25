//
//  NSString+FeedBack.h
//  feedback
//
//  Created by 萝卜丝 on 2018/2/18.
//  Copyright © 2018年 萝卜丝. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (FeedBack)

- (CGSize)fb_stringSizeWithFont:(UIFont *)font;

- (NSString *)fb_MD5String;

- (NSUInteger)fb_getBytesLength;

- (NSString *)fb_stringByDeletingPictureResolution;

- (UIColor *)fb_hexToColor;

@end
