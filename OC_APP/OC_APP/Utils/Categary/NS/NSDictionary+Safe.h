//
//  NSDictionary+Safe.h
//  OC_APP
//
//  Created by xingl on 2018/4/3.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Safe)

- (id)xl_safeObjectForKey:(NSString *)key;

- (void)xl_safeSetObject:(id)object forKey:(id)key;

@end

@interface NSMutableDictionary (Safe)
- (void)xl_safeSetObject:(id)aObj forKey:(id<NSCopying>)aKey;

- (id)xl_safeObjectForKey:(id<NSCopying>)aKey;
@end
