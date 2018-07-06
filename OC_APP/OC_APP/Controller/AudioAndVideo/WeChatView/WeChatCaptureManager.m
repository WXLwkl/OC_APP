//
//  WeChatCaptureManager.m
//  OC_APP
//
//  Created by xingl on 2018/6/27.
//  Copyright © 2018年 兴林. All rights reserved.
//

#define TIMER_INTERVAL 0.01f                 // 定时器记录视频间隔
#define VIDEO_RECORDER_MAX_TIME 10.0f        // 视频最大时长 (单位/秒)
#define VIDEO_RECORDER_MIN_TIME 1.0f         // 最短视频时长 (单位/秒)
#define DEFAULT_VIDEO_ZOOM_FACTOR 3.0f       // 默认放大倍数

#import "WeChatCaptureManager.h"
#import <AVFoundation/AVFoundation.h>

#import <CoreMotion/CoreMotion.h>

#import "XLTools.h"
#import "FileManager.h"

@interface WeChatCaptureManager ()<AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIView *superView;

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) dispatch_queue_t videoQueue;

@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong) AVCaptureDeviceInput *audioInput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoOutput;
@property (nonatomic, strong) AVCaptureAudioDataOutput *audioOutput;
@property (nonatomic, strong) AVCaptureStillImageOutput *captureStillImageOutput;        //照片输出流
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewlayer;


@property (nonatomic, strong) AVAssetWriter *assetWriter;
@property (nonatomic, strong) AVAssetWriterInput *assetWriterVideoInput;
@property (nonatomic, strong) AVAssetWriterInput *assetWriterAudioInput;
@property (nonatomic, assign) BOOL canWrite;

@property (nonatomic, assign) BOOL isRotatingCamera;  // 正在旋转摄像头

//捏合缩放摄像头
@property (nonatomic,assign) CGFloat beginGestureScale;   // 记录开始的缩放比例
@property (nonatomic,assign) CGFloat effectiveScale;      // 最后的缩放比例


@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, assign) UIDeviceOrientation shootingOrientation; // 拍摄中的手机方向


@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat recordTime;

@property (nonatomic, strong) NSURL   *videoURL;   // 视频文件地址
@property (nonatomic, strong) UIImage *finalImage; // 图片


@property (nonatomic, strong) UIImageView *focusCursor; //聚焦光标

@end

@implementation WeChatCaptureManager

- (void)dealloc {
    NSLog(@"移除-----");
}
#pragma mark - public Methods
- (instancetype)initWithSuperView:(UIView *)superView {
    self = [super init];
    if (self) {
        _superView = superView;
        [self setup];
        [self configDefault];
    }
    return self;
}

- (void)configDefault {
    _isRotatingCamera = NO;
    _canWrite = NO;
    _recordTime = 0;
    
    _beginGestureScale = 1.0f;
    _effectiveScale = 1.0f;
}

- (void)turnCameraAction {
    
    if (_isRotatingCamera) return;
    _isRotatingCamera = YES;
    
    AVCaptureDevice *currentDevice = [self.videoInput device];
    AVCaptureDevicePosition currentPosition = [currentDevice position];
    AVCaptureDevice *toChangeDevice;
    AVCaptureDevicePosition toChangePosition = AVCaptureDevicePositionFront;
    if (currentPosition == AVCaptureDevicePositionUnspecified || currentPosition == AVCaptureDevicePositionFront) {
        toChangePosition = AVCaptureDevicePositionBack;
    }
    toChangeDevice = [self getCameraDeviceWithPosition:toChangePosition];
    AVCaptureDeviceInput *toChangeDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:toChangeDevice error:nil];
    
    // 更改会话的配置前 一定要先开启配置，配置完成后提交配置更改
    [self.session beginConfiguration];
    //移除原有输入对象
    [self.session removeInput:self.videoInput];
    if ([self.session canAddInput:toChangeDeviceInput]) {
        [self.session addInput:toChangeDeviceInput];
        self.videoInput = toChangeDeviceInput;
    }
    // 提交配置
    [self.session commitConfiguration];
    _isRotatingCamera = NO;
}
- (void)switchflash {
    NSLog(@"闪光灯");
}

- (void)takePhotoWithFinalImage:(void(^)(UIImage *image))finalImageBlock {
    [self stopUpdateAccelerometer]; // 关闭监听
    AVCaptureConnection *captureConnection = [self.captureStillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    [self.captureStillImageOutput captureStillImageAsynchronouslyFromConnection:captureConnection completionHandler:^(CMSampleBufferRef  _Nullable imageDataSampleBuffer, NSError * _Nullable error) {
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [UIImage imageWithData:imageData];
        UIImage *finalImage = [self modifyImage:image];
        finalImageBlock(finalImage);
    }];
}

- (void)startRecord {
    self.recordState = WeChatRecordStateRecording;
    [self stopUpdateAccelerometer];
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        NSURL *url = [NSURL fileURLWithPath:[weakSelf createVideoFilePath]];
        strongSelf.videoURL = url;
        [strongSelf setupWriter];
        [strongSelf startTimer];
    });
    
}
- (void)stopRecord {
    
    if (_recordTime < VIDEO_RECORDER_MIN_TIME) return [self reset];
    
    if (self.recordState == WeChatRecordStateRecording) {
        
        [self stopTimer];
        [self stopSession];
        __weak typeof(self) weakSelf = self;
        if (weakSelf.assetWriter && weakSelf.assetWriter.status == AVAssetWriterStatusWriting) {
            [weakSelf.assetWriter finishWritingWithCompletionHandler:^{
                weakSelf.canWrite = NO;
                weakSelf.assetWriter = nil;
                weakSelf.assetWriterVideoInput = nil;
                weakSelf.assetWriterAudioInput = nil;
            }];
        }
        self.recordState = WeChatRecordStateFinish;
    }
}
- (void)reset {
    
    self.recordState = WeChatRecordStateInit;
    _recordTime = 0;
    _canWrite = NO;
    [self startSession];
    [self startUpdataAccelerometer];
}

- (void)setRecordState:(WeChatRecordState)recordState {
    if (_recordState != recordState) {
        _recordState = recordState;
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateRecordState:)]) {
            [self.delegate updateRecordState:_recordState];
        }
    }
}

#pragma mark - 私有
- (void)setup {
    [self setupInit];
    [self setupVideo];
    [self setupAudio];
    [self setupCaptureStillImageOutput];
    [self setupPreviewLayer];
    [self startSession];
    
    [self setupFocus]; // 增加焦点
    [self setupZoom];  // 变焦
    [self startUpdataAccelerometer];
}

- (void)setupInit {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBack) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    [self clearFile];
    self.recordState = WeChatRecordStateInit;
}

- (void)setupVideo {
    AVCaptureDevice *captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
    if (!captureDevice) return NSLog(@"获取后置摄像头时出问题");
    NSError *error = nil;
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if (error) return NSLog(@"获取视频设备输入时失败，原因：%@", error);
    if ([self.session canAddInput:self.videoInput])
        [self.session addInput:self.videoInput];
    
    self.videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    self.videoOutput.alwaysDiscardsLateVideoFrames = YES;
    [self.videoOutput setSampleBufferDelegate:self queue:self.videoQueue];
    if ([self.session canAddOutput:self.videoOutput]) {
        [self.session addOutput:self.videoOutput];
    }
}

- (void)setupAudio {
    NSError *error = nil;
    self.audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio] error:&error];
    if (error) {
        return NSLog(@"获取音频输入设备时出错，原因：%@", error);
    }
    if ([self.session canAddInput:self.audioInput])
        [self.session addInput:self.audioInput];

    self.audioOutput = [[AVCaptureAudioDataOutput alloc] init];
    [self.audioOutput setSampleBufferDelegate:self queue:self.videoQueue];
    if ([self.session canAddOutput:self.audioOutput])
        [self.session addOutput:self.audioOutput];
}

- (void)setupCaptureStillImageOutput {
    self.captureStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = @{
                                     AVVideoCodecKey:AVVideoCodecJPEG
                                     };
    [self.captureStillImageOutput setOutputSettings:outputSettings];
    if ([self.session canAddOutput:self.captureStillImageOutput]) {
        [self.session addOutput:self.captureStillImageOutput];
    }
}

- (void)setupPreviewLayer {
    
    self.previewlayer.frame = [UIScreen mainScreen].bounds;
    [_superView.layer insertSublayer:self.previewlayer atIndex:0];
}

- (void)setupFocus {
    [self.superView addSubview:self.focusCursor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen:)];
    [self.superView addGestureRecognizer:tapGesture];
}

- (void)tapScreen:(UITapGestureRecognizer *)tapGesture {
    CGPoint point = [tapGesture locationInView:self.superView];
    // 将UI坐标转化为摄像头坐标
    CGPoint cameraPoint = [self.previewlayer captureDevicePointOfInterestForPoint:point];
    [self setFocusCursorWithPoint:point];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:(AVCaptureExposureModeAutoExpose) atPoint:cameraPoint];
}

- (void)setupZoom {
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinchGesture.delegate = self;
    [self.superView addGestureRecognizer:pinchGesture];
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchGesture {
    
    BOOL allTouchesAreOnTheCaptureVideoPreviewLayer = YES;
    
    NSUInteger numTouches = [pinchGesture numberOfTouches];
    
    for (NSInteger i = 0; i < numTouches; i++) {
        CGPoint location = [pinchGesture locationOfTouch:i inView:self.superView];
        CGPoint convertedLocation = [self.previewlayer convertPoint:location fromLayer:self.previewlayer.superlayer];
        if (![self.previewlayer containsPoint:convertedLocation]) {
            allTouchesAreOnTheCaptureVideoPreviewLayer = NO;
            break;
        }
    }
    if (allTouchesAreOnTheCaptureVideoPreviewLayer) {
        CGFloat videoMaxZoomFactor = self.videoInput.device.activeFormat.videoMaxZoomFactor;
        CGFloat maxScaleAndCropFactor = videoMaxZoomFactor < DEFAULT_VIDEO_ZOOM_FACTOR ? videoMaxZoomFactor : DEFAULT_VIDEO_ZOOM_FACTOR;
        CGFloat currentScale = self.beginGestureScale * pinchGesture.scale;
        if ((currentScale > 1.0f) && (currentScale < maxScaleAndCropFactor)) {
            
            self.effectiveScale = self.beginGestureScale * pinchGesture.scale;
            if (self.effectiveScale < videoMaxZoomFactor && self.effectiveScale > 1.0f ) {
                [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
                    [captureDevice rampToVideoZoomFactor:self.effectiveScale withRate:10.0f];
                }];
            }
        }
    }
}

/** 开启会话 */
- (void)startSession {
    if (![self.session isRunning]) {
        [self.session startRunning];
    }
}

/** 停止会话 */
- (void)stopSession {
    if ([self.session isRunning]) {
        [self.session stopRunning];
    }
}

#pragma mark - help Methods
/** 设置写入视频属性 */
- (void)setupWriter {
    if (self.videoURL == nil) return;
    _assetWriter = [AVAssetWriter assetWriterWithURL:self.videoURL fileType:AVFileTypeMPEG4 error:nil];
    // 写入视频大小
    NSInteger numPixels = kScreenWidth * kScreenHeight;
    //每像素比特
    CGFloat bitsPerPixel = 12.0;
    NSInteger bitsPerSecond = numPixels * bitsPerPixel;
    //码率和帧率
    NSDictionary *compressionProperties = @{
                                            AVVideoAverageBitRateKey : @(bitsPerSecond),
                                            AVVideoExpectedSourceFrameRateKey : @(15),
                                            AVVideoMaxKeyFrameIntervalKey : @(15),
                                            AVVideoProfileLevelKey : AVVideoProfileLevelH264BaselineAutoLevel
                                            };
    CGFloat width = kScreenHeight;
    CGFloat height = kScreenWidth;
    if (iPhoneX) {
        width = kScreenHeight - 146;
        height = kScreenWidth;
    }
    // 视频属性
    NSDictionary *videoCompressionSettings = @{
                                               AVVideoCodecKey : AVVideoCodecH264,
                                               AVVideoWidthKey : @(width * 2),
                                               AVVideoHeightKey : @(height * 2),
                                               AVVideoScalingModeKey : AVVideoScalingModeResizeAspectFill,
                                               AVVideoCompressionPropertiesKey : compressionProperties
                                               };
    _assetWriterVideoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoCompressionSettings];
    _assetWriterVideoInput.expectsMediaDataInRealTime = YES;

    if (self.shootingOrientation == UIDeviceOrientationLandscapeRight) {
        _assetWriterVideoInput.transform = CGAffineTransformMakeRotation(M_PI);
    } else if (self.shootingOrientation == UIDeviceOrientationLandscapeLeft) {
        _assetWriterVideoInput.transform = CGAffineTransformMakeRotation(0);
    } else if (self.shootingOrientation == UIDeviceOrientationPortraitUpsideDown) {
        _assetWriterVideoInput.transform = CGAffineTransformMakeRotation(3 * M_PI_2);
    } else {
        _assetWriterVideoInput.transform = CGAffineTransformMakeRotation(M_PI_2);
    }

    // 音频属性
    NSDictionary *audioCompressionSettings = @{
                                               AVEncoderBitRatePerChannelKey : @(28000),
                                               AVFormatIDKey : @(kAudioFormatMPEG4AAC),
                                               AVNumberOfChannelsKey : @(1),
                                               AVSampleRateKey : @(22050)
                                               };
    _assetWriterAudioInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:audioCompressionSettings];
    _assetWriterAudioInput.expectsMediaDataInRealTime = YES;

    if ([_assetWriter canAddInput:_assetWriterVideoInput]) {
        [_assetWriter addInput:_assetWriterVideoInput];
    }
    if ([_assetWriter canAddInput:_assetWriterAudioInput]) {
        [_assetWriter addInput:_assetWriterAudioInput];
    }
    _canWrite = NO;
}

- (void)startTimer {
    _recordTime = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
}
- (void)stopTimer {
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)setFocusCursorWithPoint:(CGPoint)point {
    self.focusCursor.center = point;
    self.focusCursor.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.focusCursor.alpha = 1.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.focusCursor.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusCursor.alpha = 0;
    }];
}

- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point {
    
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:point];
        }
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:point];
        }
    }];
}

/** 取得指定位置的摄像头 */
- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position {
    
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position] == position) return camera;
    }
    return nil;
}
/** 改变设备属性的统一操作方法 */
- (void)changeDeviceProperty:(void(^)(AVCaptureDevice *captureDevice))propertyChange {
    AVCaptureDevice *captureDevice = [self.videoInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:
    //调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    } else {
        NSLog(@"设置设备属性过程发送错误,错误信息:%@", error.localizedDescription);
    }
}

- (UIImage *)modifyImage:(UIImage *)image {
    UIImage *finalImage = nil;
    if (self.shootingOrientation == UIDeviceOrientationLandscapeRight) {
        finalImage = [self rotateImage:image withOrientation:UIImageOrientationDown];
    } else if (self.shootingOrientation == UIDeviceOrientationLandscapeLeft) {
        finalImage = [self rotateImage:image withOrientation:(UIImageOrientationUp)];
    } else if (self.shootingOrientation == UIDeviceOrientationPortraitUpsideDown) {
        finalImage = [self rotateImage:image withOrientation:(UIImageOrientationLeft)];
    } else {
        finalImage = [self rotateImage:image withOrientation:(UIImageOrientationRight)];
    }
    return finalImage;
}

/**
 截取指定时间的视频缩略图
 
 @param videoUrl 视频地址
 @param timeBySecond 时间点，秒
 @return 视频缩略图
 */
- (UIImage *)thumbnailImageRequestWithVideoUrl:(NSURL *)videoUrl timer:(CGFloat)timeBySecond {
    if (self.videoURL == nil) return nil;
    AVURLAsset *urlAsset = [AVURLAsset assetWithURL:videoUrl];
    // 创建AVAssetImageGenerator
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    NSError *error = nil;
    // CMTime是表示视频时间信息的结构体 第一个参数表示视频第几秒，第二个参数表示每秒帧数。(如果要获得某一秒的第几帧可以使用CMTimeMake方法)
    CMTime requestTime = CMTimeMakeWithSeconds(timeBySecond, 10);
    CMTime actualTime;
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:requestTime actualTime:&actualTime error:&error];
    if (error) {
        NSLog(@"获取视频缩略图时发生错误，错误原因：%@", error.localizedDescription);
        return nil;
    }
    CMTimeShow(actualTime);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);

    UIImage *finalImage = nil;
    if (self.shootingOrientation == UIDeviceOrientationLandscapeRight) {
        finalImage = [self rotateImage:image withOrientation:UIImageOrientationDown];
    } else if (self.shootingOrientation == UIDeviceOrientationLandscapeLeft) {
        finalImage = [self rotateImage:image withOrientation:UIImageOrientationUp];
    } else if (self.shootingOrientation == UIDeviceOrientationPortraitUpsideDown) {
        finalImage = [self rotateImage:image withOrientation:UIImageOrientationLeft];
    } else {
        finalImage = [self rotateImage:image withOrientation:UIImageOrientationRight];
    }
    return finalImage;
}


/**
 截取视频
 
 @param videoUrl 要截取的视频地址
 @param startTime 开始时间
 @param endTime 结束时间
 @param completionHandle completionHandle
 */
- (void)cropWithVideoUrlStr:(NSURL *)videoUrl start:(CGFloat)startTime end:(CGFloat)endTime completion:(void (^)(NSURL *outputURL, Float64 videoDuration, BOOL isSuccess))completionHandle {

    AVURLAsset *asset =[[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    // 视频总时长
    Float64 duration = CMTimeGetSeconds(asset.duration);
    if (duration > VIDEO_RECORDER_MAX_TIME) {
        duration = VIDEO_RECORDER_MAX_TIME;
    }
    startTime = 0;
    endTime = duration;

    NSString *outputFilePath = [self createVideoFilePath];
    NSURL *outputFileUrl = [NSURL fileURLWithPath:outputFilePath];

    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:asset];
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetPassthrough];
        NSURL *outputURL = outputFileUrl;
        exportSession.outputURL = outputURL;
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = YES;

        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch (exportSession.status) {
                case AVAssetExportSessionStatusFailed: {
                    NSLog(@"合成失败：%@", exportSession.error.description);
                    completionHandle(outputURL, endTime, NO);
                }
                    break;
                case AVAssetExportSessionStatusCancelled:
                    completionHandle(outputURL, endTime, NO);
                    break;
                case AVAssetExportSessionStatusCompleted:
                    completionHandle(outputURL, endTime, YES);
                    break;
                default:
                    completionHandle(outputURL, endTime, NO);
                    break;
            }
        }];
    }
}


- (UIImage *)rotateImage:(UIImage *)image withOrientation:(UIImageOrientation)orientation {
    double rotate = 0.0;
    CGRect rect;
    CGFloat translateX = 0;
    CGFloat translateY = 0;
    CGFloat scaleX = 1.0;
    CGFloat scaleY = 1.0;
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width / rect.size.height;
            scaleX = rect.size.height / rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width / rect.size.height;
            scaleX = rect.size.height / rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = - rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(contextRef, 0.0, rect.size.height);
    CGContextScaleCTM(contextRef, 1.0, -1.0);
    CGContextRotateCTM(contextRef, rotate);
    CGContextTranslateCTM(contextRef, translateX, translateY);
    CGContextScaleCTM(contextRef, scaleX, scaleY);
    
    CGContextDrawImage(contextRef, rect, image.CGImage);
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

- (void)updateProgress {
    
    if (self.recordState != WeChatRecordStateRecording) return [self stopTimer];
    if (_recordTime >= VIDEO_RECORDER_MAX_TIME) return [self stopRecord];
    
    _recordTime += TIMER_INTERVAL;
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateRecordingProgress:)]) {
        [self.delegate updateRecordingProgress:_recordTime/VIDEO_RECORDER_MAX_TIME * 1.0];
    }
}


// 创建视频文件路径
- (NSString *)createVideoFilePath {
    NSString *videoName = [NSString stringWithFormat:@"%@.mp4", [NSUUID UUID].UUIDString];
    NSString *path = [[self videoFolder] stringByAppendingPathComponent:videoName];
    return path;
}
//清空文件夹
- (void)clearFile {
    [FileManager removeItemAtPath:[self videoFolder]];
}
//存放视频的文件夹
- (NSString *)videoFolder {
    NSString *cacheDir = [FileManager cachesDir];
    NSString *direc = [cacheDir stringByAppendingPathComponent:@"videoFolder"];
    if (![FileManager isExistsAtPath:direc]) {
        [FileManager createDirectoryAtPath:direc];
    }
    return direc;
}

#pragma mark - notification
- (void)enterBack {
    //    self.videoUrl = nil;
    //    [self.session stopRunning];
    //    [self.writeManager destroyWrite];
}

- (void)becomeActive {
    [self reset];
}

#pragma mark - 重力感应
/** 开始监听屏幕方向 */
- (void)startUpdataAccelerometer {
    if ([self.motionManager isAccelerometerAvailable]) {
        // 回调会一直调用，建议获取到就调用下面的停止方法，需要再重新开始，当然如果需求是实时不间断的话可以等页面离开后再stop
        [self.motionManager setAccelerometerUpdateInterval:1.0];
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            double x = accelerometerData.acceleration.x;
            double y = accelerometerData.acceleration.y;
//            NSLog(@"x=: %f, y=: %f", x, y);
            if ((fabs(y) + 0.1f) >= fabs(x)) {
                if (y >= 0.1f) {
                    NSLog(@"Down");
                    _shootingOrientation = UIDeviceOrientationPortraitUpsideDown;
                } else {
                    NSLog(@" 1 Portrait");
                    _shootingOrientation = UIDeviceOrientationPortrait;
                }
            } else {
                if (x >= 0.1f) {
                    NSLog(@"Right");
                    _shootingOrientation = UIDeviceOrientationLandscapeRight;
                } else {
                    NSLog(@"Left");
                    _shootingOrientation = UIDeviceOrientationLandscapeLeft;
                }
            }
        }];
    }
}
/** 停止监听屏幕方向 */
- (void)stopUpdateAccelerometer {
    if ([self.motionManager isAccelerometerActive]) {
        [self.motionManager stopAccelerometerUpdates];
        _motionManager = nil;
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate && AVCaptureAudioDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if (_isRotatingCamera) return;
    @autoreleasepool {
        if (connection == [self.videoOutput connectionWithMediaType:AVMediaTypeVideo]) {
            @synchronized (self) {
                if (self.recordState == WeChatRecordStateRecording) {
                    [self appendSampleBuffer:sampleBuffer ofMediaType:AVMediaTypeVideo];
                }
            }
        }
        if (connection == [self.audioOutput connectionWithMediaType:AVMediaTypeAudio]) {
            @synchronized (self) {
                if (self.recordState == WeChatRecordStateRecording) {
                    [self appendSampleBuffer:sampleBuffer ofMediaType:AVMediaTypeAudio];
                }
            }
        }
    }
}
/** 写入数据 */
- (void)appendSampleBuffer:(CMSampleBufferRef)sampleBuffer ofMediaType:(NSString *)mediaType {
    if (sampleBuffer == NULL) return NSLog(@"sampleBuffer 不能为空");

    @autoreleasepool {
        if (!self.canWrite && mediaType == AVMediaTypeVideo) {
            [self.assetWriter startWriting];
            [self.assetWriter startSessionAtSourceTime:CMSampleBufferGetPresentationTimeStamp(sampleBuffer)];
            self.canWrite = YES;
        }
        // 写入视频数据
        if (mediaType == AVMediaTypeVideo) {
            if (self.assetWriterVideoInput.readyForMoreMediaData) {
                BOOL success = [self.assetWriterVideoInput appendSampleBuffer:sampleBuffer];
                if (!success) {
                    @synchronized (self) {
                        [self stopRecord];
                    }
                }
            }
        }
        // 写入音频数据
        if (mediaType == AVMediaTypeAudio) {
            if (self.assetWriterAudioInput.readyForMoreMediaData) {
                BOOL success = [self.assetWriterAudioInput appendSampleBuffer:sampleBuffer];
                if (!success) {
                    @synchronized (self) {
                        [self stopRecord];
                    }
                }
            }
        }
    }
}

#pragma mark - lazy load
- (AVCaptureSession *)session {
    
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
        if ([_session canSetSessionPreset:AVCaptureSessionPresetHigh]) {//设置分辨率
            _session.sessionPreset=AVCaptureSessionPresetHigh;
        }
    }
    return _session;
}

- (dispatch_queue_t)videoQueue {
    if (!_videoQueue) {
        _videoQueue = dispatch_queue_create("com.xingl.Camera", DISPATCH_QUEUE_SERIAL); // dispatch_get_main_queue();
    }
    
    return _videoQueue;
}

- (AVCaptureVideoPreviewLayer *)previewlayer {
    if (!_previewlayer) {
        _previewlayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        _previewlayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _previewlayer;
}

- (CMMotionManager *)motionManager {
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    return _motionManager;
}

/** 聚焦图片 */
- (UIImageView *)focusCursor {
    if (!_focusCursor) {
        _focusCursor = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
        _focusCursor.image = [UIImage imageNamed:@"focusImg"];
        _focusCursor.alpha = 0;
    }
    return _focusCursor;
}

@end
