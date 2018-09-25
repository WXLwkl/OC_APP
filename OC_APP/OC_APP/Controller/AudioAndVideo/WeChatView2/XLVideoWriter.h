//
//  XLVideoWriter.h
//  OC_APP
//
//  Created by xingl on 2018/9/19.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface XLVideoWriter : NSObject

@property (nonatomic, copy, readonly) NSString *videoPath;

/**
 XLVideoWriter遍历构造器
 
 @param videoPath 媒体存发路径
 @param cy   视频分辨率的高
 @param cx   视频分辨率的宽
 @param ch   音频通道
 @param rate 音频的采样比率
 @return     SGRecordEncoder实例
 */
+ (XLVideoWriter *)writerForPath:(NSString*)videoPath Height:(NSInteger)cy width:(NSInteger)cx channels:(int)ch samples:(Float64)rate;

- (instancetype)initWithPath:(NSString*)videoPath Height:(NSInteger)cy width:(NSInteger)cx channels:(int)ch samples:(Float64)rate;

/**
 完成视频录制时调用
 
 @param handler 完成的回调block
 */
- (void)finishWithCompletionHandler:(void (^)(void))handler;

/**
 写入数据
 
 @param sampleBuffer  写入的数据
 @param isVideo       是否写入的是视频
 @return              是否写入成功
 */
- (BOOL)writerFrame:(CMSampleBufferRef)sampleBuffer isVideo:(BOOL)isVideo;

@end
