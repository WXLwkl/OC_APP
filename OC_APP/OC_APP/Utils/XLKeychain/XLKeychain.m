//
//  XLKeychain.m
//  OC_APP
//
//  Created by xingl on 2018/2/27.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "XLKeychain.h"

@implementation XLKeychain

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge_transfer id)kSecClassGenericPassword,
            (__bridge_transfer id)kSecClass,service,
            (__bridge_transfer id)kSecAttrService,service,
            (__bridge_transfer id)kSecAttrAccount,
            (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,
            (__bridge_transfer id)kSecAttrAccessible,
            nil];
}

+ (BOOL)saveKeychainValue:(NSString *)sValue key:(NSString *)sKey {
    
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:sKey];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
    
//    NSString *perfix = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"AppIdentifierPrefix"];
//    NSString *groupString = [NSString stringWithFormat:@"%@com.xingl.xx",perfix];
//    [keychainQuery setObject:groupString forKey:(id)kSecAttrAccessGroup];
//
    
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:sValue] forKey:(__bridge_transfer id)kSecValueData];
    OSStatus status = SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);
    
    
    if (status == errSecSuccess) {
        
        return YES;
    }
    return NO;
}

+ (void)updateKeychainData:(id)data forKey:(NSString *)key {
    
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    
//    [keychainQuery setObject:accessItem forKey:(id)kSecAttrAccessGroup];
    
    NSData * updata = [NSKeyedArchiver archivedDataWithRootObject:data];
    
    NSDictionary *myDate = @{(__bridge id)kSecValueData : updata};
    
    SecItemUpdate((__bridge CFDictionaryRef)keychainQuery, (__bridge CFDictionaryRef)myDate);
    
}



+ (NSString *)readKeychainValue:(NSString *)sKey {
    
    NSString *ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:sKey];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = (NSString *)[NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", sKey, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)deleteKeychainValue:(NSString *)sKey {
    
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:sKey];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}

@end
