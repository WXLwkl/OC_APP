//
//  XLMotionManager.h
//  OC_APP
//
//  Created by xingl on 2018/9/20.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol XLMotionManagerDeviceOrientationDelegate<NSObject>

- (void)motionManagerDeviceOrientation:(UIDeviceOrientation)deviceOrientation;

@end

@interface XLMotionManager : NSObject

@property (nonatomic , assign) UIDeviceOrientation deviceOrientation;
@property (nonatomic , assign) AVCaptureVideoOrientation videoOrientation;
@property (nonatomic ,   weak) id<XLMotionManagerDeviceOrientationDelegate> delegate;

SingletonInterface(Manager);

/** 开始方向监测 */
- (void)startDeviceMotionUpdates;

/** 结束方向监测 */
- (void)stopDeviceMotionUpdates;

/** 设备取向 */
- (AVCaptureVideoOrientation)currentVideoOrientation;
@end
