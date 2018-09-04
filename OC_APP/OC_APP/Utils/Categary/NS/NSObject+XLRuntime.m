//
//  NSObject+XLRuntime.m
//  OC_APP
//
//  Created by xingl on 2018/8/16.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "NSObject+XLRuntime.h"

@implementation NSObject (XLRuntime)

+ (NSArray *)xl_fetchIvarList {
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(self, &count);
    NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
        const char *ivarName = ivar_getName(ivars[i]);
        const char *ivarType = ivar_getTypeEncoding(ivars[i]);
        dic[@"type"] = [NSString stringWithUTF8String:ivarType];
        dic[@"IvarName"] = [NSString stringWithUTF8String:ivarName];
        [mutableArr addObject:dic];
    }
    free(ivars);
    return [NSArray arrayWithArray:mutableArr];
}

+ (NSArray *)xl_fetchPropertyList {
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(self, &count);
    NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++) {
        const char *propertyName = property_getAttributes(properties[i]);
        [mutableArr addObject:[NSString stringWithUTF8String:propertyName]];
    }
    free(properties);
    return [NSArray arrayWithArray:mutableArr];
}

+ (NSArray *)xl_fetchProtocolList {
    unsigned int count = 0;
    __unsafe_unretained Protocol **protocols = class_copyProtocolList(self, &count);
    NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++) {
        Protocol *protocol = protocols[i];
        const char *protocolName = protocol_getName(protocol);
        [mutableArr addObject:[NSString stringWithUTF8String:protocolName]];
    }
    return [NSArray arrayWithArray:mutableArr];
}

+ (NSArray *)xl_fetchClassMethodList {
    unsigned int count = 0;
    Method *methods = class_copyMethodList(object_getClass(self), &count);
    NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++) {
        Method method = methods[i];
        SEL methodName = method_getName(method);
        [mutableArr addObject:NSStringFromSelector(methodName)];
    }
    free(methods);
    return [NSArray arrayWithArray:mutableArr];
}

+ (NSArray *)xl_fetchInstanceMethodList {
    unsigned int count = 0;
    Method *methods = class_copyMethodList(self, &count);
    NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++) {
        Method method = methods[i];
        SEL methodName = method_getName(method);
        [mutableArr addObject:NSStringFromSelector(methodName)];
    }
    free(methods);
    return [NSArray arrayWithArray:mutableArr];
}

+ (void)xl_addInstanceMethod:(SEL)methodSel
                   methodImp:(SEL)methodImp {
    Method method = class_getInstanceMethod(self, methodImp);
    IMP methodIMP = method_getImplementation(method);
    const char *types = method_getTypeEncoding(method);
    class_addMethod(self, methodSel, methodIMP, types);
}

+ (void)xl_addClassMethod:(SEL)methodSel methodImp:(SEL)methodImp {
    Method method = class_getClassMethod(self, methodImp);
    IMP methodIMP = method_getImplementation(method);
    const char *types = method_getTypeEncoding(method);
    class_addMethod(object_getClass(self), methodSel, methodIMP, types);
}

+ (void)xl_swizzleInstanceMethod:(SEL)originalSelector
                swizzledSelector:(SEL)swizzledSelector {
    
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
