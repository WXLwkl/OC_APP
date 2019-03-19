//
//  PushPopTransitionAnimatior.h
//  OC_APP
//
//  Created by xingl on 2019/3/7.
//  Copyright © 2019 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PushPopAnimationType) {
    PushPopAnimationTypePush,
    PushPopAnimationTypePop
};

@interface PushPopTransitionAnimatior : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) PushPopAnimationType transitionType;

@end

NS_ASSUME_NONNULL_END
