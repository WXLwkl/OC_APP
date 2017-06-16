//
//  UIViewController+Present.m
//  OC_APP
//
//  Created by xingl on 2017/6/10.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "UIViewController+Present.h"
#import <objc/runtime.h>

@implementation UIViewController (Present)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //获得viewController的生命周期方法的selector
        SEL systemSel = @selector(presentViewController:animated:completion:);
        //自己实现的将要被交换的方法的selector
        SEL swizzSel = @selector(xl_presentViewController:animated:completion:);
        //两个方法的Method
        Method systemMethod = class_getInstanceMethod([self class], systemSel);
        Method swizzMethod = class_getInstanceMethod([self class], swizzSel);
        //首先动态添加方法，实现是被交换的方法，返回值表示添加成功还是失败
        BOOL isAdd = class_addMethod(self, systemSel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod));
        if (isAdd) {
            //如果成功，说明类中不存在这个方法的实现
            //将被交换方法的实现替换到这个并不存在的实现
            class_replaceMethod(self, swizzSel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
        }else{
            //否则，交换两个方法的实现
            method_exchangeImplementations(systemMethod, swizzMethod);
        }
        
        
    });
}

- (void)xl_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if ([viewControllerToPresent isKindOfClass:[UIAlertController class]]) {
        NSLog(@"title: %@, message: %@",((UIAlertController *)viewControllerToPresent).title, ((UIAlertController *)viewControllerToPresent).message);
        
        UIAlertController *alertC = (UIAlertController *)viewControllerToPresent;
        if (alertC.title == nil && alertC.message == nil) {
            return;
        } else {
            [self xl_presentViewController:viewControllerToPresent animated:flag completion:completion];
            return;
        }
    }
    //这时候调用自己，看起来像是死循环
    //但是其实自己的实现已经被替换了
    [self xl_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

@end
