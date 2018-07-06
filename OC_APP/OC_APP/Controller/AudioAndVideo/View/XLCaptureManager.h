//
//  AVCaptureManager.h
//  OC_APP
//
//  Created by xingl on 2018/6/22.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>
/** 闪光灯状态 */
typedef NS_ENUM(NSInteger, FlashState) {
    FlashStateClose = 0,
    FlashStateOpen,
    FlashStateAuto
};
/** 录制状态 */
typedef NS_ENUM(NSInteger, RecordState) {
    RecordStateInit = 0,
    RecordStateRecording,
    RecordStatePause,
    RecordStateFinish
};


@protocol XLCaptureManagerDelegate <NSObject>

- (void)updateFlashState:(FlashState)state;
- (void)updateRecordingProgress:(CGFloat)progress;
- (void)updateRecordState:(RecordState)recordState;

@end

@interface XLCaptureManager : NSObject

@property (nonatomic, weak) id<XLCaptureManagerDelegate> delegate;

@end
