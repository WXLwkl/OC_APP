//
//  NSObject+xl_KVO.m
//  OC_APP
//
//  Created by xingl on 2018/5/14.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "NSObject+xl_KVO.h"
#import <objc/message.h>
// 原生子类前缀 "NSKVONotifying_"
#define XLKVOClassPrefix @"XLKVO_"
#define XLAssociateArrayKey @"XLAssociateArrayKey"

@implementation NSObject (xl_KVO)

- (void)xl_addObserver:(id)observer key:(NSString *)key callback:(XLKVOCallback)callback {
    // 1.检查对象的类有没有相应的 setter 方法，如果没有 抛出异常
    SEL setterSelector = NSSelectorFromString([self setterForGetter:key]);
    
    Method setterMethod = class_getInstanceMethod([self class], setterSelector);
    if (!setterMethod) return NSLog(@"没有找到该方法");
    // 2.检查对象 isa 指向的类是不是一个kvo的类，如果不是，新建一个继承原来类的子类，并把isa指向这个新建的子类
    Class class = object_getClass(self);
    NSString *className = NSStringFromClass(class);
    if (![className hasPrefix:XLKVOClassPrefix]) {
        class = [self xl_KVOClassWithOriginalClassName:className];
        object_setClass(self, class);
    }
    // 3. 为kvoClass添加setter方法的实现
    const char *types = method_getTypeEncoding(setterMethod);
    class_addMethod(class, setterSelector, (IMP)xl_setter, types);
    // 4.添加该观察者到观察者列表中
    // 4.1 创建观察者的信息
    XLObserverInfo *info = [[XLObserverInfo alloc] initWithObserver:observer key:key callback:callback];
    // 4.2 获取关联对象(装着所有监听者的数组)
    NSMutableArray *observers = objc_getAssociatedObject(self, XLAssociateArrayKey);
    if (!observers) {
        observers = [NSMutableArray array];
        objc_setAssociatedObject(self, XLAssociateArrayKey, observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [observers addObject:info];
}

- (void)xl_removeObserver:(id)observer key:(NSString *)key {
    NSMutableArray *observers = objc_getAssociatedObject(self, XLAssociateArrayKey);
    if (!observers) return;
    for (XLObserverInfo *info in observers) {
        if ([info.key isEqualToString:key]) {
            [observers removeObject:info];
            break;
        }
    }
}

/**
 动态创建类

 @param className 类型
 @return 衍生类
 */
- (Class)xl_KVOClassWithOriginalClassName:(NSString *)className {
    NSString *kvoClassName = [XLKVOClassPrefix stringByAppendingString:className];
    Class kvoClass = NSClassFromString(kvoClassName);
    // 如果kvoClass存在 则返回
    if (kvoClass) return kvoClass;
    // 如果 kvoClass 不存在 则创建这个类
    Class originClass = object_getClass(self);
    kvoClass = objc_allocateClassPair(originClass, kvoClassName.UTF8String, 0);
    // 修改 kvoClass 方法的实现
    Method classMethod = class_getInstanceMethod(kvoClass, @selector(class));
    const char *types = method_getTypeEncoding(classMethod);
    class_addMethod(kvoClass, @selector(class), (IMP)xl_class, types);
    
    // 注册 kvoClass
    objc_registerClassPair(kvoClass);
    
    return kvoClass;
}

/**
 *  模仿Apple的做法, 欺骗人们这个kvo类还是原类
 */
Class xl_class(id self, SEL cmd) {
    Class class = object_getClass(self);
    Class superClass = class_getSuperclass(class);
    return superClass;
}

/**
 *  重写setter方法, 新方法在调用原方法后, 通知每个观察者(调用传入的block)
 */
static void xl_setter(id self, SEL _cmd, id newValue) {
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *getterName = [self getterForSetter:setterName];
    if (!getterName) NSLog(@"找不到getter方法");
    
    // 获取旧值
    id oldValue = [self valueForKey:getterName];
    // 调用原类的setter方法
    struct objc_super superClass = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(void *, SEL, id))objc_msgSendSuper)(&superClass, _cmd, newValue);
    
    // 找到观察者的数组，调用对应对象的callback
    NSMutableArray *observers = objc_getAssociatedObject(self, XLAssociateArrayKey);
    //遍历数组
    for (XLObserverInfo *info in observers) {
        if ([info.key isEqualToString:getterName]) {
            // gcd 异步调用callback
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                info.callback(info.observer, getterName, oldValue, newValue);
            });
        }
    }
}

- (NSString *)setterForGetter:(NSString *)key {
    // 1、首字母转换大写
    unichar c = [key characterAtIndex:0];
    NSString *str = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[NSString stringWithFormat:@"%c", c-32]];
    // 2、最前增加set，最后增加:
    NSString *setter = [NSString stringWithFormat:@"set%@:", str];
    return setter;
}

- (NSString *)getterForSetter:(NSString *)key {
    // 1.去掉set
    NSRange range = [key rangeOfString:@"set"];
    NSString *subStr1 = [key substringFromIndex:range.location + range.length];
    
    // 2. 首字母转换成大写
    unichar c = [subStr1 characterAtIndex:0];
    NSString *subStr2 = [subStr1 stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[NSString stringWithFormat:@"%c", c+32]];
    
    // 3. 去掉最后的:
    NSRange range2 = [subStr2 rangeOfString:@":"];
    NSString *getter = [subStr2 substringToIndex:range2.location];
    
    return getter;
}

@end
