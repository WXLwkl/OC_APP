//
//  ImageTransitionAnimatior.h
//  OC_APP
//
//  Created by xingl on 2019/3/6.
//  Copyright © 2019 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TransitionType) {
    TransitionTypePresent = 0,//管理present动画
    TransitionTypeDissmiss,
    TransitionTypePush,
    TransitionTypePop,
};
@interface ImageTransitionAnimatior : NSObject<UIViewControllerAnimatedTransitioning>
//动画转场类型
@property (nonatomic,assign) TransitionType transitionType;

@end

NS_ASSUME_NONNULL_END
