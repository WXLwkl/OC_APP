//
//  AssetWriteManager.h
//  OC_APP
//
//  Created by xingl on 2018/6/25.
//  Copyright © 2018年 兴林. All rights reserved.
//

#define RECORD_MAX_TIME 8.0           //最长录制时间
#define TIMER_INTERVAL 0.05         //计时器刷新频率
#define VIDEO_FOLDER @"videoFolder" //视频录制存放文件夹

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

//录制状态，（这里把视频录制与写入合并成一个状态）
typedef NS_ENUM(NSInteger, LLRecordState) {
    LLRecordStateInit = 0,
    LLRecordStatePrepareRecording,
    LLRecordStateRecording,
    LLRecordStateFinish,
    LLRecordStateFail,
};

@protocol AssetWriteManagerDelegate <NSObject>

- (void)finishWriting;
- (void)updateWritingProgress:(CGFloat)progress;

@end

@interface AssetWriteManager : NSObject

@property (nonatomic, retain) __attribute__((NSObject)) CMFormatDescriptionRef outputVideoFormatDescription;
@property (nonatomic, retain) __attribute__((NSObject)) CMFormatDescriptionRef outputAudioFormatDescription;

@property (nonatomic, assign) LLRecordState writeState;
@property (nonatomic, weak) id<AssetWriteManagerDelegate> delegate;

- (instancetype)initWithURL:(NSURL *)URL;

- (void)startWrite;
- (void)stopWrite;
- (void)appendSampleBuffer:(CMSampleBufferRef)sampleBuffer ofMediaType:(NSString *)mediaType;
- (void)destroyWrite;

@end
