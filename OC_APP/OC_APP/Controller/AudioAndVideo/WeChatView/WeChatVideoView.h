//
//  WeChatVideoView.h
//  OC_APP
//
//  Created by xingl on 2018/6/27.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeChatCaptureManager.h"
@protocol WeChatVideoViewDelegate <NSObject>

@required
- (void)dismissVC;
@optional
- (void)takePhotoWithImage:(UIImage *)finalImage;
- (void)recordFinishWithvideoUrl:(NSURL *)videoUrl;

@end

@interface WeChatVideoView : UIView

@property (nonatomic, strong, readonly) WeChatCaptureManager *captureManager;
@property (nonatomic, weak) id<WeChatVideoViewDelegate> delegate;

- (void)reset;

@end
