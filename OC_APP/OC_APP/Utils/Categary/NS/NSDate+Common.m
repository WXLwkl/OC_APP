//
//  NSDate+Common.m
//  OC_APP
//
//  Created by xingl on 2018/4/4.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "NSDate+Common.h"

@implementation NSDate (Common)

- (NSInteger)xl_day {
    return [NSDate xl_day:self];
}
- (NSInteger)xl_month {
    return [NSDate xl_minute:self];
}
- (NSInteger)xl_year {
    return [NSDate xl_year:self];
}
- (NSInteger)xl_hour {
    return [NSDate xl_hour:self];
}
- (NSInteger)xl_minute {
    return [NSDate xl_minute:self];
}
- (NSInteger)xl_second {
    return [NSDate xl_second:self];
}

+ (NSInteger)xl_day:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitDay) fromDate:date];
    return [dateComponents day];
}

+ (NSInteger)xl_month:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitMonth) fromDate:date];
    return [dateComponents month];
}

+ (NSInteger)xl_year:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitYear) fromDate:date];
    return [dateComponents year];
}

+ (NSInteger)xl_hour:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitHour) fromDate:date];
    return [dateComponents hour];
}
+ (NSInteger)xl_minute:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitMinute) fromDate:date];
    return [dateComponents minute];
}

+ (NSInteger)xl_second:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitSecond) fromDate:date];
    return [dateComponents second];
}

//- (NSInteger)xl_daysInYear {
//    NSCalendar *calender = [NSCalendar currentCalendar];
//    NSRange range = [calender rangeOfUnit:NSCalendarUnitDay
//                                   inUnit:NSCalendarUnitYear
//                                  forDate:self];
//    return range.length;
//}
//
//+ (NSInteger)xl_daysInYear:(NSDate *)date {
//    NSCalendar *calender = [NSCalendar currentCalendar];
//    NSRange range = [calender rangeOfUnit:NSCalendarUnitDay
//                                   inUnit: NSCalendarUnitYear
//                                  forDate: date];
//    return range.length;
//}

// 获取一年中的总天数
- (NSInteger)xl_daysInYear {
    return [NSDate xl_daysInYear:self];
}

+ (NSInteger)xl_daysInYear:(NSDate *)date {
    return [self xl_isLeapYear:date] ? 366 : 365;
}

// 获取当前月份的天数
- (NSInteger)xl_daysInMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return range.length;
}

+ (NSInteger)xl_daysInMonth:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}
// 获取指定月份的天数
- (NSInteger)xl_daysInMonth:(NSInteger)month {
    return [NSDate xl_daysInMonth:self month:month];
}
+ (NSInteger)xl_daysInMonth:(NSDate *)date month:(NSInteger)month {
    switch (month) {
        case 1: case 3: case 5: case 7: case 8: case 10: case 12:
            return 31;
        case 2:
            return [date xl_isLeapYear] ? 29 : 28;
    }
    return 30;
}

// 是否为闰年
- (BOOL)xl_isLeapYear {
    return [NSDate xl_isLeapYear:self];
}

+ (BOOL)xl_isLeapYear:(NSDate *)date {
    NSInteger year = [date xl_year];
    if ((year % 4  == 0 && year % 100 != 0) || year % 400 == 0) {
        return YES;
    }
    return NO;
}

// 日期是否相等
- (BOOL)xl_isSameDay:(NSDate *)anotherDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components1 = [calendar components:(NSCalendarUnitYear
                                                          | NSCalendarUnitMonth
                                                          | NSCalendarUnitDay)
                                                fromDate:self];
    NSDateComponents *components2 = [calendar components:(NSCalendarUnitYear
                                                          | NSCalendarUnitMonth
                                                          | NSCalendarUnitDay)
                                                fromDate:anotherDate];
    return ([components1 year] == [components2 year]
            && [components1 month] == [components2 month]
            && [components1 day] == [components2 day]);
}

// 是否为今天
- (BOOL)xl_isToday {
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    return [calendar isDateInToday:[NSDate date]];
    return [self xl_isSameDay:[NSDate date]];
}

- (BOOL)xl_isYesterday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar isDateInYesterday:self];
}

- (BOOL)xl_isThisYear {
    // 获取当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 获取调用者的日期年份
    NSDate *createDate = self;
    NSDateComponents *createCmp = [calendar components:NSCalendarUnitYear fromDate:createDate];
    // 获取当前时间
    NSDate *curDate = [NSDate date];
    // 获取当前时间的日期年份
    NSDateComponents *curCmp = [calendar components:NSCalendarUnitYear fromDate:curDate];
    
    return createCmp.year == curCmp.year;
}

// 获取该日期是该年的第几周
- (NSInteger)xl_weekOfYear {
    return [NSDate xl_weekOfYear:self];
}

+ (NSInteger)xl_weekOfYear:(NSDate *)date {
    NSUInteger i;
    NSUInteger year = [date xl_year];

    NSDate *lastdate = [date xl_lastdayOfMonth];

    for (i = 1;[[lastdate xl_dateAfterDay:-7 * i] xl_year] == year; i++) {

    }

    return i;
}

// 获取该月一共有几周(4、5、6)
- (NSInteger)xl_weeksOfMonth {
    return [NSDate xl_weeksOfMonth:self];
}

+ (NSInteger)xl_weeksOfMonth:(NSDate *)date {
    return [[date xl_lastdayOfMonth] xl_weekOfYear] - [[date xl_firstdayOfMonth] xl_weekOfYear] + 1;
}

// 获取该月第一天的日期
- (NSDate *)xl_firstdayOfMonth {
    return [NSDate xl_firstdayOfMonth:self];
}

+ (NSDate *)xl_firstdayOfMonth:(NSDate *)date {
    return [self xl_dateAfterDate:date day:-[date xl_day]+1];
}

// 获取该月最后一天的日期
- (NSDate *)xl_lastdayOfMonth {
    return [NSDate xl_lastdayOfMonth:self];
}

+ (NSDate *)xl_lastdayOfMonth:(NSDate *)date {
    NSDate *lastDate = [self xl_firstdayOfMonth:date];
    return [[lastDate xl_dateAfterMonth:1] xl_dateAfterDay:-1];
}

// 返回day天后的日期（如果day为负数，则是|day|天前的日期）
- (NSDate *)xl_dateAfterDay:(NSUInteger)day {
    return [NSDate xl_dateAfterDate:self day:day];
}

+ (NSDate *)xl_dateAfterDate:(NSDate *)date day:(NSInteger)day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setDay:day];
    NSDate *dateAfterDay = [calendar dateByAddingComponents:componentsToAdd toDate:date options:0];
    
    return dateAfterDay;
}

// 返回day月后的日期(若month为负数,则为|month|月前的日期)
- (NSDate *)xl_dateAfterMonth:(NSUInteger)month {
    return [NSDate xl_dateAfterDate:self month:month];
}
+ (NSDate *)xl_dateAfterDate:(NSDate *)date month:(NSInteger)month {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setMonth:month];
    NSDate *dateAfterMonth = [calendar dateByAddingComponents:componentsToAdd toDate:date options:0];
    
    return dateAfterMonth;
}

// 返回numYears年后的日期
- (NSDate *)xl_offsetYears:(NSInteger)numYears {
    return [NSDate xl_offsetYears:numYears fromDate:self];
}
+ (NSDate *)xl_offsetYears:(NSInteger)numYears fromDate:(NSDate *)fromDate {
    if (fromDate == nil) return nil;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComps = [[NSDateComponents alloc] init];
    offsetComps.year = numYears;
    return [gregorian dateByAddingComponents:offsetComps toDate:fromDate options:0];
}

// 返回numMonths月后的日期
- (NSDate *)xl_offsetMonths:(NSInteger)numMonths {
    return [NSDate xl_offsetMonths:numMonths fromDate:self];
}
+ (NSDate *)xl_offsetMonths:(NSInteger)numMonths fromDate:(NSDate *)fromDate {
    if (fromDate == nil) return nil;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComps = [[NSDateComponents alloc] init];
    offsetComps.month = numMonths;
    return [gregorian dateByAddingComponents:offsetComps toDate:fromDate options:0];
}

// 返回numDays天后的日期
- (NSDate *)xl_offsetDays:(NSInteger)numDays {
    return [NSDate xl_offsetDays:numDays fromDate:self];
}
+ (NSDate *)xl_offsetDays:(NSInteger)numDays fromDate:(NSDate *)fromDate {
    if (fromDate == nil) return nil;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComps = [[NSDateComponents alloc] init];
    offsetComps.day = numDays;
    return [gregorian dateByAddingComponents:offsetComps toDate:fromDate options:0];
}

// 返回numHours小时后的日期
- (NSDate *)xl_offsetHours:(NSInteger)hours {
    return [NSDate xl_offsetHours:hours fromDate:self];
}
+ (NSDate *)xl_offsetHours:(NSInteger)numHours fromDate:(NSDate *)fromDate {
    if (fromDate == nil) return nil;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComps = [[NSDateComponents alloc] init];
    offsetComps.hour = numHours;
    return [gregorian dateByAddingComponents:offsetComps toDate:fromDate options:0];
}

// 距离该日期前几天
- (NSUInteger)xl_daysAgo {
    return [NSDate xl_daysAgo:self];
}
+ (NSUInteger)xl_daysAgo:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:(NSCalendarUnitDay) fromDate:date toDate:[NSDate date] options:0];
    return [comps day];
}

// 获取星期几
- (NSInteger)xl_weekday {
    return [NSDate xl_weekday:self];
}
+ (NSInteger)xl_weekday:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:date];
    NSInteger weekday = [comps weekday];
    return weekday;
}

// 获取星期几(名称)
- (NSString *)xl_dayFromWeekday {
    return [NSDate xl_dayFromWeekDay:self];
}
+ (NSString *)xl_dayFromWeekDay:(NSDate *)date {
    switch([date xl_weekday]) {
        case 1:
            return @"星期天";
        case 2:
            return @"星期一";
        case 3:
            return @"星期二";
        case 4:
            return @"星期三";
        case 5:
            return @"星期四";
        case 6:
            return @"星期五";
        case 7:
            return @"星期六";
        default:
            break;
    }
    return @"";
}
// 增加
- (NSDate *)xl_dateByAddingDays:(NSUInteger)days {
    
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.day = days;
    return [[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0];
}

// 获取格式化为YYYY-MM-dd格式的日期字符串
- (NSString *)xl_formatYMD {
    return [NSDate xl_formatYMD:self];
}
+ (NSString *)xl_formatYMD:(NSDate *)date {
    return [NSString stringWithFormat:@"%lu-%02lu-%02lu", [date xl_year], [date xl_month], [date xl_day]];
}

// 获取NSString的月份
+ (NSString *)xl_monthWithMonthNumber:(NSInteger)month {
    switch(month) {
        case 1:
            return @"January";
        case 2:
            return @"February";
        case 3:
            return @"March";
        case 4:
            return @"April";
        case 5:
            return @"May";
        case 6:
            return @"June";
        case 7:
            return @"July";
        case 8:
            return @"August";
        case 9:
            return @"September";
        case 10:
            return @"October";
        case 11:
            return @"November";
        case 12:
            return @"December";
        default:
            break;
    }
    return @"";
}
// 根据日期返回字符串
- (NSString *)xl_stringWithFormat:(NSString *)format {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:format];
    NSString *retStr = [outputFormatter stringFromDate:self];
    return retStr;
}
+ (NSString *)xl_stringWithDate:(NSDate *)date format:(NSString *)format {
    return [date xl_stringWithFormat:format];
}
#pragma mark - 时间戳
- (NSTimeInterval)xl_timeInterval {
    NSTimeInterval time = [self timeIntervalSince1970] * 1000; // *1000 是精确到毫秒，不乘就是精确到秒
    return time;
}

+ (NSDate *)xl_dateWithString:(NSString *)string format:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    NSDate *date = [inputFormatter dateFromString:string];
    return date;
}

// 根据时间戳获取date
+ (NSDate *)xl_dateWithTimestamp:(NSTimeInterval)timestamp {
    if ([NSString stringWithFormat:@"%@", @(timestamp)].length == 13) {
        timestamp /= 1000.0f;
    }
    NSDate *timestampDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    return timestampDate;
}
// 获取当前的时间戳
+ (NSTimeInterval)currentTimeInterval {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    return time;
}

- (NSString *)timeInfo {
    return [NSDate timeInfoWithDate:self];
}
+ (NSString *)timeInfoWithDate:(NSDate *)date {
    return [self timeInfoWithDateString:[self xl_stringWithDate:date format:[self ymdHmsFormat]]];
}
+ (NSString *)timeInfoWithDateString:(NSString *)dateString {
    NSDate *date = [self xl_dateWithString:dateString format:[self ymdHmsFormat]];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *deltaTime = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:date toDate:[NSDate date] options:NSCalendarWrapComponents];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if([date xl_isThisYear]) {   // 今年
        if([date xl_isToday]){   // 今天
            if(deltaTime.hour >= 1) {   // 时间差大于等于1小时
                return [NSString stringWithFormat:@"%ld小时前",(long)deltaTime.hour];
            }else if (deltaTime.minute >= 1){   // 时间差大于等于1分钟
                return [NSString stringWithFormat:@"%ld分钟前",(long)deltaTime.minute];
            }else {
                // 小于1分钟
                return @"刚刚";
            }
        }else if([date xl_isYesterday]){
            dateFormatter.dateFormat = @"昨天 HH:mm";
            return [dateFormatter stringFromDate:date];
        }else {
            // 昨天之前
            dateFormatter.dateFormat = @"MM-dd HH:mm:ss";
            return [dateFormatter stringFromDate:date];
        }
    }else { // 非今年
        return dateString;
    }
}

- (NSString *)ymdFormat {
    return [NSDate ymdFormat];
}

- (NSString *)hmsFormat {
    return [NSDate hmsFormat];
}

- (NSString *)ymdHmsFormat {
    return [NSDate ymdHmsFormat];
}

+ (NSString *)ymdFormat {
    return @"yyyy-MM-dd";
}

+ (NSString *)hmsFormat {
    return @"HH:mm:ss";
}

+ (NSString *)ymdHmsFormat {
    return [NSString stringWithFormat:@"%@ %@", [self ymdFormat], [self hmsFormat]];
}


@end
