//
//  NSObject+Swizzling.m
//  OC_APP
//
//  Created by xingl on 2017/11/21.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "NSObject+Swizzling.h"

@implementation NSObject (Swizzling)

+ (void)xl_methodSwizzlingWithOriginalSelector:(SEL)originalSelector
                         bySwizzledSelector:(SEL)swizzledSelector {
   
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    //将methodB的实现添加到系统方法中也就是说将methodA方法指针添加成方法methodB的返回值表示是否添加成功
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    //添加成功了说明本类中不存在methodB所以此时必须将方法b的实现指针换成方法A的，否则b方法将没有实现。
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        //添加失败了说明本类中有methodB的实现，此时只需要将methodA和methodB的IMP互换一下即可。
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
