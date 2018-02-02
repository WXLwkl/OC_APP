//
//  AppManager.m
//  OC_APP
//
//  Created by xingl on 2017/6/8.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "AppManager.h"
#import <AdSupport/AdSupport.h>
#import "SAMKeychain.h"

#import "AdvertiseManager.h"

@implementation AppManager

+ (void)appStartWithMainViewController:(UIViewController *)mainVC guideImages:(NSArray *)array {
    
    [AdvertiseManager loadAdvertise];
}



//沙盒路径的获取
#pragma mark 沙盒主路径
+ (NSString *)homePath {
    return NSHomeDirectory();
}

#pragma mark 用户应用数据路径
+ (NSString *)getDocuments {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

#pragma mark 缓存数据路径
+ (NSString *)getCache {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return paths[0];
}

#pragma mark 临时文件路径
+ (NSString *)getTemp {
    return NSTemporaryDirectory();
}

#pragma mark Library路径
+ (NSString *)getLibrary {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}



/** 应用版本号 */
+ (NSString *)appVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return appVersion;
}
/** 应用名称xxx */
+ (NSString *)appName {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    return appName;
}

+ (NSString *)appUUUID {
    
    //从钥匙串读取UUID：
    NSString *retrieveUUID = [SAMKeychain passwordForService:@"com.yourapp.yourcompany"account:@"user"];
    NSLog(@"----->%@", retrieveUUID);
    if (XL_IsEmptyString(retrieveUUID)) {
        
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        assert(uuid != NULL);
        CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
        
        retrieveUUID = [NSString stringWithFormat:@"%@", uuidStr];
        
        //OC的API
//        NSString *retrieveUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//        NSLog(@"唯一识别码uuid-->%@", retrieveUUID);
        
        NSLog(@"%@",retrieveUUID);
        //在钥匙串中写入UUID
        [SAMKeychain setPassword:retrieveUUID
                      forService:@"com.yourapp.yourcompany"account:@"user"];
    }
    
    return retrieveUUID;
}

+ (NSString *)getIDFA {
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

@end
