//
//  XLVideoRecorder.h
//  OC_APP
//
//  Created by xingl on 2018/9/18.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol XLVideoRecorderDelegate <NSObject>

- (void)recordProgress:(CGFloat)progress;

@end

@interface XLVideoRecorder : NSObject

/** 正在录制 */
@property (nonatomic, assign, readonly) BOOL isCapturing;

/** 是否暂停 */
@property (nonatomic, assign, readonly) BOOL isPaused;

/** 当前录制时间 */
@property (nonatomic, assign, readonly) CGFloat currentRecordTime;
/** 捕捉图像 */
@property (nonatomic, readonly, getter=isRunning) BOOL isRunning;
/** 录制最长时间 */
@property (nonatomic, assign) CGFloat maxRecordTime;

@property (nonatomic,   weak) id<XLVideoRecorderDelegate> delegate;
/** 视频路径 */
@property (nonatomic, copy) NSString *videoPath;


SingletonInterface(VideoRecorder);

//+ (XLVideoRecorder *)sharedVideoRecorder;

/**
 捕获到的视频呈现的layer
 @return AVCaptureVideoPreviewLayer
 */
- (AVCaptureVideoPreviewLayer *)previewLayer;

/**
 拍照
 @param callback 返回图片
 */
- (void)takePhoto:(void(^)(UIImage *image))callback;

/** 开启摄像头 */
- (void)startSession;
/** 关闭摄像头 */
- (void)stopSession;

/** 开始视频捕捉 */
- (void)startCapture;
/** 暂停视频捕捉 */
- (void)pauseCapture;
/** 继续视频捕捉 */
- (void)resumeCapture;
/**
 停止录制
 
 @param isSuccess 是否是成功的录制操作
 @param handler 返回视频第一帧图像和视频在磁盘中的路径
 */
- (void)stopCaptureWithStatus:(BOOL)isSuccess handler:(void (^)(UIImage *movieImage,NSString *path))handler;

/** 切换摄像头 */
- (void)turnCameraAction;
/** 闪光灯 */
- (void)switchflash;

/** 设置缩放比例 */
- (BOOL)setScaleFactor:(CGFloat)factor;
/**
 设置对焦点和曝光度
 
 @param focusMode 对焦模式
 @param exposureMode 曝光模式
 @param point 点击的位置
 */
- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode point:(CGPoint)point;

/**
 将mov的视频转成mp4
 
 @param mediaURL 视频地址
 @param handler 返回视频第一帧图像和视频在磁盘中的路径
 */
- (void)changeMovToMp4:(NSURL *)mediaURL dataBlock:(void (^)(UIImage *movieImage,NSString *path))handler;

@end
