//
//  OpenDoorAnimation.m
//  OC_APP
//
//  Created by xingl on 2019/3/11.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "OpenDoorAnimation.h"

@implementation OpenDoorAnimation

- (void)setToAnimation:(id<UIViewControllerContextTransitioning>)contextTransition {
    UIViewController *toVC = [contextTransition viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [contextTransition viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [contextTransition containerView];
    
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    
    UIView *toView_snapView = [toView snapshotViewAfterScreenUpdates:YES];
    
    CGRect left_frame = CGRectMake(0, 0, CGRectGetWidth(fromView.frame)/2.0, CGRectGetHeight(fromView.frame));
    CGRect right_frame = CGRectMake(CGRectGetWidth(fromView.frame)/2.0, 0, CGRectGetWidth(fromView.frame)/2.0, CGRectGetHeight(fromView.frame));
    
    UIView *from_left_snapView = [fromView resizableSnapshotViewFromRect:left_frame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    UIView *from_right_snapView = [fromView resizableSnapshotViewFromRect:right_frame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    
    toView_snapView.layer.transform = CATransform3DMakeScale(0.7, 0.7, 1);
    from_left_snapView.frame = left_frame;
    from_right_snapView.frame = right_frame;
    
    [containerView addSubview:toView_snapView];
    [containerView addSubview:from_left_snapView];
    [containerView addSubview:from_right_snapView];
    
    fromView.hidden = YES;
    
    [UIView animateWithDuration:self.duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        from_left_snapView.frame = CGRectOffset(from_left_snapView.frame, -from_left_snapView.frame.size.width, 0);
        from_right_snapView.frame = CGRectOffset(from_right_snapView.frame, from_right_snapView.frame.size.width, 0);
        
        toView_snapView.layer.transform = CATransform3DIdentity;
    } completion:^(BOOL finished) {
        fromView.hidden = NO;
        [from_left_snapView removeFromSuperview];
        [from_right_snapView removeFromSuperview];
        [toView_snapView removeFromSuperview];
        
        if ([contextTransition transitionWasCancelled]) {
            [containerView addSubview:fromView];
        } else {
            [containerView addSubview:toView];
        }
        [contextTransition completeTransition:![contextTransition transitionWasCancelled]];
    }];
}

- (void)setBackAnimation:(id<UIViewControllerContextTransitioning>)contextTransition {
    UIViewController *toVc = [contextTransition viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVc = [contextTransition viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [contextTransition containerView];
    
    UIView *fromView = fromVc.view;
    UIView *toView = toVc.view;
    
    UIView *fromView_snapView = [fromView snapshotViewAfterScreenUpdates:NO];
    
    CGRect left_frame = CGRectMake(0, 0, CGRectGetWidth(toView.frame) / 2.0, CGRectGetHeight(toView.frame));
    CGRect right_frame = CGRectMake(CGRectGetWidth(toView.frame) / 2.0, 0, CGRectGetWidth(toView.frame) / 2.0, CGRectGetHeight(toView.frame));
    UIView *to_left_snapView = [toView resizableSnapshotViewFromRect:left_frame afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
    
    UIView *to_right_snapView = [toView resizableSnapshotViewFromRect:right_frame afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
    
    fromView_snapView.layer.transform = CATransform3DIdentity;
    
    to_left_snapView.frame = CGRectOffset(left_frame, -left_frame.size.width, 0);
    to_right_snapView.frame = CGRectOffset(right_frame, right_frame.size.width, 0);
    
    [containerView addSubview:fromView_snapView];
    [containerView addSubview:to_left_snapView];
    [containerView addSubview:to_right_snapView];
    
    fromView.hidden = YES;
    
    [UIView animateWithDuration:self.duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        //右移
        to_left_snapView.frame = CGRectOffset(to_left_snapView.frame, to_left_snapView.frame.size.width, 0);
        //左移
        to_right_snapView.frame = CGRectOffset(to_right_snapView.frame, -to_right_snapView.frame.size.width, 0);
        
        fromView_snapView.layer.transform = CATransform3DMakeScale(0.7, 0.7, 1);
        
    } completion:^(BOOL finished) {
        fromView.hidden = NO;
        [fromView removeFromSuperview];
        [to_left_snapView removeFromSuperview];
        [to_right_snapView removeFromSuperview];
        [fromView_snapView removeFromSuperview];
        
        if ([contextTransition transitionWasCancelled]) {
            [containerView addSubview:fromView];
        } else {
            [containerView addSubview:toView];
        }
        [contextTransition completeTransition:![contextTransition transitionWasCancelled]];
    }];
}

@end
