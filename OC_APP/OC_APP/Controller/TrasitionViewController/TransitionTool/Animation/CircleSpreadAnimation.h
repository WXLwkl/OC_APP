//
//  CircleSpreadAnimation.h
//  OC_APP
//
//  Created by xingl on 2019/3/11.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "XLTransitionAnimationManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface CircleSpreadAnimation : XLTransitionAnimationManager

- (id)initWithStartPoint:(CGPoint)point radius:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END
