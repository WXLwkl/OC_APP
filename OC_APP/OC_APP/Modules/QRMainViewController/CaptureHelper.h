//
//  CaptureHelper.h
//  OC_APP
//
//  Created by xingl on 2017/10/19.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^DidOutputSampleBufferBlock)(CMSampleBufferRef sampleBuffer);

@interface CaptureHelper : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>

- (void)setDidOutputSampleBufferHandle:(DidOutputSampleBufferBlock)didOutputSampleBuffer;

- (void)showCaptureOnView:(UIView *)preview;

@end
