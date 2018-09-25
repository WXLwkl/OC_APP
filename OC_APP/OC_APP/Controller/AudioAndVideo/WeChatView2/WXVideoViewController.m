//
//  WXVideoViewController.m
//  OC_APP
//
//  Created by xingl on 2018/9/20.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "WXVideoViewController.h"
//#import "XLVideoRecorderView.h"
#import "XLVideoRecorder.h"

#import "XLMotionManager.h"
#import "XLRecordProgressView.h"
#import "XLRecordSuccessPreview.h"

#define TIMER_INTERVAL 0.5 //定时器时间间隔
#define RECORD_TIME 0.5 //开始录制视频的时间
#define VIDEO_MIN_TIME 3 // 录制视频最短时间


@interface WXVideoViewController ()<XLVideoRecorderDelegate, XLMotionManagerDeviceOrientationDelegate,UIGestureRecognizerDelegate>

//@property (nonatomic, strong) XLVideoRecorderView *videoView;

@property (nonatomic, strong) XLVideoRecorder *videoRecorder;
@property (nonatomic, assign) BOOL allowRecord; // 允许录制
@property (nonatomic, assign) BOOL isEndRecord; // 录制结束
@property (nonatomic, assign) NSTimeInterval timeInterval; // 时长
@property (nonatomic, strong) NSTimer *timer; // 定时器


@property (nonatomic ,strong) XLRecordSuccessPreview *preview;// 拍摄成功预览视图
@property (nonatomic, strong) XLRecordProgressView *recordButton;// 录制按钮

@property (nonatomic, strong) UILabel *tipLabel; // 提示标签
@property (nonatomic, strong) UIButton *exitButton; // 退出按钮
@property (nonatomic, strong) UIButton *switchButton; // 摄像头切换按钮

@property (nonatomic, strong) UIImageView *focusImageView; // 对焦图片
@property (nonatomic, strong) UILabel *alertLabel; // 录制时间太短的提示标签

@property (nonatomic, assign) UIDeviceOrientation lastDeviceOrientation; // 记录屏幕当前方向


@end

@implementation WXVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:self.videoView];
    
    self.allowRecord = YES;
    [self setupUI];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 监听设备方向
    [[XLMotionManager sharedManager] startDeviceMotionUpdates];
    [XLMotionManager sharedManager].delegate = self;
    
    if (!_videoRecorder) {
        [self.videoRecorder previewLayer].frame = self.view.bounds;
        [self.view.layer insertSublayer:[self.videoRecorder previewLayer] atIndex:0];
    }
    [self.videoRecorder startSession];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    // 停止监听设备方向
    [XLMotionManager sharedManager].delegate = nil;
    [[XLMotionManager sharedManager] stopDeviceMotionUpdates];

    [self removeTimer];
    [self.videoRecorder stopSession];
}

- (void)setupUI {
    // 关闭按钮
    [self.view addSubview:self.exitButton];
    self.exitButton.frame = CGRectMake(5, 10, 44,44);
    // 切换摄像头按钮
    [self.view addSubview:self.switchButton];
    self.switchButton.frame = CGRectMake(self.view.bounds.size.width - 44 - 5 , 10, 44, 44);
    // 中间拍照录制按钮
    [self.view addSubview:self.recordButton];
    self.recordButton.frame = CGRectMake(0, 0, 156/2, 156/2);
    self.recordButton.center = CGPointMake(self.view.center.x, self.view.bounds.size.height - 97);
    // 提示
    [self.view addSubview:self.tipLabel];
    self.tipLabel.bounds = CGRectMake(0, 0, 200, 20);
    self.tipLabel.center = CGPointMake(self.view.center.x, self.view.bounds.size.height - 160 - 13/2);
    
    
    // 对焦手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
}

- (void)tapGesture:(UITapGestureRecognizer *)tapGesture {
    if (!self.videoRecorder.isRunning) {
        return;
    }
    CGPoint point = [tapGesture locationInView:self.view];
    [self setFocusCursorWithPoint:point];
    CGPoint camaraPoint = [self.videoRecorder.previewLayer captureDevicePointOfInterestForPoint:point];
    [self.videoRecorder focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposureMode:AVCaptureExposureModeContinuousAutoExposure point:camaraPoint];
    
    
}
- (void)setFocusCursorWithPoint:(CGPoint)point {
    self.focusImageView.center = point;
    self.focusImageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.focusImageView.alpha = 1.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.focusImageView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusImageView.alpha = 0;
        
    }];
}
#pragma mark - action
// 点击发送
- (void)sendWithImage:(UIImage *)image videoPath:(NSString *)videoPath {
    NSLog(@"发送");
    [self exitRecordController];
}
// 点击重拍
- (void)cancel {
    NSLog(@"重拍");
    if (_preview) {
        [_preview removeFromSuperview];
        _preview = nil;
    }
    [self.recordButton resetScale];
    [self.recordButton setEnabled:YES];
    [self showAllOperationViews];
    [self.videoRecorder startSession];
}


- (void)caculateTime {
    _timeInterval += TIMER_INTERVAL;
    NSLog(@"计时器:_timeInterval:%f",_timeInterval);
    if (_timeInterval == RECORD_TIME) {
        NSLog(@"开始录制");
        [self.recordButton setScale];
        [self startRecord];
    } else if (_timeInterval >= RECORD_TIME + VIDEO_MIN_TIME) {
        [self removeTimer];
    }
}


- (void)exitRecordController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)turnCameraAction {
    [self.videoRecorder turnCameraAction];
}
// 按下
- (void)touchDown:(UIButton *)button {
    [self hideExitAndSwitchViews];
    [self removeTimer];
    [self timer];
}
// 按钮抬起
- (void)touchUpInsideOrOutSide:(UIButton *)button {
    NSLog(@"抬起按钮:__timeInterval==:%f",_timeInterval);
    [self removeTimer];
    if (_timeInterval >= RECORD_TIME && _timeInterval < RECORD_TIME + VIDEO_MIN_TIME) {
        NSLog(@"录制时间太短");
        [self stopRecord:NO];
        [self alert];
        [self.recordButton resetScale];
    } else if (_timeInterval < RECORD_TIME) {
        NSLog(@"点击拍照");
        [self.recordButton setEnabled:NO];
        [self hideAllOperationViews];
        [self takephoto];
    } else {
        NSLog(@"录制结束");
        if (!_isEndRecord) {
            [self.recordButton setEnabled:NO];
            [self stopRecord:YES];
        }
    }
    _timeInterval = 0;
}

- (void)startRecord {
    if (self.videoRecorder.isCapturing) {
        [self.videoRecorder resumeCapture];
    }else {
        [self.videoRecorder startCapture];
    }
}
- (void)stopRecord:(BOOL)isSuccess {
    _isEndRecord = NO;
    [self.recordButton setProgress:0];
    if (isSuccess) {
        [self hideAllOperationViews];
    } else {
        [self showExitAndSwitchViews];
    }
    WeakSelf(self);
    [self.videoRecorder stopCaptureWithStatus:isSuccess handler:^(UIImage *movieImage, NSString *path) {
        StrongSelf(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.videoRecorder stopSession];
            [self.preview setImage:nil videoPath:path captureVideoOrientation:[XLMotionManager sharedManager].currentVideoOrientation];
        });
    }];
}

- (void)alert {
    [self.view bringSubviewToFront:self.alertLabel];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_alertLabel) {
            [UIView animateWithDuration:0.25 animations:^{
                _alertLabel.alpha = 0;
            } completion:^(BOOL finished) {
                [_alertLabel removeFromSuperview];
                _alertLabel = nil;
            }];
        }
    });
}

- (void)takephoto {
    WeakSelf(self);
    [self.videoRecorder takePhoto:^(UIImage *image) {
        StrongSelf(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.videoRecorder stopSession];
            [self.preview setImage:image videoPath:nil captureVideoOrientation:[XLMotionManager sharedManager].currentVideoOrientation];
        });
    }];
}
// 显示所有操作按钮
- (void)showAllOperationViews{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.recordButton setHidden:NO];
        [self.exitButton setHidden:NO];
        [self.tipLabel setHidden:NO];
        [self.switchButton setHidden:NO];
    });
}
// 隐藏所有操作按钮
- (void)hideAllOperationViews {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.recordButton setHidden:YES];
        [self.exitButton setHidden:YES];
        [self.tipLabel setHidden:YES];
        [self.switchButton setHidden:YES];
    });
}

// 开始拍摄时隐藏退出和切换摄像头按钮
- (void)hideExitAndSwitchViews {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.exitButton setHidden:YES];
        [self.switchButton setHidden:YES];
    });
}
// 拍摄结束后显示退出按钮和切换摄像头按钮
- (void)showExitAndSwitchViews{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.exitButton setHidden:NO];
        [self.switchButton setHidden:NO];
    });
}
// 移除定时器
- (void)removeTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - delegate
- (void)recordProgress:(CGFloat)progress {
    NSLog(@"progress= %.2f", progress);
    if (progress >= 0) {
        [self.recordButton setProgress:progress];
    }
    if ((int)progress == 1) {
        _isEndRecord = YES;
        [self stopRecord:YES];
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:self.view];
    if (point.y >= self.view.bounds.size.height - 190) {
        return NO;
    }
    return YES;
}
- (void)motionManagerDeviceOrientation:(UIDeviceOrientation)deviceOrientation {
    
    if (_lastDeviceOrientation == deviceOrientation) return;
    
    CGFloat angle = 0;
    switch (deviceOrientation) {
        case UIDeviceOrientationPortrait:
            angle = 0;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            angle = M_PI;
            break;
        case UIDeviceOrientationLandscapeLeft:
            angle = M_PI_2;
            break;
        case UIDeviceOrientationLandscapeRight:
            angle = -M_PI_2;
            break;
        default:
            break;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        _exitButton.transform = CGAffineTransformRotate(CGAffineTransformIdentity, angle);
        _switchButton.transform = CGAffineTransformRotate(CGAffineTransformIdentity, angle);
    }];
    _lastDeviceOrientation = deviceOrientation;
}

#pragma mark -相机,麦克风权限
- (void)authorizationStatus{
    AVAuthorizationStatus videoStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (granted) {
            NSLog(@"允许访问相机权限");
        } else {
            NSLog(@"不允许相机访问");
        }
    }];
    
    AVAuthorizationStatus audioStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        if (granted) {
            NSLog(@"允许麦克风权限");
        } else {
            NSLog(@"不允麦克风访问");
        }
    }];
    
}

#pragma mark - getter && setter
- (XLVideoRecorder *)videoRecorder {
    if (!_videoRecorder) {
        _videoRecorder = [[XLVideoRecorder alloc] init];
        _videoRecorder.delegate = self;
    }
    return _videoRecorder;
}

- (UIButton *)exitButton {
    if (!_exitButton) {
        _exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exitButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [_exitButton addTarget:self action:@selector(exitRecordController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitButton;
}

- (UIButton *)switchButton {
    if (!_switchButton) {
        _switchButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_switchButton setImage:[UIImage imageNamed:@"listing_camera_lens"] forState:UIControlStateNormal];
        [_switchButton addTarget:self action:@selector(turnCameraAction) forControlEvents:UIControlEventTouchUpInside];
        [_switchButton sizeToFit];
    }
    return _switchButton;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        // 提示文字:点击拍照,长按拍摄
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.text = @"点击拍照,长按拍摄";
        _tipLabel.font = [UIFont systemFontOfSize:13];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = [UIColor whiteColor];
    }
    return _tipLabel;
}

- (XLRecordProgressView *)recordButton {
    if (!_recordButton) {
        _recordButton = [[XLRecordProgressView alloc] initWithFrame:CGRectMake(0, 0, 156/2, 156/2)];
        [_recordButton addTarget:self action:@selector(touchUpInsideOrOutSide:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        [_recordButton addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    }
    return _recordButton;
}

/** 聚焦图片 */
- (UIImageView *)focusImageView {
    if (!_focusImageView) {
        _focusImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"focusImg"]];
        _focusImageView.bounds = CGRectMake(0, 0, 40, 40);
        [self.view addSubview:_focusImageView];
    }
    return _focusImageView;
}

- (UILabel *)alertLabel{
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc]init];
        _alertLabel.text = @"拍摄时间太短,不少于3s";
        _alertLabel.font = [UIFont systemFontOfSize:15];
        _alertLabel.textColor = [UIColor whiteColor];
        _alertLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        _alertLabel.layer.cornerRadius = 19;
        _alertLabel.clipsToBounds = YES;
        CGFloat width = [_alertLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 76/2) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width;
        _alertLabel.bounds = CGRectMake(0, 0, width + 30, 76/2);
        _alertLabel.center = CGPointMake(self.view.center.x, _tipLabel.center.y - _tipLabel.bounds.size.height/2 - 48/2 - _tipLabel.bounds.size.height/2);
        [self.view addSubview:_alertLabel];
    }
    return _alertLabel;
}

- (XLRecordSuccessPreview *)preview{
    if (!_preview) {
        _preview = [[XLRecordSuccessPreview alloc]initWithFrame:self.view.bounds];
        WeakSelf(self);
        [_preview setSendBlock:^(UIImage *image,NSString *videoPath){
            StrongSelf(self);
            [self sendWithImage:image videoPath:videoPath];
        }];
        [_preview setCancelBlock:^{
            StrongSelf(self);
            [self cancel];
        }];
        [self.view addSubview:_preview];
    }
    return _preview;
}
- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(caculateTime) userInfo:nil repeats:YES];
    }
    return _timer;
}

//- (XLVideoRecorderView *)videoView {
//    if (!_videoView) {
//        _videoView = [[XLVideoRecorderView alloc] initWithFrame:self.view.bounds];
////        _videoView.delegate = self;
//    }
//    return _videoView;
//}
@end
