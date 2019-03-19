//
//  PushPopTransitionAnimatior.m
//  OC_APP
//
//  Created by xingl on 2019/3/7.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "PushPopTransitionAnimatior.h"
#import "PushPopTransitionViewController.h"
#import "TrasitionViewController.h"

@implementation PushPopTransitionAnimatior

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    switch (_transitionType) {
    case PushPopAnimationTypePush:
        [self pushAnimation:transitionContext];
        break;
            
    case PushPopAnimationTypePop:
        [self popAnimation:transitionContext];
        break;
    }
}

- (void)pushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    PushPopTransitionViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    TrasitionViewController *fromVC;

    if ([[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        fromVC = nav.viewControllers.lastObject;
    } else if ([[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tb = (UITabBarController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UINavigationController *nav = (UINavigationController *)tb.selectedViewController;
        fromVC = nav.viewControllers.lastObject;
    } else if ([[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] isKindOfClass:[UIViewController class]]) {
        fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    }
    
    UITableViewCell *cell = [fromVC.tableView cellForRowAtIndexPath:fromVC.currentIndexPath];
    
    UIView *containerView = [transitionContext containerView];
    
    UIView *imageViewCopy = [cell.imageView snapshotViewAfterScreenUpdates:NO];
    imageViewCopy.frame = [cell.imageView convertRect:cell.imageView.bounds toView:containerView];
    
    UIView *titleLabelCopy = [cell.detailTextLabel snapshotViewAfterScreenUpdates:NO];
    titleLabelCopy.frame = [cell.detailTextLabel convertRect:cell.detailTextLabel.bounds toView:containerView];
    
    // 设置动画前的歌控件状态
    cell.imageView.hidden = YES;
    cell.detailTextLabel.hidden = YES;
    toVC.imageView.hidden = YES;
    toVC.titleLabel.hidden = YES;
    
    //tempView 添加到containerView中，要保证在最上层，所以后添加
    [containerView addSubview:toVC.view];
    [containerView addSubview:imageViewCopy];
    [containerView addSubview:titleLabelCopy];
    
    //开始做动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0 usingSpringWithDamping:0.5  initialSpringVelocity: 1 / 0.5 options:0 animations:^{
                              imageViewCopy.frame = [toVC.imageView convertRect:toVC.imageView.bounds toView:containerView];
                              titleLabelCopy.frame = [toVC.titleLabel convertRect:toVC.titleLabel.bounds toView:containerView];
                              
                          } completion:^(BOOL finished) {
                              toVC.imageView.hidden = NO;
                              toVC.titleLabel.hidden = NO;
                              [titleLabelCopy removeFromSuperview];
                              [imageViewCopy removeFromSuperview];
                              //如果动画过渡取消了就标记不完成，否则才完成，这里可以直接写YES，如果有手势过渡才需要判断，必须标记，否则系统不会中断动画完成的部署，会出现无法交互之类的bug
                              [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                          }];
}

- (void)popAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    TrasitionViewController *toVC;
    PushPopTransitionViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    if ([[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        toVC = nav.viewControllers.lastObject;
    } else if ([[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey] isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tb = (UITabBarController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UINavigationController *nav = (UINavigationController *)tb.selectedViewController;
        toVC = nav.viewControllers.lastObject;
    } else if ([[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey] isKindOfClass:[UIViewController class]]) {
        toVC = (TrasitionViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    }
    
    //获取点击的cell
    UITableViewCell * cell = [toVC.tableView cellForRowAtIndexPath:toVC.currentIndexPath];
    
    UIView *containerView = [transitionContext containerView];
    
    //使用系统自带的snapshotViewAfterScreenUpdates:方法，参数为YES，代表视图的属性改变渲染完毕后截屏，参数为NO代表立刻将当前状态的视图截图
    UIView *imageViewCopy = [fromVC.imageView snapshotViewAfterScreenUpdates:NO];
    imageViewCopy.frame = [fromVC.imageView convertRect:fromVC.imageView.bounds toView:containerView];
    
    UIView *titleLabelCopy = [fromVC.titleLabel snapshotViewAfterScreenUpdates:NO];
    titleLabelCopy.frame = [fromVC.titleLabel convertRect:fromVC.titleLabel.bounds toView:containerView];
    
    //设置初始状态
    fromVC.imageView.hidden = YES;
    fromVC.titleLabel.hidden = YES;
    [containerView addSubview:toVC.view];
    
    //背景过渡视图
    UIView * bgView = [[UIView alloc] initWithFrame:fromVC.view.bounds];
    bgView.backgroundColor = [UIColor blackColor];
    [containerView addSubview:bgView];
    
    //imageViewCopy 添加到containerView中
    [containerView addSubview:imageViewCopy];
    [containerView addSubview:titleLabelCopy];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        imageViewCopy.frame = [cell.imageView convertRect:cell.imageView.bounds toView:containerView];
        titleLabelCopy.frame = [cell.detailTextLabel convertRect:cell.detailTextLabel.bounds toView:containerView];
        bgView.alpha = 0;
    } completion:^(BOOL finished) {
        //由于加入了手势必须判断
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if ([transitionContext transitionWasCancelled]) {
            //手势取消了，原来隐藏的imageView要显示出来
            fromVC.imageView.hidden = NO;
            fromVC.titleLabel.hidden = NO;
        }else{
            //手势成功，cell的imageView也要显示出来
            cell.imageView.hidden = NO;
            cell.detailTextLabel.hidden = NO;
        }
        
        //动画交互动作完成或取消后，移除临时动画文件
        [titleLabelCopy removeFromSuperview];
        [imageViewCopy removeFromSuperview];
        [bgView removeFromSuperview];
        
    }];
}
@end
