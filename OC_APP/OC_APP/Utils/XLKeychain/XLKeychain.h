//
//  XLKeychain.h
//  OC_APP
//
//  Created by xingl on 2018/2/27.
//  Copyright © 2018年 兴林. All rights reserved.
//

/*
 keychain 共享
 
 在keychain sharing 中添加需要共享的app的 bundle ID。
  
 */

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface XLKeychain : NSObject

/**
 *  储存字符串到钥匙串
 *  @param sValue 对应的Value
 *  @param sKey   对应的Key
 */
+ (BOOL)saveKeychainValue:(NSString *)sValue key:(NSString *)sKey;

/**
 *  从钥匙串获取字符串
 *  @param sKey 对应的Key
 *  @return 返回储存的Value
 */
+ (NSString *)readKeychainValue:(NSString *)sKey;

/**
 *  从钥匙串删除字符串
 *  @param sKey 对应的Key
 */
+ (void)deleteKeychainValue:(NSString *)sKey;


@end
