//
//  NavOpenDoorTransitionAnimatior.h
//  OC_APP
//
//  Created by xingl on 2019/3/7.
//  Copyright © 2019 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, NavOpenDoorAnimationType) {
    NavOpenDoorAnimationTypePush,
    NavOpenDoorAnimationTypePop
};

@interface NavOpenDoorTransitionAnimatior : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) NavOpenDoorAnimationType transitionType;

@end

NS_ASSUME_NONNULL_END
