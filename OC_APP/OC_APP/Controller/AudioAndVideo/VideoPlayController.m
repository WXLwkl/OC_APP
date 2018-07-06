//
//  VideoPlayController.m
//  OC_APP
//
//  Created by xingl on 2018/6/25.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "VideoPlayController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface VideoPlayController ()

@property (nonatomic, strong) MPMoviePlayerController *videoPlayer;

@property (nonatomic, strong) UIImage *videoCover;

@end

@implementation VideoPlayController

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    self.videoPlayer.contentURL = self.videoUrl;
    [self.videoPlayer play];
    
    [self initSubviews];
    
    
    [self addNotification];
}

- (void)initSubviews {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"video_play_nav_bg"];
    imageView.frame = CGRectMake(0, 0, kScreenWidth, 44);
    imageView.userInteractionEnabled = YES;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(0, 0, 44, 44);
    [imageView addSubview:cancelBtn];
    
    UIButton *Done = [UIButton buttonWithType:UIButtonTypeCustom];
    [Done addTarget:self action:@selector(DoneAction) forControlEvents:UIControlEventTouchUpInside];
    [Done setTitle:@"Done" forState:UIControlStateNormal];
    Done.frame = CGRectMake(kScreenWidth - 70, 0, 50, 44);
    [imageView addSubview:Done];
    
    self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:imageView];
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(captureFinished:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateChanged) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.videoPlayer];
}


#pragma mark - Notification Action
- (void)captureFinished:(NSNotification *)notification {
    self.videoCover = notification.userInfo[MPMoviePlayerThumbnailImageKey];
    if (self.videoCover == nil) {
        self.videoCover = [self coverIamgeAtTime:1];
    }
}

- (UIImage*)coverIamgeAtTime:(NSTimeInterval)time {
    [self.videoPlayer requestThumbnailImagesAtTimes:@[@(time)] timeOption:MPMovieTimeOptionNearestKeyFrame];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:self.videoUrl options:nil];
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef) NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] :[UIImage new];
    return thumbnailImage;
}

- (void)stateChanged {
    switch (self.videoPlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:
            NSLog(@"播放中...");
            break;
        case MPMoviePlaybackStatePaused:
            NSLog(@"暂停");
            break;
        case MPMoviePlaybackStateStopped:
            // 执行[self.videoPlayer stop] 或者 前进 后退 不工作时触发
            NSLog(@"停止");
            break;
        default:
            break;
    }
}
- (void)videoFinished:(NSNotification *)notification {
    int value = [[notification.userInfo valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    if (value == MPMovieFinishReasonPlaybackEnded) {   // 视频播放结束
        
    }
}

- (void)dismissAction {
    [self.videoPlayer stop];
    self.videoPlayer = nil;
    [self.navigationController popViewControllerAnimated:YES];
    [self xl_closeSelfAction];
}
- (void)DoneAction {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.videoPlayer stop];
    self.videoPlayer = nil;
}
#pragma mark - getter && setter

- (MPMoviePlayerController *)videoPlayer {
    if (!_videoPlayer) {
        _videoPlayer = [[MPMoviePlayerController alloc] init];
        [_videoPlayer.view setFrame:self.view.bounds];
        _videoPlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_videoPlayer prepareToPlay];
        _videoPlayer.controlStyle = MPMovieControlStyleNone;
        _videoPlayer.shouldAutoplay = NO;
        _videoPlayer.repeatMode = MPMovieRepeatModeOne;
        
        [self.view addSubview:_videoPlayer.view];
    }
    return _videoPlayer;
}


@end
