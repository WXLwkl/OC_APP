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

/** 系统的版本号 */
+ (NSString *)systemVersion;

/** 是否有摄像头 */
+ (BOOL)hasCamera;

/** 获取手机内存总量,返回的是字节数 */
+ (long long)totalMemoryBytes;

/** 获取手机可用内存，返回的是字节数 */
+ (NSUInteger)freeMemoryBytes;

/** 获取手机硬盘总空间，返回的是 兆 字节数 */
+ (CGFloat)totalDiskSpaceMBytes;

/** 获取手机硬盘空闲空间，返回的是 兆 字节数 */
+ (CGFloat)freeDiskSpaceMBytes;

@end
