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
+ (void)appStartWithMainViewController:(UIViewController *)mainVC guideImages:(NSArray *)array;

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

/**
 广告位标识符：在同一个设备上的所有App都会取到相同的值，是苹果专门给各广告提供商用来追踪用户而设的，用户可以在 设置|隐私|广告追踪里重置此id的值，或限制此id的使用，故此id有可能会取不到值，但好在Apple默认是允许追踪的，而且一般用户都不知道有这么个设置，所以基本上用来监测推广效果，是戳戳有余了

 @return IDFA
 */
+ (NSString *)getIDFA;








@end
