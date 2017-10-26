//
//  InteractiveTransition.h
//  cehua
//
//  Created by xingl on 2017/10/25.
//  Copyright © 2017年 xingl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerTransition.h"

@interface InteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) BOOL interacting;
@property (nonatomic, weak) LateralSlideConfiguration *configuration;


+ (instancetype)interactiveWithTransitiontype:(DrawerTransitiontype)type;

- (instancetype)initWithTransitiontype:(DrawerTransitiontype)type;

- (void)addPanGestureForViewController:(UIViewController *)viewController;


@end
