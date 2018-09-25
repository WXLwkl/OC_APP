//
//  XLVideoWriter.m
//  OC_APP
//
//  Created by xingl on 2018/9/19.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "XLVideoWriter.h"
#import "XLMotionManager.h"

@interface XLVideoWriter ()

@property (nonatomic, strong) AVAssetWriter *videoWriter;
@property (nonatomic, strong) AVAssetWriterInput *videoInput;
@property (nonatomic, strong) AVAssetWriterInput *audioInput;
@property (nonatomic,   copy) NSString *videoPath;

@end

@implementation XLVideoWriter

#pragma mark - output
+ (XLVideoWriter *)writerForPath:(NSString *)videoPath Height:(NSInteger)cy width:(NSInteger)cx channels:(int)ch samples:(Float64)rate {
    XLVideoWriter *writer = [[XLVideoWriter alloc] initWithPath:videoPath Height:cy width:cx channels:ch samples:rate];
    return writer;
}

- (instancetype)initWithPath:(NSString *)videoPath Height:(NSInteger)cy width:(NSInteger)cx channels:(int)ch samples:(Float64)rate {
    self = [super init];
    if (self) {
        self.videoPath = videoPath;
        [[NSFileManager defaultManager] removeItemAtPath:self.videoPath error:nil];
        NSURL *url = [NSURL fileURLWithPath:self.videoPath];
        NSError *error = nil;
        _videoWriter = [AVAssetWriter assetWriterWithURL:url fileType:AVFileTypeMPEG4 error:&error];
        NSParameterAssert(self.videoWriter);
        if(error) NSLog(@"error = %@", [error localizedDescription]);
        _videoWriter.shouldOptimizeForNetworkUse = YES; // 使其更适合网络播放
        // 初始化视频输入
        [self initVideoInputHeight:cy width:cx];
        if (rate != 0 && ch != 0) {
            [self initAudioInputChannels:ch samples:rate];
        }
    }
    return self;
}
// 完成视频录制时调用
- (void)finishWithCompletionHandler:(void (^)(void))handler {
    [_videoWriter finishWritingWithCompletionHandler:handler];
}
//通过这个方法写入数据
- (BOOL)writerFrame:(CMSampleBufferRef) sampleBuffer isVideo:(BOOL)isVideo {
    //数据是否准备写入
    if (CMSampleBufferDataIsReady(sampleBuffer)) {
        //写入状态为未知,保证视频先写入
        if (_videoWriter.status == AVAssetWriterStatusUnknown && isVideo) {
            //获取开始写入的CMTime
            CMTime startTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
            //开始写入
            [_videoWriter startWriting];
            [_videoWriter startSessionAtSourceTime:startTime];
        }
        //写入失败
        if (_videoWriter.status == AVAssetWriterStatusFailed) {
            NSLog(@"writer error %@", _videoWriter.error.localizedDescription);
            return NO;
        }
        //判断是否是视频
        if (isVideo) {
            //视频输入是否准备接受更多的媒体数据
            if (_videoInput.readyForMoreMediaData == YES) {
                //拼接数据
                [_videoInput appendSampleBuffer:sampleBuffer];
                return YES;
            }
        }else {
            //音频输入是否准备接受更多的媒体数据
            if (_audioInput.readyForMoreMediaData) {
                //拼接数据
                [_audioInput appendSampleBuffer:sampleBuffer];
                return YES;
            }
        }
    }
    return NO;
}
#pragma mark - pri
//初始化视频输入
- (void)initVideoInputHeight:(NSInteger)cy width:(NSInteger)cx {
    //录制视频的一些配置，分辨率，编码方式等等
    NSInteger numPixels = cx * cy;
    //每像素比特
    CGFloat bitsPerPixel = 6.0;
    NSInteger bitsPerSecond = numPixels * bitsPerPixel;
    
    // 码率和帧率设置
    NSDictionary *compressionProperties = @{AVVideoAverageBitRateKey:@(bitsPerSecond),
                                             AVVideoExpectedSourceFrameRateKey:@(30),
                                             AVVideoMaxKeyFrameIntervalKey:@(30),
                                             AVVideoProfileLevelKey:AVVideoProfileLevelH264BaselineAutoLevel};
    NSDictionary* settings = @{AVVideoCodecKey:AVVideoCodecH264,
                               AVVideoScalingModeKey:AVVideoScalingModeResizeAspectFill,
                               AVVideoWidthKey:@(cx),
                               AVVideoHeightKey:@(cy),
                               AVVideoCompressionPropertiesKey:compressionProperties};
    // 初始化视频写入
    _videoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:settings];
    _videoInput.transform = [self transformFromCurrentVideoOrientationToOrientation:AVCaptureVideoOrientationPortrait];
    // 表明输入是否应该调整其处理为实时数据源的数据
    _videoInput.expectsMediaDataInRealTime = YES;
    if ([_videoWriter canAddInput:_videoInput]) {
        [_videoWriter addInput:_videoInput];
    }
}

//初始化音频输入
- (void)initAudioInputChannels:(int)ch samples:(Float64)rate {
    //音频的一些配置包括音频各种这里为AAC,音频通道、采样率和音频的比特率
    NSDictionary *settings = @{AVEncoderBitRatePerChannelKey:@(28000),
                               AVFormatIDKey:@(kAudioFormatMPEG4AAC),
                               AVNumberOfChannelsKey:@(1),
                               AVSampleRateKey:@(22050) };
    //初始化音频写入类
    _audioInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:settings];
    //表明输入是否应该调整其处理为实时数据源的数据
    _audioInput.expectsMediaDataInRealTime = YES;
    //将音频输入源加入
    if ([_videoWriter canAddInput:_audioInput]) {
        [_videoWriter addInput:_audioInput];
    }
}

//旋转视频方向
- (CGAffineTransform)transformFromCurrentVideoOrientationToOrientation:(AVCaptureVideoOrientation)orientation {
    CGFloat orientationAngleOffset = [self angleOffsetFromPortraitOrientationToOrientation:orientation];
    CGFloat videoOrientationAngleOffset = [self angleOffsetFromPortraitOrientationToOrientation:[XLMotionManager sharedManager].videoOrientation];
    
    CGFloat angleOffset;
    angleOffset = orientationAngleOffset - videoOrientationAngleOffset;
    CGAffineTransform transform = CGAffineTransformMakeRotation(angleOffset);
    return transform;
}

- (CGFloat)angleOffsetFromPortraitOrientationToOrientation:(AVCaptureVideoOrientation)orientation {
    CGFloat angle = 0.0;
    switch (orientation) {
        case AVCaptureVideoOrientationPortrait:
            angle = 0.0;
            break;
        case AVCaptureVideoOrientationPortraitUpsideDown:
            angle = M_PI;
            break;
        case AVCaptureVideoOrientationLandscapeRight:
            angle = -M_PI_2;
            break;
        case AVCaptureVideoOrientationLandscapeLeft:
            angle = M_PI_2;
            break;
        default:
            break;
    }
    return angle;
}

@end
