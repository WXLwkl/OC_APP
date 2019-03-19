//
//  UIViewController+XLTransmition.h
//  OC_APP
//
//  Created by xingl on 2019/3/11.
//  Copyright © 2019 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLInteractiveTransition.h"
#import "XLTransitionAnimationManager.h"

NS_ASSUME_NONNULL_BEGIN


@interface UIViewController (XLTransmition)

- (void)xl_pushViewController:(UIViewController *)viewController withAnimation:(XLTransitionAnimationManager *)transitionManager;

- (void)xl_presentViewController:(UIViewController *)viewController withAnimation:(XLTransitionAnimationManager *)transitionManager;

/** 注册入场手势 */
- (void)xl_registerToInteractiveTransitionWithDirection:(XLInteractiveTransitionGestureDirection)direction eventBlock:(dispatch_block_t)block;

/** 注册退场手势 */
- (void)xl_registerBackInteractiveTransitionWithDirection:(XLInteractiveTransitionGestureDirection)direction eventBlock:(dispatch_block_t)block;
@end

NS_ASSUME_NONNULL_END
