//
//  XLTransitionAnimationManager.m
//  OC_APP
//
//  Created by xingl on 2019/3/8.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "XLTransitionAnimationManager.h"

#import "XLTransitionAnimation.h"

#import "XLInteractiveTransition.h"

@interface XLTransitionAnimationManager ()
/// 入场动画
@property (nonatomic, strong) XLTransitionAnimation *toTransitionAnimation;
/// 退场动画
@property (nonatomic, strong) XLTransitionAnimation *backTransitionAnimation;
/// 入场手势
@property (nonatomic, strong) XLInteractiveTransition *toInteractiveTransition;
/** 退场手势 */
@property (nonatomic, strong) XLInteractiveTransition *backInteractiveTransition;

/// 转场类型 push or pop
@property (nonatomic, assign) UINavigationControllerOperation operation;

@end

@implementation XLTransitionAnimationManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _duration = 0.5;
    }
    return self;
}

#pragma mark - 对外接口 为了定制 在子类中重写方法
- (void)setToAnimation:(id<UIViewControllerContextTransitioning>)contextTransition{}
- (void)setBackAnimation:(id<UIViewControllerContextTransitioning>)contextTransition{}

#pragma mark - UIViewControllerTransitioningDelegate
//非手势转场交互 for present
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.toTransitionAnimation;
}
//非手势转场交互 for dismiss
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.backTransitionAnimation;
}
//手势交互 for present
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.toInteractiveTransition.isPanGestureInteration ? self.toInteractiveTransition : nil;
}
//手势交互 for dismiss
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.backInteractiveTransition.isPanGestureInteration ? self.backInteractiveTransition : nil;
}

#pragma mark - UINavigationControllerDelegate
//非手势转场交互 for push/pop
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    _operation = operation;
    if (operation == UINavigationControllerOperationPush) {
        return self.toTransitionAnimation;
    } else if (operation == UINavigationControllerOperationPop) {
        return self.backTransitionAnimation;
    } else {
        return nil;
    }
}
//非手势转场交互 for push/pop
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if (_operation == UINavigationControllerOperationPush) {
        return self.toInteractiveTransition.isPanGestureInteration ? self.toInteractiveTransition : nil;
    } else {
        return self.backInteractiveTransition.isPanGestureInteration ? self.backInteractiveTransition : nil;
    }
}

#pragma mark - setter && getter
- (void)setToInteractiveTransition:(XLInteractiveTransition *)toInteractiveTransition {
    _toInteractiveTransition = toInteractiveTransition;
}

- (void)setBackInteractiveTransition:(XLInteractiveTransition *)backInteractiveTransition {
    _backInteractiveTransition = backInteractiveTransition;
}

- (XLTransitionAnimation *)toTransitionAnimation {
    if (!_toTransitionAnimation) {
        __weak typeof(self) weakSelf = self;
        _toTransitionAnimation = [[XLTransitionAnimation alloc] initWithDuration:self.duration];
        _toTransitionAnimation.animationBlock = ^(id<UIViewControllerContextTransitioning>  _Nonnull contextTransition) {
            [weakSelf setToAnimation:contextTransition];
        };
    }
    return _toTransitionAnimation;
}

- (XLTransitionAnimation *)backTransitionAnimation {
    if (!_backTransitionAnimation) {
        __weak typeof(self) weakSelf = self;
        _backTransitionAnimation = [[XLTransitionAnimation alloc] initWithDuration:self.duration];
        _backTransitionAnimation.animationBlock = ^(id<UIViewControllerContextTransitioning>  _Nonnull contextTransition) {
            [weakSelf setBackAnimation:contextTransition];
        };
    }
    return _backTransitionAnimation;
}

@end
