//
//  FileManager.h
//  OC_APP
//
//  Created by xingl on 2018/6/22.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject


+ (BOOL)removeItemAtPath:(NSString *)path;

+ (NSString *)cachesDir;
// 判断文件路径是否存在
+ (BOOL)isExistsAtPath:(NSString *)path;
// 创建文件夹
+ (BOOL)createDirectoryAtPath:(NSString *)path;
@end
