//
//  TBTransitionAnimator.h
//  OC_APP
//
//  Created by xingl on 2019/3/4.
//  Copyright © 2019 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TBTransitionAnimator : NSObject<UIViewControllerAnimatedTransitioning>

- (instancetype)initWithEdge:(UIRectEdge)edge;

@end

NS_ASSUME_NONNULL_END
