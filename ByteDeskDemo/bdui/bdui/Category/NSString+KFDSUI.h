//
//  NSString+FeedBack.h
//  feedback
//
//  Created by 萝卜丝·Bytedesk.com on 2017/2/18.
//  Copyright © 2017年 萝卜丝·Bytedesk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (FeedBack)

- (CGSize)fb_stringSizeWithFont:(UIFont *)font;

- (NSString *)fb_MD5String;

- (NSUInteger)fb_getBytesLength;

- (NSString *)fb_stringByDeletingPictureResolution;

- (UIColor *)fb_hexToColor;

@end
