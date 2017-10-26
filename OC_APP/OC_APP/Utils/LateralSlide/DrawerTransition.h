//
//  DrawerTransition.h
//  cehua
//
//  Created by xingl on 2017/10/24.
//  Copyright © 2017年 xingl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LateralSlideConfiguration.h"

typedef NS_ENUM(NSUInteger,DrawerTransitiontype) {
    DrawerTransitiontypeShow = 0,
    DrawerTransitiontypeHidden
};

typedef NS_ENUM(NSUInteger,DrawerAnimationType) {
    DrawerAnimationTypeDefault = 0,
    DrawerAnimationTypeMask
};

@interface DrawerTransition : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithTransitionType:(DrawerTransitiontype)transitionType animationType:(DrawerAnimationType)animationType configuration:(LateralSlideConfiguration *)configuration;

+ (instancetype)transitionWithType:(DrawerTransitiontype)transitionType animationType:(DrawerAnimationType)animationType configuration:(LateralSlideConfiguration *)configuration;

@end

@interface MsakView : UIView<UIGestureRecognizerDelegate>

@end


UIKIT_EXTERN NSString *const LateralSlideAnimatorKey;
UIKIT_EXTERN NSString *const LateralSlideMaskViewKey;
UIKIT_EXTERN NSString *const LateralSlideInterativeKey;

UIKIT_EXTERN NSString *const LateralSlidePanNotication;
UIKIT_EXTERN NSString *const LateralSlideTapNotication;
