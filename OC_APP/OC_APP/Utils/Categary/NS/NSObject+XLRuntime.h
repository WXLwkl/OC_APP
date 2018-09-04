//
//  NSObject+XLRuntime.h
//  OC_APP
//
//  Created by xingl on 2018/8/16.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (XLRuntime)

/** 获取成员变量，包括属性生成的成员变量 */
+ (NSArray *)xl_fetchIvarList;
/** 获取属性列表，包括私有属性、共有属性、分类的属性 */
+ (NSArray *)xl_fetchPropertyList;
/** 获取实例方法列表，包括getter、setter、分类的方法 */
+ (NSArray *)xl_fetchInstanceMethodList;
/** 获取类方法列表，包括分类的 */
+ (NSArray *)xl_fetchClassMethodList;
/** 获取协议列表，包括 .h、.m、分类的 */
+ (NSArray *)xl_fetchProtocolList;

/** 添加实例方法 */
+ (void)xl_addInstanceMethod:(SEL)methodSel methodImp:(SEL)methodImp;
/** 添加类方法 */
+ (void)xl_addClassMethod:(SEL)methodSel methodImp:(SEL)methodImp;

/** 实例方法交换 */
+ (void)xl_swizzleInstanceMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;


@end
