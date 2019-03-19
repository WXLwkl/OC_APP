//
//  Dog.m
//  OC_APP
//
//  Created by xingl on 2019/2/22.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "Dog.h"
#import "Animal.h"
#import <objc/message.h>

@implementation Dog

- (void)other {
    NSLog(@"%s",__func__);
}

struct method_t {
    SEL sel;
    char *types;
    IMP imp;
};

void c_other(id self, SEL _cmd, NSString *objc) {
    NSLog(@"c_other: %@ - %@ - %@", self, NSStringFromSelector(_cmd), objc);
}

#pragma mark - 动态方法解析
/// 动态方法解析
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(eatx:)) {
        ////        方法一：
        //        //获取其他方法
        //        struct method_t *method = (struct method_t *)class_getInstanceMethod(self, @selector(other));
        //        //获取其他方法
        //        class_addMethod(self, sel, method->imp, method->types);
        //        return YES;
        ////        方法y二：
        //        //获取其他方法
        //        Method method = class_getInstanceMethod(self, @selector(other));
        //        //动态添加test的方法
        //        class_addMethod(self, sel, method_getImplementation(method), method_getTypeEncoding(method));
        //        return YES;
        //        方法三：
        class_addMethod(self, sel, (IMP)c_other, "");
        return YES;
    }
    
    return [super resolveInstanceMethod:sel];
}



#pragma mark - 消息转发
/*
 调用forwardingTargetForSelector，返回值不为nil时，
 会调用objc_msgSend(返回值, SEL)，结果就是调用了objc_msgSend(Student,test)
 */
- (id)forwardingTargetForSelector:(SEL)aSelector{
    if (aSelector == @selector(eat:)) {
        
        return [[Animal alloc]init];
    }
    return [super forwardingTargetForSelector:aSelector];
}

/**
 当forwardingTargetForSelector返回值为nil，或者都没有调用该方法的时候，系统会调用methodSignatureForSelector方法。调用methodSignatureForSelector,返回值不为nil，调用forwardInvocation:方法；返回值为nil时，调用doesNotRecognizeSelector:方法，后并崩溃
 */

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    //    return nil;
//    NSString *selString = NSStringFromSelector(aSelector);
//    if (selString isEqualToString:@"test") {}
    if (aSelector == @selector(test)) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
//        return [[Animal new] methodSignatureForSelector:aSelector];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"=======");
    
    if (anInvocation.selector == @selector(test)) {
        [anInvocation invokeWithTarget:[[Animal alloc] init]];
    } else {
        [super forwardInvocation:anInvocation];
    }
    
    //    Animal *ani = [[Animal alloc] init];
    //    anInvocation.target = ani;
    //    [anInvocation invoke];
    // 等价于
    //    [anInvocation invokeWithTarget:[[Animal alloc] init]];
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    NSLog(@"-----> ");
}


@end
