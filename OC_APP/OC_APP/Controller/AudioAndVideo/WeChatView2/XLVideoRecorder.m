//
//  XLVideoRecorder.m
//  OC_APP
//
//  Created by xingl on 2018/9/18.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "XLVideoRecorder.h"
#import "XLVideoWriter.h"
#import "XLMotionManager.h"

#define VIDEO_WIDTH 360
#define VIDEO_HEIGHT 640
#define MAX_TIME 10

@interface XLVideoRecorder ()<
    AVCaptureAudioDataOutputSampleBufferDelegate,
    AVCaptureVideoDataOutputSampleBufferDelegate,
    CAAnimationDelegate> {
    CMTime _timeOffset; // 录制的偏移CMTime
    CMTime _lastVideo;  // 记录上次视频数据的CMTime
    CMTime _lastAudio;  // 记录上次音频数据的CMTime
        
    NSInteger _cx; // 视频分辨的宽
    NSInteger _cy; // 视频分辨的高
    int _channels; // 音频通道
    Float64 _samplerate; // 音频采样率
}

@property (nonatomic, strong) XLVideoWriter *writer;

@property (nonatomic,   copy) dispatch_queue_t captureQueue;

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *videoCaptureDevice;

@property (nonatomic, strong) AVCaptureConnection *videoConnection; // 视频连接
@property (nonatomic, strong) AVCaptureConnection *audioConnection; // 音频连接

@property (nonatomic, strong) AVCaptureDeviceInput *videoDeviceInput; // 视频捕捉
@property (nonatomic, strong) AVCaptureDeviceInput *audioDeviceInput; // 音频捕捉

@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput; // 视频输出
@property (nonatomic, strong) AVCaptureAudioDataOutput *audioDataOutput; // 音频输出
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;//图片输出

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer; // 视频预览图层

@property (nonatomic, assign) BOOL isCapturing; //正在录制
@property (nonatomic, assign) BOOL isPaused; // 是否暂停
@property (nonatomic, assign) BOOL discont; // 是否中断

@property (nonatomic, assign) CMTime startTime;//开始录制的时间
@property (nonatomic, assign) CGFloat currentRecordTime;//当前录制时间

@end

@implementation XLVideoRecorder

SingletonImplementation(VideoRecorder);

#pragma mark - life
- (instancetype)init {
    self = [super init];
    if (self) {
        self.maxRecordTime = MAX_TIME;
    }
    return self;
}


#pragma mark - output

- (void)takePhoto:(void(^)(UIImage *image))callback {
    AVCaptureConnection *connection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (connection.isVideoOrientationSupported) {
        connection.videoOrientation = [XLMotionManager sharedManager].currentVideoOrientation;
    }
    id takePictureSuccess = ^(CMSampleBufferRef sampleBuffer, NSError *error) {
        if (sampleBuffer == NULL) return;
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:sampleBuffer];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        callback(image);
    };
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:takePictureSuccess];
}

// 开启摄像头
- (void)startSession {
    if (![self.session isRunning]) {
        self.startTime = CMTimeMake(0, 0);
        self.isCapturing = NO;
        self.isPaused = NO;
        self.discont = NO;
        [self.session startRunning];
    }
}

// 关闭摄像头
- (void)stopSession {
    _startTime = CMTimeMake(0, 0);
    if (_session) {
        [_session stopRunning];
    }
    [_writer finishWithCompletionHandler:^{
        NSLog(@"录制完成");
    }];
}

// 开始视频捕捉
- (void)startCapture {
    @synchronized (self) {
        if (!self.isCapturing) {
            NSLog(@"开始录制了");
            self.writer = nil;
            self.isPaused = NO;
            self.discont = NO;
            _timeOffset = CMTimeMake(0, 0);
            self.isCapturing = YES;
        }
    }
}
// 暂停视频捕捉
- (void)pauseCapture {
    @synchronized (self) {
        if (self.isCapturing) {
            NSLog(@"暂停录制");
            self.isPaused = YES;
            self.discont = YES;
        }
    }
}
// 继续视频捕捉
- (void)resumeCapture {
    @synchronized (self) {
        if (self.isPaused) {
            NSLog(@"继续录制");
            self.isPaused = NO;
        }
    }
}
// 停止录制
- (void)stopCaptureWithStatus:(BOOL)isSuccess handler:(void (^)(UIImage *movieImage,NSString *path))handler {
    @synchronized (self) {
        if (self.isCapturing) {
            NSString *path = self.writer.videoPath;
            self.isCapturing = NO;
            dispatch_async(self.captureQueue, ^{
                [self.writer finishWithCompletionHandler:^{
                    self.isCapturing = NO;
                    self.writer = nil;
                    self.startTime = CMTimeMake(0, 0);
                    self.currentRecordTime = 0;
                    if (!isSuccess) {
                        NSError *error;
                        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                        NSLog(@"录制时间小于3秒,自动清理视频路径path:%@;error:%@",path,error);
                        return;
                    }
                    if (self.delegate && [self.delegate respondsToSelector:@selector(recordProgress:)]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.delegate recordProgress:self.currentRecordTime/self.maxRecordTime];
                        });
                    }
                    [self movieToImageHandler:handler];
                }];
            });
        }
    }
}

//获取视频第一帧的图片
- (void)movieToImageHandler:(void (^)(UIImage *movieImage,NSString *path))handler  {
    NSURL *url = [NSURL fileURLWithPath:self.videoPath];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    CMTime thumbTime = CMTimeMakeWithSeconds(0, 60);
    generator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    AVAssetImageGeneratorCompletionHandler generatorHandler = ^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        if (result == AVAssetImageGeneratorSucceeded) {
            UIImage *thumbImage = [UIImage imageWithCGImage:image];
            if (handler) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(thumbImage, self.videoPath);
                });
            }
        }
    };
    [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:generatorHandler];
}

// 切换摄像头
- (void)turnCameraAction {
    
    AVCaptureDevice *currentDevice = [self.videoDeviceInput device];
    AVCaptureDevicePosition currentPosition = [currentDevice position];
    AVCaptureDevicePosition toChangePosition = AVCaptureDevicePositionFront;
    AVCaptureDevice *toChangeDevice;
    if (currentPosition == AVCaptureDevicePositionUnspecified || currentPosition == AVCaptureDevicePositionFront) {
        toChangePosition = AVCaptureDevicePositionBack;
    }
    toChangeDevice = [self cameraDeviceWithPosition:toChangePosition];
    AVCaptureDeviceInput *toChangeDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:toChangeDevice error:nil];

    // 更改会话的配置前 一定要先开启配置，配置完成后提交配置更改
    [self.session beginConfiguration];
    //移除原有输入对象
    [self.session removeInput:self.videoDeviceInput];
    
    if ([self.session canAddInput:toChangeDeviceInput]) {
        [self.session addInput:toChangeDeviceInput];
        self.videoDeviceInput = toChangeDeviceInput;
    }
    if (self.videoConnection.isVideoMirroringSupported) {
        self.videoConnection.videoMirrored = YES;
    }
    self.videoConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
    // 提交配置
    [self.session commitConfiguration];
}

- (void)switchflash {
    NSLog(@"闪光灯开关");
}

- (BOOL)setScaleFactor:(CGFloat)factor {
    
    [_videoCaptureDevice lockForConfiguration:nil];
    BOOL success = NO;
    if (_videoCaptureDevice.activeFormat.videoMaxZoomFactor > factor) {
        [_videoCaptureDevice rampToVideoZoomFactor:factor withRate:30.f];
        success = YES;
    }
    [_videoCaptureDevice unlockForConfiguration];
    return success;
}

// 设置对焦点和曝光度
- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode point:(CGPoint)point {
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:point];
        }
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:point];
        }
    }];
}

// 将mov的视频转成mp4
- (void)changeMovToMp4:(NSURL *)mediaURL dataBlock:(void (^)(UIImage *movieImage,NSString *path))handler {
    AVAsset *video = [AVAsset assetWithURL:mediaURL];
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:video presetName:AVAssetExportPreset1280x720];
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.outputFileType = AVFileTypeMPEG4;
    
    NSString *basePath = [self getVideoCachePath];
    self.videoPath = [basePath stringByAppendingPathComponent:[self getUploadFile_type:@"video" fileType:@"mp4"]];
    exportSession.outputURL = [NSURL fileURLWithPath:self.videoPath];
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        [self movieToImageHandler:handler];
    }];
}


#pragma mark - helps
// 对焦
- (void)focus:(CGPoint)point {
    CGPoint camaraPoint = [self.previewLayer captureDevicePointOfInterestForPoint:point];
    [self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposureMode:AVCaptureExposureModeContinuousAutoExposure point:camaraPoint];
}

/**
 设置闪光灯模式
 
 @param flashMode 闪光灯模式
 */
- (void)setFlashMode:(AVCaptureFlashMode )flashMode {
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFlashModeSupported:flashMode]) {
            [captureDevice setFlashMode:flashMode];
        }
    }];
}

/**
 设置对焦模式
 
 @param focusMode 对焦模式
 */
- (void)setFocusMode:(AVCaptureFocusMode )focusMode {
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
    }];
}
/**
 设置曝光模式
 
 @param exposureMode 曝光模式
 */
- (void)setExposureMode:(AVCaptureExposureMode)exposureMode {
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
    }];
}

- (void)changeDeviceProperty:(void(^)(AVCaptureDevice *captureDevice))propertyChange{
    AVCaptureDevice *captureDevice = [self.videoDeviceInput device];
    NSError *error;
    
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }else{
        NSLog(@"设置设备属性过程发生错误:error：%@",error.localizedDescription);
    }
}

/** 取得指定位置的摄像头 */
- (AVCaptureDevice *)cameraDeviceWithPosition:(AVCaptureDevicePosition )position {
    
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in cameras) {
        if ([device position] == position)
            return device;
    }
    return nil;
}


//获得视频存放地址
- (NSString *)getVideoCachePath {
    NSString *videoCache = [NSTemporaryDirectory() stringByAppendingPathComponent:@"videos"];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:videoCache isDirectory:&isDir];
    if (!(isDir == YES && existed == YES)) {
        [fileManager createDirectoryAtPath:videoCache withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return videoCache;
}
- (NSString *)getUploadFile_type:(NSString *)type fileType:(NSString *)fileType {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HHmmss"];
    NSDate *nowDate = [NSDate dateWithTimeIntervalSince1970:now];
    NSString *timeStr = [formatter stringFromDate:nowDate];
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.%@", type, timeStr, fileType];
    return fileName;
}

#pragma mark - delegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    BOOL isVideo = YES;
    @synchronized (self) {
        if (!self.isCapturing || self.isPaused) {
            return;
        }
        if (output != self.videoDataOutput) {
            isVideo = NO;
        }
        // 初始化编码器，当有音频和视频参数时创建编码器
        if ((self.writer == nil) && !isVideo) {
            CMFormatDescriptionRef fmt = CMSampleBufferGetFormatDescription(sampleBuffer);
            [self setAudioFormat:fmt];
            NSString *videoName = [self getUploadFile_type:@"video" fileType:@"mp4"];
            self.videoPath = [[self getVideoCachePath] stringByAppendingPathComponent:videoName];
            self.writer = [XLVideoWriter writerForPath:self.videoPath Height:_cy width:_cx channels:_channels samples:_samplerate];
        }
        // 判断是否终端录制
        if (self.discont) {
            if (isVideo) {
                return;
            }
            self.discont = NO;
            // 计算暂停时间
            CMTime pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
            CMTime last = isVideo ? _lastVideo : _lastAudio;
            if (last.flags & kCMTimeFlags_Valid) {
                if (_timeOffset.flags & kCMTimeFlags_Valid) {
                    pts = CMTimeSubtract(pts, _timeOffset);
                }
                CMTime offset = CMTimeSubtract(pts, last);
                if (_timeOffset.value == 0) {
                    _timeOffset = offset;
                } else {
                    _timeOffset = CMTimeAdd(_timeOffset, offset);
                }
            }
            _lastVideo.flags = 0;
            _lastAudio.flags = 0;
        }
        // 增加sampleBuffer的引用计数，这样可以释放这个或修改这个数据，防止在修改时被释放
        CFRetain(sampleBuffer);
        if (_timeOffset.value > 0) {
            CFRelease(sampleBuffer);
            // 根据得到的timeOffset调整
            sampleBuffer = [self adjustTime:sampleBuffer by:_timeOffset];
        }
        // 记录暂停上一个录制的时间
        CMTime pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
        CMTime dur = CMSampleBufferGetDuration(sampleBuffer);
        if (dur.value > 0) {
            pts = CMTimeAdd(pts, dur);
        }
        if (isVideo) {
            _lastVideo = pts;
        } else {
            _lastAudio = pts;
        }
    }
    CMTime dur = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    if (self.startTime.value == 0) {
        self.startTime = dur;
    }
    CMTime sub = CMTimeSubtract(dur, self.startTime);
    self.currentRecordTime = CMTimeGetSeconds(sub);
    if (self.currentRecordTime > self.maxRecordTime) {
        if (self.currentRecordTime - self.maxRecordTime < 0.1) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(recordProgress:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate recordProgress:self.currentRecordTime/self.maxRecordTime];
                });
            }
        }
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordProgress:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate recordProgress:self.currentRecordTime/self.maxRecordTime];
        });
    }
    // 进行数据编码
    [self.writer writerFrame:sampleBuffer isVideo:isVideo];
    CFRelease(sampleBuffer);
}

//设置音频格式
- (void)setAudioFormat:(CMFormatDescriptionRef)fmt {
    const AudioStreamBasicDescription *asbd = CMAudioFormatDescriptionGetStreamBasicDescription(fmt);
    _samplerate = asbd->mSampleRate;
    _channels = asbd->mChannelsPerFrame;
    
}
//调整媒体数据的时间
- (CMSampleBufferRef)adjustTime:(CMSampleBufferRef)sample by:(CMTime)offset {
    CMItemCount count;
    CMSampleBufferGetSampleTimingInfoArray(sample, 0, nil, &count);
    CMSampleTimingInfo *pInfo = malloc(sizeof(CMSampleTimingInfo) * count);
    CMSampleBufferGetSampleTimingInfoArray(sample, count, pInfo, &count);
    for (CMItemCount i = 0; i < count; i++) {
        pInfo[i].decodeTimeStamp = CMTimeSubtract(pInfo[i].decodeTimeStamp, offset);
        pInfo[i].presentationTimeStamp = CMTimeSubtract(pInfo[i].presentationTimeStamp, offset);
    }
    CMSampleBufferRef sout;
    CMSampleBufferCreateCopyWithNewTiming(nil, sample, count, pInfo, &sout);
    free(pInfo);
    return sout;
}

#pragma mark - getter && setter
- (AVCaptureSession *)session {
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
        _session.sessionPreset = AVCaptureSessionPresetHigh;
        if ([_session canAddInput:self.videoDeviceInput]) {
            [_session addInput:self.videoDeviceInput];
        }
        if ([_session canAddInput:self.audioDeviceInput]) {
            [_session addInput:self.audioDeviceInput];
        }
        if ([_session canAddOutput:self.videoDataOutput]) {
            [_session addOutput:self.videoDataOutput];
            _cx = VIDEO_WIDTH;
            _cy = VIDEO_HEIGHT;
        }
        if ([_session canAddOutput:self.audioDataOutput]) {
            [_session addOutput:self.audioDataOutput];
        }
        if ([_session canAddOutput:self.stillImageOutput]) {
            [_session addOutput:self.stillImageOutput];
        }
        // 设置视频录制的方向
        self.videoConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
    }
    return _session;
}
//录制的队列
- (dispatch_queue_t)captureQueue {
    if (_captureQueue == nil) {
        _captureQueue = dispatch_queue_create("cn.xl.capture", DISPATCH_QUEUE_SERIAL);
    }
    return _captureQueue;
}

- (AVCaptureDeviceInput *)videoDeviceInput {
    if (!_videoDeviceInput) {
        self.videoCaptureDevice = [self cameraDeviceWithPosition:AVCaptureDevicePositionBack];
        if (!self.videoCaptureDevice) NSLog(@"获取后置摄像头时出问题");
        NSError *error = nil;
        _videoDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.videoCaptureDevice error:&error];
        if (error) NSLog(@"不能创建视频：%@", error.localizedDescription);
    }
    return _videoDeviceInput;
}

- (AVCaptureDeviceInput *)audioDeviceInput {
    if (!_audioDeviceInput) {
        AVCaptureDevice *audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        NSError *error = nil;
        _audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioCaptureDevice error:&error];
        if (error) {
            NSLog(@"不能创建音频：%@", error.localizedDescription);
        }
    }
    return _audioDeviceInput;
}

- (AVCaptureVideoDataOutput *)videoDataOutput {
    if (!_videoDataOutput) {
        _videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        [_videoDataOutput setSampleBufferDelegate:self queue:self.captureQueue];
        NSDictionary *settings = @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)};
        _videoDataOutput.videoSettings = settings;
    }
    return _videoDataOutput;
}

- (AVCaptureAudioDataOutput *)audioDataOutput {
    if (!_audioDataOutput) {
        _audioDataOutput = [[AVCaptureAudioDataOutput alloc] init];
        [_audioDataOutput setSampleBufferDelegate:self queue:self.captureQueue];
    }
    return _audioDataOutput;
}

- (AVCaptureStillImageOutput *)stillImageOutput{
    if (!_stillImageOutput) {
        _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        _stillImageOutput.outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
    }
    return _stillImageOutput;
}

//视频连接
- (AVCaptureConnection *)videoConnection {
    // 不能使用懒加载，切换摄像头的时候需要重新初始化，不然方向会出问题。
    _videoConnection = [self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
    return _videoConnection;
}

//音频连接
- (AVCaptureConnection *)audioConnection {
    if (!_audioConnection) {
        _audioConnection = [self.audioDataOutput connectionWithMediaType:AVMediaTypeAudio];
    }
    return _audioConnection;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (!_previewLayer) {
        //通过AVCaptureSession初始化
        AVCaptureVideoPreviewLayer *preview = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        //设置比例为铺满全屏
        preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _previewLayer = preview;
    }
    return _previewLayer;
}

- (BOOL)isRunning{
    return _session.isRunning;
}

#pragma mark - 切换动画
- (void)changeCameraAnimation {
    CATransition *changeAnimation = [CATransition animation];
    changeAnimation.delegate = self;
    changeAnimation.duration = 0.45;
    changeAnimation.type = @"oglFlip";
    changeAnimation.subtype = kCATransitionFromRight;
    changeAnimation.timingFunction = UIViewAnimationCurveEaseInOut;
    [self.previewLayer addAnimation:changeAnimation forKey:@"changeAnimation"];
}

- (void)animationDidStart:(CAAnimation *)anim {
    self.videoConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
    [self.session startRunning];
}

@end
