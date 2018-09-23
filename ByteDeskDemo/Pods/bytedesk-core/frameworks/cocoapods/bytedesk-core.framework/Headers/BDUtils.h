//
//  KFDSCUtils.h
//  bdcore
//
//  Created by 宁金鹏 on 2017/11/23.
//  Copyright © 2017年 Bytedesk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDUtils : NSObject

+(NSString *)getCurrentDate;
//
+ (NSDate *)stringToDate:(NSString *)string;

+ (NSString *) getOptimizedTimestamp:(NSString *)date;

+ (NSString *)getCurrentTimeString;

+ (NSString*)deviceVersion;

@end
