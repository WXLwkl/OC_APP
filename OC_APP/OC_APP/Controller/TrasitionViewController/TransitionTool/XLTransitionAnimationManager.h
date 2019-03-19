//
//  XLTransitionAnimationManager.h
//  OC_APP
//
//  Created by xingl on 2019/3/8.
//  Copyright © 2019 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTransitionAnimationManager : NSObject<UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>

/** 转场动画的时间 默认为0.5s */
@property (nonatomic,assign) NSTimeInterval duration;

/** 入场动画 */
- (void)setToAnimation:(id<UIViewControllerContextTransitioning>)contextTransition;
/** 退场动画 */
- (void)setBackAnimation:(id<UIViewControllerContextTransitioning>)contextTransition;

@end

NS_ASSUME_NONNULL_END
