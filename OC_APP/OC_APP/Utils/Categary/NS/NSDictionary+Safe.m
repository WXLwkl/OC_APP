//
//  NSDictionary+Safe.m
//  OC_APP
//
//  Created by xingl on 2018/4/3.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "NSDictionary+Safe.h"

@implementation NSDictionary (Safe)

- (id)xl_safeObjectForKey:(NSString *)key {
    if (key == nil || [self isKindOfClass:[NSNull class]]) {
        return nil;
    }
    id object = [self objectForKey:key];
    if (object == nil || object == [NSNull null]) {
        return @"";
    }
    return object;
}

- (void)xl_safeSetObject:(id)object forKey:(id)key {
    if ([key isKindOfClass:[NSNull class]]) {
        return;
    }
    if ([object isKindOfClass:[NSNull class]]) {
        [self setValue:@"" forKey:key];
    } else {
        [self setValue:object forKey:key];
    }
}

@end

@implementation NSMutableDictionary (Safe)

- (void)xl_safeSetObject:(id)aObj forKey:(id<NSCopying>)aKey {
    if (aObj && ![aObj isKindOfClass:[NSNull class]] && aKey) {
        [self setObject:aObj forKey:aKey];
    } else {
        return;
    }
}

- (id)xl_safeObjectForKey:(id<NSCopying>)aKey {
    if (aKey != nil) {
        return [self objectForKey:aKey];
    } else {
        return nil;
    }
}

@end
