//
//  XLMotionManager.m
//  OC_APP
//
//  Created by xingl on 2018/9/20.
//  Copyright © 2018年 兴林. All rights reserved.
//

#define MOTION_UPDATE_INTERVAL 1/15.0

#import "XLMotionManager.h"
#import <CoreMotion/CoreMotion.h>

@interface XLMotionManager ()

@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation XLMotionManager

SingletonImplementation(Manager);

- (CMMotionManager *)motionManager {
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc]init];
        _motionManager.deviceMotionUpdateInterval = MOTION_UPDATE_INTERVAL;
    }
    return _motionManager;
}

- (void)startDeviceMotionUpdates {
    if (self.motionManager.deviceMotionAvailable) {
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            [self performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:motion waitUntilDone:YES];
        }];
    }
}

- (void)stopDeviceMotionUpdates {
    [self.motionManager stopDeviceMotionUpdates];
}

- (void)handleDeviceMotion:(CMDeviceMotion *)deviceMotion {
    double x = deviceMotion.gravity.x;
    double y = deviceMotion.gravity.y;
    
    if (fabs(y) >= fabs(x)) {
        if (y >= 0) {
            _deviceOrientation = UIDeviceOrientationPortraitUpsideDown;
            _videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
        } else {
            _deviceOrientation = UIDeviceOrientationPortrait;
            _videoOrientation = AVCaptureVideoOrientationPortrait;
        }
    } else {
        if (x >= 0) {
            _deviceOrientation = UIDeviceOrientationLandscapeRight;
            _videoOrientation = AVCaptureVideoOrientationLandscapeRight;
        } else {
            _deviceOrientation = UIDeviceOrientationLandscapeLeft;
            _videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(motionManagerDeviceOrientation:)]) {
        [self.delegate motionManagerDeviceOrientation:_deviceOrientation];
    }
}

// 调整设备取向
- (AVCaptureVideoOrientation)currentVideoOrientation {
    AVCaptureVideoOrientation orientation;
    switch ([XLMotionManager sharedManager].deviceOrientation) {
        case UIDeviceOrientationPortrait:
            orientation = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationLandscapeRight:
            orientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            orientation = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        default:
            orientation = AVCaptureVideoOrientationLandscapeRight;
            break;
    }
    return orientation;
}

@end
