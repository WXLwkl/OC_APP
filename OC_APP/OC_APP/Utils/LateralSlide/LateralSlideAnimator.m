//
//  LateralSlideAnimator.m
//  cehua
//
//  Created by xingl on 2017/10/25.
//  Copyright © 2017年 xingl. All rights reserved.
//

#import "LateralSlideAnimator.h"
#import "DrawerTransition.h"

@interface LateralSlideAnimator ()

@property (nonatomic,strong)InteractiveTransition *interactiveHidden;
@property (nonatomic,strong)InteractiveTransition *interactiveShow;

@end
@implementation LateralSlideAnimator

+ (instancetype)lateralSlideAnimatorWithConfiguration:(LateralSlideConfiguration *)configuration {
    return [[self alloc] initWithConfiguration:configuration];
}

- (instancetype)initWithConfiguration:(LateralSlideConfiguration *)configuration {
    if (self = [super init]) {
        _configuration = configuration;
    }
    return self;
}

- (void)setConfiguration:(LateralSlideConfiguration *)configuration {
    _configuration = configuration;
    [self.interactiveShow setValue:configuration forKey:@"configuration"];
    [self.interactiveHidden setValue:configuration forKey:@"configuration"];
}

#pragma mark -UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [DrawerTransition transitionWithType:DrawerTransitiontypeShow animationType:_animationType configuration:_configuration];
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [DrawerTransition transitionWithType:DrawerTransitiontypeHidden animationType:_animationType configuration:_configuration];
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.interactiveShow.interacting ? self.interactiveShow : nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.interactiveHidden.interacting ? self.interactiveHidden : nil;
}

@end
