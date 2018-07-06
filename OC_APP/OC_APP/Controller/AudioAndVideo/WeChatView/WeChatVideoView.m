//
//  WeChatVideoView.m
//  OC_APP
//
//  Created by xingl on 2018/6/27.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "WeChatVideoView.h"
#import "CameraButton.h"

#import <AVFoundation/AVFoundation.h>

#import "XLTools.h"

@interface WeChatVideoView ()<WeChatCaptureManagerDelegate>

@property (nonatomic, strong) WeChatCaptureManager *captureManager;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) CameraButton *cameraButton;
@property (nonatomic, strong) UIButton *dismissBtn;
@property (nonatomic, strong) UIButton *turnCamera;


@property (nonatomic, strong) UIView *photoPreviewContainerView;     // 相片预览ContainerView
@property (nonatomic, strong) UIImageView *photoPreviewImageView;    // 相片预览ImageView

@property (nonatomic, strong) UIView *videoPreviewContainerView;     // 视频预览View
@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) UIButton *cancelButton;  // 取消按钮
@property (nonatomic, strong) UIButton *confirmButton; // 确认按钮

@property (nonatomic, strong) UIImage *finalImage; // 获得的image


@property (nonatomic, strong) AVPlayerItem *item;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@end

@implementation WeChatVideoView

- (void)dealloc {
    NSLog(@"WeChatVideoView dealloc");
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self configUI];
    }
    return self;
}

- (void)configUI  {
    
    self.captureManager = [[WeChatCaptureManager alloc] initWithSuperView:self];
    self.captureManager.delegate = self;
    
    CGFloat cameraBtnX = (kScreenWidth - self.cameraButton.bounds.size.width) / 2;
    CGFloat cameraBtnY = kScreenHeight - self.cameraButton.bounds.size.height - 60 - kBottomHeight;    //距离底部60
    _cameraButton.frame = CGRectMake(cameraBtnX, cameraBtnY, self.cameraButton.bounds.size.width, _cameraButton.bounds.size.height);
    [self bringSubviewToFront:self.cameraButton];
    
    [self showDefaultStyle];
    
    self.dismissBtn.xl_centerY = _cameraButton.xl_centerY;
    self.dismissBtn.xl_right = _cameraButton.xl_x - 50;
    
    self.turnCamera.xl_centerY = _cameraButton.xl_centerY;
    self.turnCamera.xl_x = _cameraButton.xl_right + 50;
    
    [self.tipLabel setAlpha:0];
    self.tipLabel.xl_centerX = _cameraButton.xl_centerX;
    self.tipLabel.xl_bottom = _cameraButton.xl_y - 20;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self tipLabelAnimation];
    });
}

- (void)tipLabelAnimation {
    
    [self bringSubviewToFront:self.tipLabel];
    [self.tipLabel setAlpha:0];
    
    [UIView animateWithDuration:1.0f delay:1.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.tipLabel setAlpha:1];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0f delay:3.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.tipLabel setAlpha:0];
        } completion:nil];
    }];
}


- (void)reset {
    [self.captureManager reset];
}

#pragma mark - action
- (void)dismiss {
    [self.captureManager stopUpdateAccelerometer];
    if ([self.delegate respondsToSelector:@selector(dismissVC)]) [self.delegate dismissVC];
}

- (void)turnCameraAction {
    [self.captureManager turnCameraAction];
}

- (void)cancelBtnfunc:(id)sender {
    [self reset];
    [self showDefaultStyle];
}

- (void)confirmBtnFunc:(id)sender {

    if (_photoPreviewContainerView && [self.delegate respondsToSelector:@selector(takePhotoWithImage:)]) {
        [self.delegate takePhotoWithImage:self.finalImage];
    }
    if (_videoPreviewContainerView && [self.delegate respondsToSelector:@selector(recordFinishWithvideoUrl:)]) {
        [self.delegate recordFinishWithvideoUrl:self.captureManager.videoURL];
    }
}

- (void)takePhoto {
    NSLog(@"拍照");
    [self.captureManager takePhotoWithFinalImage:^(UIImage *image) {
        
        self.finalImage = image;
        [self showPhotoStyle];
    }];
}
// 长按录像
- (void)recordVideo:(UILongPressGestureRecognizer *)longPressGesture {
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:
            [self.captureManager startRecord];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            [self.captureManager stopRecord];
            break;
        case UIGestureRecognizerStatePossible:
            NSLog(@"UIGestureRecognizerStatePossible");
            break;
        default:
            break;
    }
}
#pragma mark - style
- (void)showDefaultStyle {
    if (_photoPreviewContainerView) {
        [_photoPreviewContainerView removeFromSuperview];
        _photoPreviewContainerView = nil;
        [_photoPreviewImageView removeFromSuperview];
        _photoPreviewImageView = nil;
        
        self.cancelButton.hidden = YES;
        self.confirmButton.hidden = YES;
        
    }
    if (_videoPreviewContainerView) {
        [_videoPreviewContainerView removeFromSuperview];
        _videoPreviewContainerView = nil;
        [_player pause];
        _player = nil;
        
        self.cancelButton.hidden = YES;
        self.confirmButton.hidden = YES;
    }
    
    self.turnCamera.hidden = NO;
    self.dismissBtn.hidden = NO;
    [self bringSubviewToFront:self.turnCamera];
    [self bringSubviewToFront:self.dismissBtn];
    
}
- (void)showPhotoStyle {
    
    if (_videoPreviewContainerView) {
        [_videoPreviewContainerView removeFromSuperview];
        _videoPreviewContainerView = nil;
        
        
        _item = nil;
        [_playerLayer removeFromSuperlayer];
        _playerLayer = nil;
        [_player pause];
        _player = nil;
    }
    self.turnCamera.hidden = YES;
    self.dismissBtn.hidden = YES;
    
    
    [self addSubview:self.photoPreviewContainerView];
    self.photoPreviewImageView.image = self.finalImage;
    
    self.cancelButton.center = self.dismissBtn.center;
    self.cancelButton.hidden = NO;
    [self bringSubviewToFront:self.cancelButton];
    self.confirmButton.center = self.turnCamera.center;
    self.confirmButton.hidden = NO;
    [self bringSubviewToFront:self.confirmButton];
}
- (void)showVideoStyle {
    if (_photoPreviewContainerView) {
        [_photoPreviewContainerView removeFromSuperview];
        _photoPreviewContainerView = nil;
        [_photoPreviewImageView removeFromSuperview];
        _photoPreviewImageView = nil;
    }
    self.turnCamera.hidden = YES;
    self.dismissBtn.hidden = YES;
    
    [self addSubview:self.videoPreviewContainerView];
    [self.player play];
    
    self.cancelButton.center = self.dismissBtn.center;
    self.cancelButton.hidden = NO;
    [self bringSubviewToFront:self.cancelButton];
    
    self.confirmButton.center = self.turnCamera.center;
    self.confirmButton.hidden = NO;
    [self bringSubviewToFront:self.confirmButton];
    
}

#pragma mark - WeChatCaptureManagerDelegate
- (void)updateRecordingProgress:(CGFloat)progress {
    self.cameraButton.progressPercentage = progress;
}
- (void)updateRecordState:(WeChatRecordState)recordState {
    switch (recordState) {
        case WeChatRecordStateInit:
            self.cameraButton.progressPercentage = 0;
            [self.cameraButton stopShootAnimationWithDuration:0.25];
            break;
        case WeChatRecordStateRecording:
            [self.cameraButton startShootAnimationWithDuration:0.25];
            break;
        case WeChatRecordStateFinish: {
            self.cameraButton.progressPercentage = 0;
            [self.cameraButton stopShootAnimationWithDuration:0.25];
            [self showVideoStyle];
//            [self.delegate recordFinishWithvideoUrl:self.captureManager.videoURL];
        }
            break;
        default:
            break;
    }
}



#pragma mark - getter && setter
- (CameraButton *)cameraButton {
    if (!_cameraButton) {
        _cameraButton = [CameraButton defaultCameraButton];
        [self addSubview:_cameraButton];
        __weak typeof(self) weakSelf = self;
        [_cameraButton configureTapCameraButtonEventWithBlock:^(UITapGestureRecognizer *tapGestureRecognizer) {
            [weakSelf takePhoto];
        }];
        [_cameraButton configureLongPressCameraButtonEventWithBlock:^(UILongPressGestureRecognizer *longPressGestureRecognizer) {
            [weakSelf recordVideo:longPressGestureRecognizer];
        }];
    }
    return _cameraButton;
}

- (UIView *)photoPreviewContainerView {
    if (!_photoPreviewContainerView) {
        _photoPreviewContainerView = [[UIView alloc] init];
        _photoPreviewContainerView.backgroundColor = [UIColor blackColor];
        _photoPreviewContainerView.frame = self.bounds;
        
        _photoPreviewImageView = [[UIImageView alloc] init];
        _photoPreviewImageView.contentMode = UIViewContentModeScaleAspectFit;
        _photoPreviewImageView.frame = _photoPreviewContainerView.bounds;
        _photoPreviewImageView.backgroundColor = [UIColor redColor];
        [_photoPreviewContainerView addSubview:_photoPreviewImageView];
        [self addSubview:_photoPreviewContainerView];
    }
    return _photoPreviewContainerView;
}

- (UIView *)videoPreviewContainerView {
    if (!_videoPreviewContainerView) {
        _videoPreviewContainerView = [[UIView alloc] init];
        _videoPreviewContainerView.backgroundColor = [UIColor grayColor];
        _videoPreviewContainerView.frame = self.bounds;

        AVURLAsset *asset = [AVURLAsset assetWithURL:self.captureManager.videoURL];
        //获取视频总时长
//        Float64 duration = CMTimeGetSeconds(asset.duration);
//        CGFloat currentVideoTimeLength = duration;
        _item = [AVPlayerItem playerItemWithAsset:asset];
        _player = [[AVPlayer alloc] initWithPlayerItem:_item];

        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        _playerLayer.frame = _videoPreviewContainerView.frame;
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [_videoPreviewContainerView.layer addSublayer:_playerLayer];

        [self addSubview:_videoPreviewContainerView];
    }
    return _videoPreviewContainerView;
}

- (UIButton *)dismissBtn {
    if (!_dismissBtn) {
        _dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dismissBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_dismissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_dismissBtn];
        [_dismissBtn sizeToFit];
    }
    return _dismissBtn;
}

- (UIButton *)turnCamera {
    if (!_turnCamera) {
        _turnCamera = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_turnCamera setImage:[UIImage imageNamed:@"listing_camera_lens"] forState:UIControlStateNormal];
        [_turnCamera addTarget:self action:@selector(turnCameraAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_turnCamera];
        [_turnCamera sizeToFit];
    }
    return _turnCamera;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_cancelButton setImage:[UIImage imageNamed:@"icon_return_n"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelBtnfunc:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
        [_cancelButton sizeToFit];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_confirmButton setImage:[UIImage imageNamed:@"icon_finish_p"] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmBtnFunc:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_confirmButton];
        [_confirmButton sizeToFit];
    }
    return _confirmButton;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"点击拍照，长按摄像";
        _tipLabel.font = [UIFont systemFontOfSize:15];
        _tipLabel.textColor = [UIColor whiteColor];
        [self addSubview:_tipLabel];
        [_tipLabel sizeToFit];
    }
    return _tipLabel;
}

@end
