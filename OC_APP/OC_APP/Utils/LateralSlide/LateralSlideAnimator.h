//
//  LateralSlideAnimator.h
//  cehua
//
//  Created by xingl on 2017/10/25.
//  Copyright © 2017年 xingl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LateralSlideConfiguration.h"
#import "InteractiveTransition.h"

@interface LateralSlideAnimator : NSObject <UIViewControllerTransitioningDelegate>

@property (nonatomic,strong) LateralSlideConfiguration *configuration;
@property (nonatomic,assign) DrawerAnimationType animationType;

- (instancetype)initWithConfiguration:(LateralSlideConfiguration *)configuration;

+ (instancetype)lateralSlideAnimatorWithConfiguration:(LateralSlideConfiguration *)configuration;

@end
