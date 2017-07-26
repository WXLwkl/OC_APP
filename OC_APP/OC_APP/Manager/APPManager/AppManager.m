//
//  AppManager.m
//  OC_APP
//
//  Created by xingl on 2017/6/8.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "AppManager.h"
#import "LaunchViewController.h"
#import "SAMKeychain.h"

@implementation AppManager

+ (UIViewController *)appStartWithMainViewController:(UIViewController *)mainVC guideImages:(NSArray *)array {
    
    UIViewController *vc = [[LaunchViewController alloc] initWithMainViewController:mainVC guideImages:array];
    
    return vc;
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
        //在钥匙串中写入UUID
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        assert(uuid != NULL);
        CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
        
        retrieveUUID = [NSString stringWithFormat:@"%@", uuidStr];
        
        NSLog(@"%@",retrieveUUID);
        [SAMKeychain setPassword:retrieveUUID
                      forService:@"com.yourapp.yourcompany"account:@"user"];
    }
    
    return retrieveUUID;
    
}
@end
