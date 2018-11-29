//
//  FBBadgeView.h
//  feedback
//
//  Created by 萝卜丝 · bytedesk.com on 2018/2/18.
//  Copyright © 2018年 萝卜丝 · bytedesk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KFDSBadgeView : UIView

@property (nonatomic, copy) NSString *badgeValue;

+ (instancetype)viewWithBadgeTip:(NSString *)badgeValue;

@end
 
