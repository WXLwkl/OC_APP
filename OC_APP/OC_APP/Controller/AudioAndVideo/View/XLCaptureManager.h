//
//  AVCaptureManager.h
//  OC_APP
//
//  Created by xingl on 2018/6/22.
//  Copyright © 2018年 兴林. All rights reserved.
//

//video
#define RECORD_MAX_TIME 8.0           //最长录制时间
#define TIMER_INTERVAL 0.05         //计时器刷新频率
#define VIDEO_FOLDER @"videoFolder" //视频录制存放文件夹

#import <Foundation/Foundation.h>
/** 闪光灯状态 */
typedef NS_ENUM(NSInteger, XLFlashState) {
    XLFlashStateClose = 0,
    XLFlashStateOpen,
    XLFlashStateAuto
};
/** 录制状态 */
typedef NS_ENUM(NSInteger, XLRecordState) {
    XLRecordStateInit = 0,
    XLRecordStateRecording,
    XLRecordStatePause,
    XLRecordStateFinish
};


@protocol XLCaptureManagerDelegate <NSObject>

- (void)updateFlashState:(XLFlashState)state;
- (void)updateRecordingProgress:(CGFloat)progress;
- (void)updateRecordState:(XLRecordState)recordState;

@end

@interface XLCaptureManager : NSObject

@property (nonatomic, weak) id<XLCaptureManagerDelegate> delegate;
@property (nonatomic, assign) XLRecordState recordState;
@property (nonatomic, strong, readonly) NSURL *videoUrl;

- (instancetype)initWithSuperView:(UIView *)superView;

- (void)turnCameraAction;
- (void)switchflash;
- (void)startRecord;
- (void)stopRecord;
- (void)reset;


@end
