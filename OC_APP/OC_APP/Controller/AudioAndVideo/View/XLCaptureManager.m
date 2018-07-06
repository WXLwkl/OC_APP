//
//  AVCaptureManager.m
//  OC_APP
//
//  Created by xingl on 2018/6/22.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "XLCaptureManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "FileManager.h"



@interface XLCaptureManager ()<AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, weak) UIView *superView;

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewlayer;
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong) AVCaptureDeviceInput *audioInput;
@property (nonatomic, strong) AVCaptureMovieFileOutput *fileOutput;

@property (nonatomic, strong) UIImageView *focusCursor; //聚焦光标

@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat recordTime;

@property (nonatomic, assign) XLFlashState flashState;

@end

@implementation XLCaptureManager

- (instancetype)initWithSuperView:(UIView *)superView {
    self = [super init];
    if (self) {
        _superView = superView;
        [self setup];
    }
    return self;
}

#pragma mark - public Method
- (void)turnCameraAction {
    [self.session stopRunning];
    // 获取当前摄像头
    AVCaptureDevicePosition position = self.videoInput.device.position;
    // 获取当前需要展示的摄像头
    if (position == AVCaptureDevicePositionBack)
        position = AVCaptureDevicePositionFront;
    else
        position = AVCaptureDevicePositionBack;
    // 根据当前摄像头创建新的device
    AVCaptureDevice *device = [self getCameraDeviceWithPosition:position];
    // 根据新的device创建input
    AVCaptureDeviceInput *newInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    // 在session中切换input
    [self.session beginConfiguration];
    [self.session removeInput:self.videoInput];
    [self.session addInput:newInput];
    [self.session commitConfiguration];
    self.videoInput = newInput;
    
    [self.session startRunning];
}
- (void)switchflash {
    
    if (_flashState == XLFlashStateClose) {
        if ([self.videoInput.device hasTorch]) {
            [self.videoInput.device lockForConfiguration:nil];
            [self.videoInput.device setTorchMode:AVCaptureTorchModeOn];
            [self.videoInput.device unlockForConfiguration];
            _flashState = XLFlashStateOpen;
        }
    } else if (_flashState == XLFlashStateOpen) {
        if ([self.videoInput.device hasTorch]) {
            [self.videoInput.device lockForConfiguration:nil];
            [self.videoInput.device setTorchMode:AVCaptureTorchModeAuto];
            [self.videoInput.device unlockForConfiguration];
            _flashState = XLFlashStateAuto;
        }
    } else if (_flashState == XLFlashStateAuto) {
        if ([self.videoInput.device hasTorch]) {
            [self.videoInput.device lockForConfiguration:nil];
            [self.videoInput.device setTorchMode:AVCaptureTorchModeOff];
            [self.videoInput.device unlockForConfiguration];
            _flashState = XLFlashStateClose;
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateFlashState:)]) {
        [self.delegate updateFlashState:_flashState];
    }
}
- (void)startRecord {
    [self writeDataTofile];
}
- (void)stopRecord {
    [self.fileOutput stopRecording];
    [self.session stopRunning];
    [self.timer invalidate];
    self.timer = nil;
}
- (void)reset {
    self.recordState = XLRecordStateInit;
    _recordTime = 0;
    [self.session startRunning];
}

- (void)writeDataTofile {
    NSString *videoPath = [self createVideoFilePath];
    self.videoUrl = [NSURL fileURLWithPath:videoPath];
    
    [self.fileOutput startRecordingToOutputFileURL:self.videoUrl recordingDelegate:self];
}
//写入的视频路径
- (NSString *)createVideoFilePath
{
    NSString *videoName = [NSString stringWithFormat:@"%@.mp4", [NSUUID UUID].UUIDString];
    NSString *path = [[self videoFolder] stringByAppendingPathComponent:videoName];
    return path;
    
}
- (void)clearFile {
    [FileManager removeItemAtPath:[self videoFolder]];
}
// 存放视频的文件夹
- (NSString *)videoFolder {
    
    NSString *cacheDir = [FileManager cachesDir];
    NSString *direc = [cacheDir stringByAppendingPathComponent:VIDEO_FOLDER];
    if (![FileManager isExistsAtPath:direc]) {
        [FileManager createDirectoryAtPath:direc];
    }
    return direc;
}


- (void)setup {
    // 0.设置会话
    [self setupInit];
    // 1.设置视频输入
    [self setupVideo];
    // 2.设置音频的输入
    [self setupAudio];
    // 3.添加写入文件的fileoutput
    [self setupFileOut];
    // 4.视频的预览层
    [self setupPreviewLayer];
    // 5.开始采集画面
    [self.session startRunning];
    // 6
    // 7.增加聚焦
//    [self addFocus];
}

/**
 0.初始化捕捉会话,数据的采集都在会话中处理
 */
- (void)setupInit {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBack) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    [self clearFile];
    _recordTime = 0;
    _recordState = XLRecordStateInit;
}
/**
 1.设置视频的输入
 */
- (void)setupVideo {
    AVCaptureDevice *videoCaptureDevide = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack]; //调用后置摄像头
    NSError *error = nil;
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:videoCaptureDevide error:&error];
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
}
/**
 2.设置音频输入
 */
- (void)setupAudio {
    AVCaptureDevice *audioCaptureDevice = [[AVCaptureDevice devicesWithMediaType:(AVMediaTypeAudio)] firstObject];
    NSError *error = nil;
    self.audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptureDevice error:&error];
    if ([self.session canAddInput:self.audioInput]) {
        [self.session addInput:self.audioInput];
    }
}
/**
 3.添加写入文件的fileout
 */
- (void)setupFileOut {
    // 初始化设备输出对象，用于获得输出数据
    self.fileOutput = [[AVCaptureMovieFileOutput alloc] init];
    // 设置输出对象的一些属性
    AVCaptureConnection *captureConnection = [self.fileOutput connectionWithMediaType:AVMediaTypeVideo];
    //视频防抖
    if ([captureConnection isVideoStabilizationSupported]) {
        captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
    }
    //预览图层和视频方向保持一致
    captureConnection.videoOrientation = [self.previewlayer connection].videoOrientation;
    if ([self.session canAddOutput:self.fileOutput]) {
        [self.session addOutput:self.fileOutput];
    }
}
/**
 4.视频的预览层
 */
- (void)setupPreviewLayer {
    self.previewlayer.frame = self.superView.bounds;
    [_superView.layer insertSublayer:self.previewlayer atIndex:0];
}

/**
 7.增加聚焦功能(选用)
 */
- (void)addFocus {
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

- (void)changeDeviceProperty:(void(^)(AVCaptureDevice *captureDevice))propertyChage {
    AVCaptureDevice *captureDevice = [self.videoInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:
    //调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChage(captureDevice);
        [captureDevice unlockForConfiguration];
    } else {
        NSLog(@"设置设备属性过程发送错误,错误信息:%@", error.localizedDescription);
    }
    
}

- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition)position {
    NSArray<AVCaptureDevice *> *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position] == position) {
            return camera;
        }
    }
    return nil;
}

#pragma mark - notification
- (void)enterBack {
    self.videoUrl = nil;
    [self stopRecord];
}

- (void)becomeActive {
    [self reset];
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)refreshTimeLabel {
    _recordTime += TIMER_INTERVAL;
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateRecordingProgress:)]) {
        [self.delegate updateRecordingProgress:_recordTime/RECORD_MAX_TIME];
    }
    if (_recordTime >= RECORD_MAX_TIME) {
        [self stopRecord];
    }
}


#pragma mark - AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)output didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections {
    self.recordState = XLRecordStateRecording;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(refreshTimeLabel) userInfo:nil repeats:YES];
}

- (void)captureOutput:(AVCaptureFileOutput *)output didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(NSError *)error {
    if ([FileManager isExistsAtPath:[self.videoUrl path]]) {
        self.recordState = XLRecordStateFinish;
    }
}


#pragma mark - getter && setter
- (AVCaptureSession *)session {
    
    /**
     录制5秒钟视频 高画质10M,压缩成中画质 0.5M
     录制5秒钟视频 中画质0.5M,压缩成中画质 0.5M
     录制5秒钟视频 低画质0.1M,压缩成中画质 0.1M
     只有高分辨率的视频才是全屏的，如果想要自定义长宽比，就需要先录制高分辨率，再剪裁，如果录制低分辨率，剪裁的区域不好控制
     */
    
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
        if ([_session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
            _session.sessionPreset = AVCaptureSessionPresetHigh; // 设置分辨率
        }
    }
    return _session;
}

- (AVCaptureVideoPreviewLayer *)previewlayer {
    if (!_previewlayer) {
        _previewlayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        _previewlayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _previewlayer;
}

- (UIImageView *)focusCursor {
    if (!_focusCursor) {
        _focusCursor = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
        _focusCursor.image = [UIImage imageNamed:@"focusImg"];
        _focusCursor.alpha = 0;
    }
    return _focusCursor;
}

- (void)setRecordState:(XLRecordState)recordState {
    if (_recordState != recordState) {
        _recordState = recordState;
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateRecordState:)]) {
            [self.delegate updateRecordState:_recordState];
        }
    }
}


@end
