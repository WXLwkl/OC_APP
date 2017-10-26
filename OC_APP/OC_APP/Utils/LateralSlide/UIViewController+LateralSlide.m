//
//  UIViewController+LateralSlide.m
//  cehua
//
//  Created by xingl on 2017/10/24.
//  Copyright © 2017年 xingl. All rights reserved.
//

#import "UIViewController+LateralSlide.h"
#import <objc/runtime.h>


@implementation UIViewController (LateralSlide)

- (void)xl_showDrawerViewController:(UIViewController *)viewController animationType:(DrawerAnimationType)animationType configuration:(LateralSlideConfiguration *)configuration {
    
    if (viewController == nil) return;
    if (configuration == nil) configuration = [LateralSlideConfiguration defaultConfiguration];
    
    LateralSlideAnimator *animator = objc_getAssociatedObject(self, &LateralSlideAnimatorKey);
    if (animator == nil) {
        animator = [LateralSlideAnimator lateralSlideAnimatorWithConfiguration:configuration];
        objc_setAssociatedObject(viewController, &LateralSlideAnimatorKey, animator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    viewController.transitioningDelegate = animator;
    
    InteractiveTransition *interactiveHidden = [InteractiveTransition interactiveWithTransitiontype:DrawerTransitiontypeHidden];
    [interactiveHidden setValue:viewController forKey:@"weakVC"];
    [interactiveHidden setValue:@(configuration.direction) forKey:@"direction"];
    
    [animator setValue:interactiveHidden forKey:@"interactiveHidden"];
    animator.configuration = configuration;
    animator.animationType = animationType;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)xl_pushViewController:(UIViewController *)viewController {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav;
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabbarC = (UITabBarController *)rootVC;
        NSInteger index = tabbarC.selectedIndex;
        nav = tabbarC.childViewControllers[index];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]) {
        nav = (UINavigationController *)rootVC;
    } else if ([rootVC isKindOfClass:[UIViewController class]]) {
        NSLog(@"This no UINavigationController...");
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    [nav pushViewController:viewController animated:NO];
}

- (void)xl_registerShowIntractiveWithEdgeGesture:(BOOL)openEdgeGesture direction:(DrawerTransitionDirection)direction transitionBlock:(void (^)())transitionBlock {
    
    LateralSlideAnimator *animator = [LateralSlideAnimator lateralSlideAnimatorWithConfiguration:nil];
    
    self.transitioningDelegate = animator;
    
    objc_setAssociatedObject(self, &LateralSlideAnimatorKey, animator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    InteractiveTransition *interactiveShow = [InteractiveTransition interactiveWithTransitiontype:DrawerTransitiontypeShow];
    [interactiveShow addPanGestureForViewController:self];
    [interactiveShow setValue:@(openEdgeGesture) forKey:@"openEdgeGesture"];
    [interactiveShow setValue:transitionBlock forKey:@"transitionBlock"];
    [interactiveShow setValue:@(direction) forKey:@"direction"];
    
    [animator setValue:interactiveShow forKey:@"interactiveShow"];
}


@end
