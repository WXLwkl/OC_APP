//
//  XLFileManager.h
//  OC_APP
//
//  Created by xingl on 2017/11/27.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLFileManager : NSObject

//把对象归档到沙盒里
+ (void)saveObject:(id)object byFileName:(NSString *)fileName;
//通过文件名从沙盒中找到归档的对象
+ (id)getObjectByFileName:(NSString *)fileName;

//根据文件名删除沙盒中的plist文件
+ (void)removeFileByFileName:(NSString *)fileName;

//存储用户偏好设置到NSUserDefults
+ (void)saveUserData:(id)data forKey:(NSString *)key;

//读取用户偏好设置
+ (id)readUserDataForKey:(NSString *)key;

//删除用户偏好设置
+ (void)removeUserDataForKey:(NSString *)key;
@end
