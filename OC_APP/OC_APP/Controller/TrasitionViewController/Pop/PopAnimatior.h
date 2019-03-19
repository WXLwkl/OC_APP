//
//  PopAnimatior.h
//  OC_APP
//
//  Created by xingl on 2019/3/8.
//  Copyright © 2019 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, PopAnimationType) {
    PopAnimationTypePresent = 0,
    PopAnimationTypeDismiss
};

@interface PopAnimatior : NSObject<UIViewControllerAnimatedTransitioning>

- (instancetype)initWithTransitionType:(PopAnimationType)transitionType;
@end

NS_ASSUME_NONNULL_END
