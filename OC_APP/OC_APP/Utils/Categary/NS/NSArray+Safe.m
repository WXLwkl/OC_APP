//
//  NSArray+Safe.m
//  OC_APP
//
//  Created by xingl on 2018/4/3.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "NSArray+Safe.h"

@implementation NSArray (Safe)

+ (instancetype)xl_safeArrayWithObject:(id)object {
    if (object == nil) {
        return [self array];
    } else {
        return [self arrayWithObject:object];
    }
}

- (id)xl_safeObjectAtIndex:(NSUInteger)index {
    if (index > self.count) {
        return nil;
    }
    return [self objectAtIndex:index];
}

- (NSArray *)xl_safeSubarrayWithRange:(NSRange)range {
    NSUInteger location = range.location;
    NSUInteger length = range.length;
    if (location + length > self.count) {
        // 超出边界，就获取从location开始所有的item
        length = self.count - location;
        return [self xl_safeSubarrayWithRange:NSMakeRange(location, length)];
    }
    return [self subarrayWithRange:range];
}

- (NSUInteger)xl_safeIndexOfObject:(id)anObject {
    if (anObject == nil) {
        return NSNotFound;
    }
    return [self indexOfObject:anObject];
}

+ (NSArray *)xl_arrayNamed:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:path];
}

@end

@implementation NSMutableArray (Safe)

- (void)xl_safeAddObject:(id)object {
    if (object == nil) {
        return;
    }
    [self addObject:object];
}

- (void)xl_safeInsertObject:(id)object atIndex:(NSUInteger)index {
    if (object == nil) {
        return;
    } else if (index > self.count) {
        return;
    } else {
        [self insertObject:object atIndex:index];
    }
}

- (void)xl_safeInsertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexs {
    NSUInteger firstIndex = indexs.firstIndex;
    if (objects == nil) {
        return;
    } else if (indexs.count != objects.count || firstIndex > objects.count) {
        return;
    } else {
        [self insertObjects:objects atIndexes:indexs];
    }
}

- (void)xl_safeRemoveObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) return;
    [self removeObjectAtIndex:index];
}

- (void)xl_safeRemoveObjectsInRange:(NSRange)range {
    NSUInteger location = range.location;
    NSUInteger length = range.length;
    if (location + length > self.count) {
        return;
    } else {
        [self removeObjectsInRange:range];
    }
}


@end
