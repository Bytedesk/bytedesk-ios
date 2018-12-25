//
//  KFUtils.m
//  kefu
//
//  Created by 萝卜丝 on 2017/11/28.
//  Copyright © 2017年 KeFuDaShi. All rights reserved.
//

#import "KFUtils.h"

@implementation KFUtils

+ (NSDate *)stringToDate:(NSString *)string {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter dateFromString:string];
}

+ (NSString *)getOptimizedTimestamp:(NSString *)dateString
{
    NSDate *date = [KFUtils stringToDate:dateString];
    // 1、设置时间 获取当前日期
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    
    [dateComponents setDay:dateComponents.day];
    NSDate *today = [calendar dateFromComponents:dateComponents];//今天
    
    [dateComponents setDay:dateComponents.day-1];
    NSDate *yesterday = [calendar dateFromComponents:dateComponents];//昨天
    
    [dateComponents setDay:dateComponents.day-1];
    NSDate *twoDaysAgo = [calendar dateFromComponents:dateComponents];//前天
    
    [dateComponents setDay:dateComponents.day-5];
    NSDate *lastWeek = [calendar dateFromComponents:dateComponents];//上星期
    
    //日期优化
    NSDate *lastMessageSentDate = date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *stringFromDate;
    
    if([lastMessageSentDate compare:today] == NSOrderedDescending)
    {
        [formatter setDateFormat:@"HH:mm:ss"];
        stringFromDate = [formatter stringFromDate:lastMessageSentDate];
    }
    else if ([lastMessageSentDate compare:yesterday] == NSOrderedDescending)
    {
        [formatter setDateFormat:@"HH:mm:ss"];
        stringFromDate = [formatter stringFromDate:lastMessageSentDate];
        
        stringFromDate = [NSString stringWithFormat:@"昨天 %@", stringFromDate];//NSLocalizedString(@"昨天", nil);
    }
    else if([lastMessageSentDate compare:twoDaysAgo] == NSOrderedDescending)
    {
        [formatter setDateFormat:@"HH:mm:ss"];
        stringFromDate = [formatter stringFromDate:lastMessageSentDate];
        
        stringFromDate = [NSString stringWithFormat:@"前天 %@", stringFromDate];//NSLocalizedString(@"前天", nil);
    }
    else if ([lastMessageSentDate compare:lastWeek] == NSOrderedDescending)
    {
        //[formatter setDateFormat:@"cccc HH:mm:ss"];//显示星期
        [formatter setDateFormat:@"MM-dd HH:mm"]; // yy-MM-dd HH:mm:ss
        stringFromDate = [formatter stringFromDate:lastMessageSentDate];
    }
    else
    {
        [formatter setDateFormat:@"MM-dd HH:mm"]; // yy-MM-dd HH:mm:ss
        stringFromDate = [formatter stringFromDate:lastMessageSentDate];
    }
    
    return stringFromDate;
}

@end
