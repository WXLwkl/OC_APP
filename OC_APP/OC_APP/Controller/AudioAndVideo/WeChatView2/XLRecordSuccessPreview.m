//
//  XLRecordSuccessPreview.m
//  OC_APP
//
//  Created by xingl on 2018/9/21.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "XLRecordSuccessPreview.h"
#import <AVKit/AVKit.h>

@interface XLRecordSuccessPreview() {
    float _width;
    float _distance;
}
@property (nonatomic ,strong) UIButton *cancelButton;
@property (nonatomic ,strong) UIButton *sendButton;
@property (nonatomic ,strong) UIImage *image;// 拍摄的图片
@property (nonatomic ,  copy) NSString *videoPath; // 拍摄的视频地址
@property (nonatomic ,assign) BOOL isPhoto;// 是否是图片
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_8_4
@property (nonatomic ,strong) AVPlayerViewController *avPlayer;
#endif
@property (nonatomic ,assign) AVCaptureVideoOrientation orientation;

@end
@implementation XLRecordSuccessPreview
- (void)setImage:(UIImage *)image videoPath:(NSString *)videoPath captureVideoOrientation:(AVCaptureVideoOrientation)orientation{
    _image = image;
    _videoPath = videoPath;
    _orientation = orientation;
    self.backgroundColor = [UIColor blackColor];
    if (_image && !videoPath) {
        _isPhoto = YES;
    }
    [self setupUI];
}
- (void)setupUI{
    
    if (_isPhoto) {
        UIImageView *imageview = [[UIImageView alloc]initWithImage:_image];
        imageview.frame = self.bounds;
        if (_orientation == AVCaptureVideoOrientationLandscapeRight || _orientation ==AVCaptureVideoOrientationLandscapeLeft) {
            imageview.contentMode = UIViewContentModeScaleAspectFit;
        }
        [self addSubview:imageview];
    } else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
        MPMoviePlayerController *mpPlayer = [[MPMoviePlayerController alloc]initWithContentURL:[NSURL fileURLWithPath:_videoPath]];
        mpPlayer.view.frame = self.bounds;
        mpPlayer.controlStyle = MPMovieControlStyleNone;
        mpPlayer.movieSourceType = MPMovieSourceTypeFile;
        mpPlayer.repeatMode = MPMovieRepeatModeOne;
        [mpPlayer prepareToPlay];
        [mpPlayer play];
        [self addSubview:mpPlayer.view];
#else
        AVPlayerViewController *avPlayer = [[AVPlayerViewController alloc]init];
        avPlayer.view.frame = self.bounds;
        avPlayer.showsPlaybackControls = NO;
        avPlayer.videoGravity = AVLayerVideoGravityResizeAspect;
        avPlayer.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:_videoPath]];
        [avPlayer.player play];
        [self addSubview:avPlayer.view];
        _avPlayer = avPlayer;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replay) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
#endif
    }
    _width = 148/2;
    _distance = 120/2;
    // 取消
    _cancelButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_cancelButton setImage:[UIImage imageNamed:@"icon_return_n"] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelButton];
    [_cancelButton sizeToFit];
    
    _cancelButton.bounds = CGRectMake(0, 0, _width, _width);
    _cancelButton.center = CGPointMake(self.center.x, self.bounds.size.height -_distance - _width/2);
    
    // 发送
    _sendButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_sendButton setImage:[UIImage imageNamed:@"icon_finish_p"] forState:UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sendButton];
    [_sendButton sizeToFit];
    
    _sendButton.bounds = CGRectMake(0, 0, _width, _width);
    _sendButton.center = CGPointMake(self.center.x, self.bounds.size.height - _distance - _width/2);

}
-(void)layoutSubviews{
    [super layoutSubviews];
    NSLog(@"预览图");
    [UIView animateWithDuration:0.25 animations:^{
        _cancelButton.bounds = CGRectMake(0, 0, _width, _width);
        _cancelButton.center = CGPointMake(self.bounds.size.width / 4, self.bounds.size.height -_distance - _width/2);
        _sendButton.bounds = CGRectMake(0, 0, _width, _width);
        _sendButton.center = CGPointMake(self.bounds.size.width / 4 * 3, self.bounds.size.height - _distance - _width/2);
    }];
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_8_4
- (void)replay{
    if (_avPlayer) {
        [_avPlayer.player seekToTime:CMTimeMake(0, 1)];
        [_avPlayer.player play];
    }
}
#endif
- (void)cancel{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}
- (void)send{
    if (self.sendBlock) {
        self.sendBlock(_image, _videoPath);
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__func__);
}
@end
