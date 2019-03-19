//
//  XLTransitionAnimation.h
//  OC_APP
//
//  Created by xingl on 2019/3/8.
//  Copyright © 2019 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 GLTransitionAnimation 块
 
 @param contextTransition 将满足UIViewControllerContextTransitioning协议的对象传到管理内 在管理类对动画统一实现
 */
typedef void(^XLTransitionAnimationBlock)(id <UIViewControllerContextTransitioning> contextTransition);

@interface XLTransitionAnimation : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, copy) XLTransitionAnimationBlock animationBlock;

- (id)initWithDuration:(NSTimeInterval)duration;
@end

NS_ASSUME_NONNULL_END
