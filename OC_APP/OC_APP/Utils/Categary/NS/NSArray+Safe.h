//
//  NSArray+Safe.h
//  OC_APP
//
//  Created by xingl on 2018/4/3.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Safe)

+ (instancetype)xl_safeArrayWithObject:(id)object;

- (id)xl_safeObjectAtIndex:(NSUInteger)index;

- (NSArray *)xl_safeSubarrayWithRange:(NSRange)range;

- (NSUInteger)xl_safeIndexOfObject:(id)anObject;

//通过Plist名取到Plist文件中的数组
+ (NSArray *)xl_arrayNamed:(NSString *)name;

@end

@interface NSMutableArray (Safe)
//以下写法均防止闪退
- (void)xl_safeAddObject:(id)object;

- (void)xl_safeInsertObject:(id)object atIndex:(NSUInteger)index;

- (void)xl_safeInsertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexs;

- (void)xl_safeRemoveObjectAtIndex:(NSUInteger)index;

- (void)xl_safeRemoveObjectsInRange:(NSRange)range;

@end
