//
//  VideoView.h
//  OC_APP
//
//  Created by xingl on 2018/6/21.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLCaptureManager.h"

@protocol VideoViewDelegate <NSObject>

- (void)dismissVC;
- (void)recordFinishWithvideoUrl:(NSURL *)videoUrl;

@end

@interface VideoView : UIView

@property (nonatomic, strong, readonly) XLCaptureManager *captureManager;
@property (nonatomic, weak) id<VideoViewDelegate> delegate;

- (void)reset;

@end
