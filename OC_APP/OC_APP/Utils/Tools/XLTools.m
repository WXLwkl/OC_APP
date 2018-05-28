//
//  XLTools.m
//  OC_APP
//
//  Created by xingl on 2018/4/3.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "XLTools.h"

@implementation XLTools

//获取文件大小
+ (long long)fileSizeAtPath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath])
        return 0;
    return [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
}

//获取文件夹下所有文件的大小
+ (long long)folderSizeAtPath:(NSString *)folderPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *filesEnumerator = [[fileManager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName;
    long long folerSize = 0;
    while ((fileName = [filesEnumerator nextObject]) != nil) {
        NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
        folerSize += [self fileSizeAtPath:filePath];
    }
    return folerSize;
}

//将字符串数组按照元素首字母顺序进行排序分组
+ (NSDictionary *)dictionaryOrderByCharacterWithOriginalArray:(NSArray *)array {
    if (array.count == 0) {
        return nil;
    }
    for (id obj in array) {
        if (![obj isKindOfClass:[NSString class]]) {
            return nil;
        }
    }
    UILocalizedIndexedCollation *indexedCollation = [UILocalizedIndexedCollation currentCollation];
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:indexedCollation.sectionTitles.count];
    //创建27个分组数组
    for (int i = 0; i < indexedCollation.sectionTitles.count; i++) {
        NSMutableArray *obj = [NSMutableArray array];
        [objects addObject:obj];
    }
    NSMutableArray *keys = [NSMutableArray arrayWithCapacity:objects.count];
    //按字母顺序进行分组
    NSInteger lastIndex = -1;
    for (int i = 0; i < array.count; i++) {
        NSInteger index = [indexedCollation sectionForObject:array[i] collationStringSelector:@selector(uppercaseString)];
        [[objects objectAtIndex:index] addObject:array[i]];
        lastIndex = index;
    }
    //去掉空数组
    for (int i = 0; i < objects.count; i++) {
        NSMutableArray *obj = objects[i];
        if (obj.count == 0) {
            [objects removeObject:obj];
        }
    }
    //获取索引字母
    for (NSMutableArray *obj in objects) {
        NSString *str = obj[0];
        NSString *key = [self firstCharacterWithString:str];
        [keys addObject:key];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:objects forKey:keys];
    return dic;
}

//获取字符串(或汉字)首字母
+ (NSString *)firstCharacterWithString:(NSString *)string {
    NSMutableString *str = [NSMutableString stringWithString:string];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pingyin = [str capitalizedString];
    return [pingyin substringToIndex:1];
}

#pragma mark - 时间

/**
 *  计算上次日期距离现在多久
 *
 *  @param lastTime    上次日期(需要和格式对应)
 *  @param format1     上次日期格式
 *  @param currentTime 最近日期(需要和格式对应)
 *  @param format2     最近日期格式
 *
 *  @return xx分钟前、xx小时前、xx天前
 */
+ (NSString *)timeIntervalFromLastTime:(NSString *)lastTime
                        lastTimeFormat:(NSString *)format1
                         ToCurrentTime:(NSString *)currentTime
                     currentTimeFormat:(NSString *)format2 {
    //上次时间
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
    dateFormatter1.dateFormat = format1;
    NSDate *lastDate = [dateFormatter1 dateFromString:lastTime];
    //当前时间
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
    dateFormatter2.dateFormat = format2;
    NSDate *currentDate = [dateFormatter2 dateFromString:currentTime];
    return [XLTools timeIntervalFromLastTime:lastDate ToCurrentTime:currentDate];
}
/**
 *  计算上次日期距离现在多久
 *
 *  @param lastTime    上次日期(需要和格式对应)
 *  @param format1     上次日期格式
 *
 *  @return xx分钟前、xx小时前、xx天前
 */
+ (NSString *)timeIntervalFromLastTime:(NSString *)lastTime
                        lastTimeFormat:(NSString *)format1 {
    //上次时间
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
    dateFormatter1.dateFormat = format1;
    NSDate *lastDate = [dateFormatter1 dateFromString:lastTime];
    //当前时间
    NSDate *currentDate = [NSDate date];
    return [XLTools timeIntervalFromLastTime:lastDate ToCurrentTime:currentDate];
}

+ (NSString *)timeIntervalFromLastTime:(NSDate *)lastTime ToCurrentTime:(NSDate *)currentTime{
   
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    //上次时间
    NSDate *lastDate = [lastTime dateByAddingTimeInterval:[timeZone secondsFromGMTForDate:lastTime]];
    //当前时间
    NSDate *currentDate = [currentTime dateByAddingTimeInterval:[timeZone secondsFromGMTForDate:currentTime]];
    //时间间隔
    NSInteger intevalTime = [currentDate timeIntervalSinceReferenceDate] - [lastDate timeIntervalSinceReferenceDate];
    
    //秒、分、小时、天、月、年
    NSInteger minutes = intevalTime / 60;
    NSInteger hours = intevalTime / 60 / 60;
    NSInteger day = intevalTime / 60 / 60 / 24;
    NSInteger month = intevalTime / 60 / 60 / 24 / 30;
    NSInteger yers = intevalTime / 60 / 60 / 24 / 365;
    
    if (minutes < 1) {
        return  @"刚刚";
    }else if (minutes < 60){
        return [NSString stringWithFormat: @"%ld分钟前",(long)minutes];
    }else if (hours < 24){
        return [NSString stringWithFormat: @"%ld小时前",(long)hours];
    }else if (day < 30){
        return [NSString stringWithFormat: @"%ld天前",(long)day];
    }else if (month < 12){
        NSDateFormatter * df =[[NSDateFormatter alloc]init];
        df.dateFormat = @"M月d日";
        NSString * time = [df stringFromDate:lastDate];
        return time;
    }else if (yers >= 1){
        NSDateFormatter * df =[[NSDateFormatter alloc]init];
        df.dateFormat = @"yyyy年M月d日";
        NSString * time = [df stringFromDate:lastDate];
        return time;
    }
    return @"";
}
#pragma mark - ----------------
- (NSDate *)serverCreateDate:(NSString *)serverTime timeFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = format;
    NSDate *date = [dateFormatter dateFromString:serverTime];
    return date;
}
- (BOOL)isThisYear:(NSDate *)date {
    
    // 获取当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 获取调用者的日期年份
    NSDate *createDate = date;
    NSDateComponents *createCmp = [calendar components:NSCalendarUnitYear fromDate:createDate];
    // 获取当前时间
    NSDate *curDate = [NSDate date];
    // 获取当前时间的日期年份
    NSDateComponents *curCmp = [calendar components:NSCalendarUnitYear fromDate:curDate];
    
    return createCmp.year == curCmp.year;
}

- (BOOL)isThisToday:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar isDateInToday:date];
}

- (BOOL)isThisYesterday:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar isDateInYesterday:date];
}

- (NSDateComponents *)deltaWithNow:(NSString *)serverTime timeFormat:(NSString *)format {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *createDate = [self serverCreateDate:serverTime timeFormat:format];
    return [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:createDate toDate:[NSDate date] options:NSCalendarWrapComponents];
}
+ (NSString *)timeIntervalFromLastTime:(NSString *)serverTime timeFormat:(NSString *)format {
    XLTools *tool = [[XLTools alloc] init];
    NSString *str = nil;
    NSDate *createDate = [tool serverCreateDate:serverTime timeFormat:format];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateComponents *deltaTime = [tool deltaWithNow:serverTime timeFormat:format];
    if([tool isThisYear:createDate]) {   // 今年
        if([tool isThisToday:createDate]){   // 今天
            if(deltaTime.hour >= 1) {   // 时间差大于等于1小时
                str = [NSString stringWithFormat:@"%ld小时前",(long)deltaTime.hour];
            }else if (deltaTime.minute >= 1){   // 时间差大于等于1分钟
                str = [NSString stringWithFormat:@"%ld分钟前",(long)deltaTime.minute];
            }else {
                // 小于1分钟
                str = @"刚刚";
            }
        }else if([tool isThisYesterday:createDate]){
            dateFormatter.dateFormat = @"昨天 HH:mm";
            str = [dateFormatter stringFromDate:createDate];
        }else {
            // 昨天之前
            dateFormatter.dateFormat = @"MM-dd HH:mm:ss";
            str = [dateFormatter stringFromDate:createDate];
        }
    }else { // 非今年
        str = serverTime;
    }
    return str;
}


@end
