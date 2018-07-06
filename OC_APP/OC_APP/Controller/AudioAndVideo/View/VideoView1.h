//
//  VideoView1.h
//  OC_APP
//
//  Created by xingl on 2018/6/25.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLCaptureManager1.h"

@protocol VideoView1Delegate <NSObject>

- (void)dismissVC;
- (void)recordFinishWithvideoUrl:(NSURL *)videoUrl;

@end

@interface VideoView1 : UIView


@property (nonatomic, strong, readonly) XLCaptureManager1 *manager;
@property (nonatomic, weak) id<VideoView1Delegate> delegate;

- (void)reset;

@end
