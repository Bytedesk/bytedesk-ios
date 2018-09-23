//
//  FBBadgeView.h
//  feedback
//
//  Created by 萝卜丝·Bytedesk.com on 2017/2/18.
//  Copyright © 2017年 萝卜丝·Bytedesk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KFDSBadgeView : UIView

@property (nonatomic, copy) NSString *badgeValue;

+ (instancetype)viewWithBadgeTip:(NSString *)badgeValue;

@end
 
