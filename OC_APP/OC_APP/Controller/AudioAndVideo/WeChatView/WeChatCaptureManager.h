//
//  WeChatCaptureManager.h
//  OC_APP
//
//  Created by xingl on 2018/6/27.
//  Copyright © 2018年 兴林. All rights reserved.
//


typedef NS_ENUM(NSInteger, WeChatRecordState) {
    WeChatRecordStateInit = 0,
    WeChatRecordStateRecording,
    WeChatRecordStatePause,
    WeChatRecordStateFinish
};

#import <Foundation/Foundation.h>

@protocol WeChatCaptureManagerDelegate <NSObject>

- (void)updateRecordingProgress:(CGFloat)progress;
- (void)updateRecordState:(WeChatRecordState)recordState;

@end

@interface WeChatCaptureManager : NSObject

@property (nonatomic, weak) id<WeChatCaptureManagerDelegate> delegate;

@property (nonatomic, assign) WeChatRecordState recordState;

@property (nonatomic, strong, readonly) NSURL *videoURL;

- (instancetype)initWithSuperView:(UIView *)superView;

- (void)turnCameraAction;
- (void)switchflash;

- (void)takePhotoWithFinalImage:(void(^)(UIImage *image))finalImageBlock;

- (void)startRecord;
- (void)stopRecord;

- (void)reset;

#pragma mark - 传感器
- (void)startUpdataAccelerometer;
- (void)stopUpdateAccelerometer;

@end
