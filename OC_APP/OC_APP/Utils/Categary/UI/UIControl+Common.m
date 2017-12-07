//
//  UIControl+Common.m
//  OC_APP
//
//  Created by xingl on 2017/11/17.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "UIControl+Common.h"
#import <objc/runtime.h>

static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";
static const char *UIControl_ignoreEventInterval = "UIControl_ignoreEventInterval";

@implementation UIControl (Common)

- (NSTimeInterval)xl_responseTime {
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}
- (void)setXl_responseTime:(NSTimeInterval)responseTime {
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(responseTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)ignoreEvent {
    return [objc_getAssociatedObject(self, UIControl_ignoreEventInterval) boolValue];
}
- (void)setIgnoreEvent:(BOOL)ignoreEvent {
    objc_setAssociatedObject(self, UIControl_ignoreEventInterval, @(ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)__UResponse_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if (self.ignoreEvent) return;
    if (self.xl_responseTime > 0) {
        self.ignoreEvent = YES;
        [self performSelector:@selector(setIgnoreEvent:) withObject:@(NO) afterDelay:self.xl_responseTime];
    }
    
    [self __UResponse_sendAction:action to:target forEvent:event];
    
/*
    if ([NSDate date].timeIntervalSince1970 - self.xl_acceptEventTime < self.xl_acceptEventInterval) {
        return;
    }
 
    if (self.xl_acceptEventInterval > 0) {
        self.xl_acceptEventTime = [NSDate date].timeIntervalSince1970;
    }
 
    [self xl_sendAction:action to:target forEvent:event];
 */
    
}


+(void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selA = @selector(sendAction:to:forEvent:);
        SEL selB = @selector(__UResponse_sendAction:to:forEvent:);
        Method methodA = class_getInstanceMethod(self, selA);
        Method methodB = class_getInstanceMethod(self, selB);
        //将methodB的实现添加到系统方法中也就是说将methodA方法指针添加成方法methodB的返回值表示是否添加成功
        BOOL isAdd = class_addMethod(self, selA,method_getImplementation(methodB),method_getTypeEncoding(methodB));
        //添加成功了说明本类中不存在methodB所以此时必须将方法b的实现指针换成方法A的，否则b方法将没有实现。
        if(isAdd) {
            class_replaceMethod(self, selB,method_getImplementation(methodA),method_getTypeEncoding(methodA));
        }else{
            //添加失败了说明本类中有methodB的实现，此时只需要将methodA和methodB的IMP互换一下即可。
            method_exchangeImplementations(methodA, methodB);
        }
    });
}


@end
