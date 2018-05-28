//
//  XLTools.h
//  OC_APP
//
//  Created by xingl on 2018/4/3.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLTools : NSObject

/*!
 * @brief 获取文件大小
 *
 * @param filePath 文件路径（字符串类型）
 *
 */
+ (long long)fileSizeAtPath:(NSString *)filePath;

/**
 *  @brief 获取文件夹下所有文件的总大小
 *
 *  @param folderPath 文件夹路径
 *
 */
+ (long long)folderSizeAtPath:(NSString *)folderPath;


#pragma mark - 字符串数组按照元素首字母顺序进行排序

/*
 NSArray *arr = @[@"guangzhou", @"shanghai", @"北京", @"henan", @"hainan"];
 NSDictionary *dic = [XLTools dictionaryOrderByCharacterWithOriginalArray:arr];
 NSLog(@"\n\ndic: %@", dic);
 */

/*!
 *  @brief 将字符串数组按照元素首字母顺序进行排序分组
 **
 *  @return NSDictionary
 */
+ (NSDictionary *)dictionaryOrderByCharacterWithOriginalArray:(NSArray *)array;

#pragma mark - 时间
/*
 NSLog(@"\n\nresult: %@", [Utilities timeIntervalFromLastTime:@"2015年12月8日 15:50"
 lastTimeFormat:@"yyyy年MM月dd日 HH:mm"
 ToCurrentTime:@"2015/12/08 16:12"
 currentTimeFormat:@"yyyy/MM/dd HH:mm"]);
 */

/**
 *  @brief 计算上次日期距离现在多久
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
                     currentTimeFormat:(NSString *)format2;

/**
 *  计算上次日期距离现在多久
 *
 *  @param lastTime    上次日期(需要和格式对应)
 *  @param format1     上次日期格式
 *
 *  @return xx分钟前、xx小时前、xx天前
 */
//(1)
+ (NSString *)timeIntervalFromLastTime:(NSString *)lastTime
                        lastTimeFormat:(NSString *)format1;
//(2)
+ (NSString *)timeIntervalFromLastTime:(NSString *)serverTime
                            timeFormat:(NSString *)format;


@end
