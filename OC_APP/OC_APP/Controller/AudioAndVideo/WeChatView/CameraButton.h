//
//  CameraButton.h
//  OC_APP
//
//  Created by xingl on 2018/6/27.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapEventBlock)(UITapGestureRecognizer *tapGestureRecognizer);
typedef void(^LongPressEventBlock)(UILongPressGestureRecognizer *longPressGestureRecognizer);

@interface CameraButton : UIView

@property (nonatomic, assign) CGFloat progressPercentage;

+ (instancetype)defaultCameraButton;

- (void)configureTapCameraButtonEventWithBlock:(TapEventBlock)tapEventBlock;

- (void)configureLongPressCameraButtonEventWithBlock:(LongPressEventBlock)longPressEventBlock;

/** 开始录制前的准备动画 */
- (void)startShootAnimationWithDuration:(NSTimeInterval)duration;
/** 结束录制动画 */
- (void)stopShootAnimationWithDuration:(NSTimeInterval)duration;

@end
