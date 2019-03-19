//
//  XLTransitionAnimation.m
//  OC_APP
//
//  Created by xingl on 2019/3/8.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "XLTransitionAnimation.h"

@interface XLTransitionAnimation ()

@property (nonatomic,assign) NSTimeInterval duration;

@end

@implementation XLTransitionAnimation

- (instancetype)initWithDuration:(NSTimeInterval)duration {
    self = [super init];
    if (self) {
        _duration = duration;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.animationBlock) {
        self.animationBlock(transitionContext);
    }
}

@end
