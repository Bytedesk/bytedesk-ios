//
//  KFDSCUtils.h
//  bdcore
//
//  Created by 萝卜丝 on 2018/11/23.
//  Copyright © 2018年 Bytedesk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDUtils : NSObject

+(NSString *)getCurrentDate;

+ (NSDate *)stringToDate:(NSString *)string;

+ (NSString *) getOptimizedTimestamp:(NSString *)date;

+ (NSString *)getCurrentTimeString;

+ (NSString *)deviceVersion;

+ (NSString *)dictToJson:(NSDictionary *)dict;

+ (NSString *)getQRCodeLogin;

+ (NSString *)getQRCodeUser:(NSString *)uid;

+ (NSString *)getQRCodeGroup:(NSString *)gid;

@end
