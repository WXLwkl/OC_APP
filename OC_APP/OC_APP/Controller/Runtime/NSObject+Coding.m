//
//  NSObject+Coding.m
//  OC_APP
//
//  Created by xingl on 2018/5/28.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "NSObject+Coding.h"

@implementation NSObject (Coding)

- (void)xl_decode:(NSCoder *)aDecoder {
    Class c = [self class];
    while (c && c != [NSObject class]) {
        unsigned int count;
        Ivar *ivars = class_copyIvarList(c, &count);
        for (int i = 0; i < count; i++) {
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar);
            NSString *key = [NSString stringWithUTF8String:name];
            
            if ([self respondsToSelector:@selector(ignoredNames)]) {
                if ([[self ignoredNames] containsObject:key]) continue;
            }
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(ivars);
        c = [c superclass];
    }
}

- (void)xl_encode:(NSCoder *)aCoder {
    
    Class c = [self class];
    while (c && c != [NSObject class]) {
        unsigned int count;
        Ivar *ivars = class_copyIvarList(c, &count);
        for (int i = 0; i < count; i++) {
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar);
            NSString *key = [NSString stringWithUTF8String:name];
            
            if ([self respondsToSelector:@selector(ignoredNames)]) {
                if ([[self ignoredNames] containsObject:key]) continue;
            }
            id value = [self valueForKeyPath:key];
            [aCoder encodeObject:value forKey:key];
        }
        free(ivars);
        c = [c superclass];
    }
}
@end
