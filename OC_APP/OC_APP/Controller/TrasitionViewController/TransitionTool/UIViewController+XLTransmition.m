//
//  UIViewController+XLTransmition.m
//  OC_APP
//
//  Created by xingl on 2019/3/11.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "UIViewController+XLTransmition.h"
#import <objc/runtime.h>

NSString *const kAnimationKey = @"kAnimationKey";
NSString *const kToAnimationKey = @"kToAnimationKey";


@implementation UIViewController (XLTransmition)

- (void)xl_pushViewController:(UIViewController *)viewController withAnimation:(XLTransitionAnimationManager *)transitionManager {
    if (!viewController) return;
    if (!transitionManager) return;
    if (self.navigationController) {
        self.navigationController.delegate = transitionManager;
        
        XLInteractiveTransition *toInteractiveTransition = objc_getAssociatedObject(self, &kToAnimationKey);
        if (toInteractiveTransition) {
            [transitionManager setValue:toInteractiveTransition forKey:@"toInteractiveTransition"];
        }
        objc_setAssociatedObject(viewController, &kAnimationKey, transitionManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)xl_presentViewController:(UIViewController *)viewController withAnimation:(XLTransitionAnimationManager *)transitionManager {
    if (!viewController) return;
    if (!transitionManager) return;
    viewController.transitioningDelegate = transitionManager;
    
    XLInteractiveTransition *toInteractiveTransition = objc_getAssociatedObject(self, &kToAnimationKey);
    if (toInteractiveTransition) {
        [transitionManager setValue:toInteractiveTransition forKey:@"toInteractiveTransition"];
    }
    objc_setAssociatedObject(viewController, &kAnimationKey, transitionManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self presentViewController:viewController animated:true completion:nil];
}

- (void)xl_registerToInteractiveTransitionWithDirection:(XLInteractiveTransitionGestureDirection)direction eventBlock:(dispatch_block_t)block {
    XLInteractiveTransition *transition = [[XLInteractiveTransition alloc] init];
    transition.eventBlcok = block;
    [transition addEdgePageGestureWithView:self.view direction:direction];
    
    objc_setAssociatedObject(self, &kToAnimationKey, transition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)xl_registerBackInteractiveTransitionWithDirection:(XLInteractiveTransitionGestureDirection)direction eventBlock:(dispatch_block_t)block {
    XLInteractiveTransition *transtition = [[XLInteractiveTransition alloc] init];
    transtition.eventBlcok = block;
    [transtition addEdgePageGestureWithView:self.view direction:direction];
    
    XLTransitionAnimationManager *animator = objc_getAssociatedObject(self, &kAnimationKey);
    if (animator) {
        [animator setValue:transtition forKey:@"backInteractiveTransition"];
    }
}

@end
