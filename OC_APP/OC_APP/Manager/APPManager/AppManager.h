//
//  AppManager.h
//  OC_APP
//
//  Created by xingl on 2017/6/8.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 包含应用层的相关服务
 */
@interface AppManager : NSObject

#pragma mark - ——————— APP启动接口 ————————
+ (UIViewController *)appStartWithMainViewController:(UIViewController *)mainVC guideImages:(NSArray *)array;

/** 沙盒主路径 */
+ (NSString *)homePath;

/** 用户应用数据路径 */
+ (NSString *)getDocuments;

/** 缓存数据路径 */
+ (NSString *)getCache;

/** 临时文件路径 */
+ (NSString *)getTemp;

/** Library路径 */
+ (NSString *)getLibrary;


/** 应用版本号 */
+ (NSString *)appVersion;
/** 应用名称 */
+ (NSString *)appName;

/** UUID */
+ (NSString *)appUUUID;









@end
