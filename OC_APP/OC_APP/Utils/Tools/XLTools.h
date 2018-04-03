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


@end
