//
//  XLFileManager.m
//  OC_APP
//
//  Created by xingl on 2017/11/27.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "XLFileManager.h"

@implementation XLFileManager

/// 把对象归档存到沙盒里
+ (void)saveObject:(id)object byFileName:(NSString *)fileName {
    NSString *path = [self appendFilePath:fileName];
    [NSKeyedArchiver archiveRootObject:object toFile:path];
}
/// 通过文件名从沙盒中找到归档的对象
+ (id)getObjectByFileName:(NSString *)fileName {
    NSString *path = [self appendFilePath:fileName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

// 根据文件名删除沙盒中的 plist 文件
+ (void)removeFileByFileName:(NSString *)fileName {
    NSString *path = [self appendFilePath:fileName];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

/// 存储用户偏好设置 到 NSUserDefults
+ (void)saveUserData:(id)data forKey:(NSString *)key {
    if (data) {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (id)readUserDataForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
/// 删除用户偏好设置
+ (void)removeUserDataForKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}


#pragma mark - private
+ (NSString *)appendFilePath:(NSString *)fileName {
    NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *file = [NSString stringWithFormat:@"%@/%@.archiver", documentsPath, fileName];
    return file;
}

@end
