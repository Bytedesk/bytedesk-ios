//
//  KFUtils.h
//  kefu
//
//  Created by 萝卜丝 on 2017/11/28.
//  Copyright © 2017年 KeFuDaShi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KFUtils : NSObject

//
+ (NSDate *)stringToDate:(NSString *)string;

+ (NSString *) getOptimizedTimestamp:(NSString *)date;

@end
