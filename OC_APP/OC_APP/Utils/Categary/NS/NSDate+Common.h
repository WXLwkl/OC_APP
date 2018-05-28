//
//  NSDate+Common.h
//  OC_APP
//
//  Created by xingl on 2018/4/4.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Common)

/**
 获取 年、月、日、时、分、秒
 */
- (NSInteger)xl_year;
- (NSInteger)xl_month;
- (NSInteger)xl_day;
- (NSInteger)xl_hour;
- (NSInteger)xl_minute;
- (NSInteger)xl_second;
+ (NSInteger)xl_year:(NSDate *)date;
+ (NSInteger)xl_month:(NSDate *)date;
+ (NSInteger)xl_day:(NSDate *)date;
+ (NSInteger)xl_hour:(NSDate *)date;
+ (NSInteger)xl_minute:(NSDate *)date;
+ (NSInteger)xl_second:(NSDate *)date;

/** 获取一年中的总天数 */
- (NSInteger)xl_daysInYear;
+ (NSInteger)xl_daysInYear:(NSDate *)date;

/** 获取当前月份的天数 */
- (NSInteger)xl_daysInMonth;
+ (NSInteger)xl_daysInMonth:(NSDate *)date;

/** 获取指定月份的天数 */
- (NSInteger)xl_daysInMonth:(NSInteger)month;
+ (NSInteger)xl_daysInMonth:(NSDate *)date month:(NSInteger)month;

/** 判断是否为闰年 */
- (BOOL)xl_isLeapYear;
+ (BOOL)xl_isLeapYear:(NSDate *)date;

/** 日期是否相等 */
- (BOOL)xl_isSameDay:(NSDate *)anotherDate;

/** 是否是今天 */
- (BOOL)xl_isToday;
/** 是否是昨天 */
- (BOOL)xl_isYesterday;
/** 是否是今年 */
- (BOOL)xl_isThisYear;

/** 获取该日期是该年的第几周 */
- (NSInteger)xl_weekOfYear;
+ (NSInteger)xl_weekOfYear:(NSDate *)date;

/** 获取该月一共有几周(4、5、6) */
- (NSInteger)xl_weeksOfMonth;
+ (NSInteger)xl_weeksOfMonth:(NSDate *)date;

/** 获取该月第一天的日期 */
- (NSDate *)xl_firstdayOfMonth;
+ (NSDate *)xl_firstdayOfMonth:(NSDate *)date;

/** 获取该月最后一天的日期 */
- (NSDate *)xl_lastdayOfMonth;
+ (NSDate *)xl_lastdayOfMonth:(NSDate *)date;

/** 返回day天后的日期（如果day为负数，则是|day|天前的日期） */
- (NSDate *)xl_dateAfterDay:(NSUInteger)day;
+ (NSDate *)xl_dateAfterDate:(NSDate *)date day:(NSInteger)day;

/** 返回month月后的日期(若month为负数,则为|month|月前的日期) */
- (NSDate *)xl_dateAfterMonth:(NSUInteger)month;
+ (NSDate *)xl_dateAfterDate:(NSDate *)date month:(NSInteger)month;

/** 返回numYears年后的日期 */
- (NSDate *)xl_offsetYears:(NSInteger)numYears;
+ (NSDate *)xl_offsetYears:(NSInteger)numYears fromDate:(NSDate *)fromDate;

/** 返回numMonths月后的日期 */
- (NSDate *)xl_offsetMonths:(NSInteger)numMonths;
+ (NSDate *)xl_offsetMonths:(NSInteger)numMonths fromDate:(NSDate *)fromDate;

/** 返回numDays天后的日期 */
- (NSDate *)xl_offsetDays:(NSInteger)numDays;
+ (NSDate *)xl_offsetDays:(NSInteger)numDays fromDate:(NSDate *)fromDate;

/** 返回numHours小时后的日期 */
- (NSDate *)xl_offsetHours:(NSInteger)hours;
+ (NSDate *)xl_offsetHours:(NSInteger)numHours fromDate:(NSDate *)fromDate;

/** 距离该日期前几天 */
- (NSUInteger)xl_daysAgo;
+ (NSUInteger)xl_daysAgo:(NSDate *)date;

/** 获取星期几 */
- (NSInteger)xl_weekday;
+ (NSInteger)xl_weekday:(NSDate *)date;

/** 获取星期几(名称) */
- (NSString *)xl_dayFromWeekday;
+ (NSString *)xl_dayFromWeekDay:(NSDate *)date;

/** 增加 */
- (NSDate *)xl_dateByAddingDays:(NSUInteger)days;

/** 获取格式化为YYYY-MM-dd格式的日期字符串 */
- (NSString *)xl_formatYMD;
+ (NSString *)xl_formatYMD:(NSDate *)date;

/** 获取NSString的月份 */
+ (NSString *)xl_monthWithMonthNumber:(NSInteger)month;

/** 根据日期返回字符串 */
- (NSString *)xl_stringWithFormat:(NSString *)format;
+ (NSString *)xl_stringWithDate:(NSDate *)date format:(NSString *)format;

#pragma mark - 时间戳
- (NSTimeInterval)xl_timeInterval;
/** 根据时间的字符串及格式化方式返回date */
+ (NSDate *)xl_dateWithString:(NSString *)string format:(NSString *)format;
/** 根据时间戳获取date */
+ (NSDate *)xl_dateWithTimestamp:(NSTimeInterval)timestamp;
/** 获取当前的时间戳 */
+ (NSTimeInterval)currentTimeInterval;

#pragma mark - 时间差
/** 返回x分钟前/x小时前/昨天/x天前/x个月前/x年前 */
- (NSString *)timeInfo;
+ (NSString *)timeInfoWithDate:(NSDate *)date;
+ (NSString *)timeInfoWithDateString:(NSString *)dateString;

#pragma mark - 格式化
/** 分别获取yyyy-MM-dd/HH:mm:ss/yyyy-MM-dd HH:mm:ss格式的字符串 */
- (NSString *)ymdFormat;
- (NSString *)hmsFormat;
- (NSString *)ymdHmsFormat;
+ (NSString *)ymdFormat;
+ (NSString *)hmsFormat;
+ (NSString *)ymdHmsFormat;

@end
