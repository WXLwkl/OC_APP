//
//  UIDevice+Common.h
//  OC_APP
//
//  Created by xingl on 2017/6/28.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Common)

/** 获取设备型号 */
+ (NSString *)getDeviceName;
/** 系统的版本号 */
+ (NSString *)systemVersion;

/** mac地址 */
+ (NSString *)macAddress;
/** ip地址(局域网) */
+ (NSString *)getIPAddress;
/** WIFIip地址 */
+ (NSString *)getIpAddressWIFI;
/** 蜂窝地址 */
+ (NSString *)getIpAddressCell;


/** cpu个数 */
+ (NSUInteger)cpuNumber;
/** 获取CPU总的使用百分比 */
+ (float)getCPUUsage;
/** 获取单个CPU使用百分比 */
+ (NSArray *)getPerCPUUsage;



/** 是否有摄像头 */
+ (BOOL)hasCamera;
//是否越狱
+ (BOOL)isJailbroken;




/** 获取手机内存总量,返回的是字节数 */
+ (long long)totalMemoryBytes;

/** 获取手机可用内存，返回的是字节数 */
+ (NSUInteger)freeMemoryBytes;




//活跃的内存(正在使用或者很短时间内被使用)
+ (NSUInteger)getActiveMemory;
//不活跃的内存(最近使用过)
+ (NSUInteger)getInActiveMemory;

/** 用于存放内核和数据结构的内存 */
+ (NSUInteger)getWiredMemory;




/** 获取手机硬盘总空间，返回的是 兆 字节数 */
+ (CGFloat)totalDiskSpaceMBytes;

/** 获取手机硬盘空闲空间，返回的是 兆 字节数 */
+ (CGFloat)freeDiskSpaceMBytes;




@end
