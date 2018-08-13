//
//  XLVideoPlayerView.m
//  OC_APP
//
//  Created by xingl on 2018/8/7.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "XLVideoPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h> // 系统音量
#import "GCDTimer.h"
#import "XLVideoPlayerMaskView.h"

// 播放器的几种状态
typedef NS_ENUM(NSInteger, PlayerState) {
    PlayerStateFailed,     // 播放失败
    PlayerStateBuffering,  // 缓冲中
    PlayerStatePlaying,    // 播放中
    PlayerStateStopped,    // 停止播放
};
// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionHorizontalMoved, // 横向移动
    PanDirectionVerticalMoved,   // 纵向移动
};


@interface XLVideoPlayerView ()<XLVideoPlayerMaskViewDelegate, UIGestureRecognizerDelegate>

/** 播放器的几种状态 */
@property (nonatomic, assign) PlayerState state;
/** 控件原frame */
@property (nonatomic, assign) CGRect customFrame;
/** 父控件 */
@property (nonatomic, strong) UIView *superView;
/** 视频填充模式 */
@property (nonatomic, copy) NSString *fillMode;
/** 状态栏 */
@property (nonatomic, strong) UIView *statusBar;
/** 是否是全屏 */
@property (nonatomic, assign) BOOL isFullScreen;

/** 工具条隐藏标记 */
@property (nonatomic, assign) BOOL isDisappear;
/** 用户点击播放标记 */
@property (nonatomic, assign) BOOL isUserPlay;
/** 记录控制器状态栏状态 */
@property (nonatomic, assign) BOOL statusBarHiddenState;
/** 点击最大化标记 */
@property (nonatomic, assign) BOOL isUserTapMaxButton;
/** 播放完成标记 */
@property (nonatomic, assign) BOOL isEnd;

/** 保存快进的总时长 */
@property (nonatomic, assign) CGFloat sumTime;
/** 方向 */
@property (nonatomic, assign) PanDirection panDirection;
/** 是否在调节音量 */
@property (nonatomic, assign) BOOL isVolume;
/** 是否正在拖拽 */
@property (nonatomic, assign) BOOL isDragging;
/** 是否正在缓冲 */
@property (nonatomic, assign) BOOL isBuffering;
/** 音量滑杆 */
@property (nonatomic, strong) UISlider *volumeViewSlider;
/** 进度条定时器 */
@property (nonatomic, strong) GCDTimer *sliderTimer;
/** 点击定时器 */
@property (nonatomic, strong) GCDTimer *tapTimer;

/** 返回按钮回调 */
@property (nonatomic, copy) BackButtonBlock backBlock;

@property (nonatomic, copy) EndBlock endBlock;

/** 播放器 */
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;
/** 遮罩 */
@property (nonatomic, strong) XLVideoPlayerMaskView *playerMaskView;

@end

@implementation XLVideoPlayerView

- (void)dealloc {
    [self removeObserver];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    //回到竖屏
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    //重置状态条
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
    //恢复默认状态栏显示与否
    [self setStatusBarHidden:_statusBarHiddenState];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self configDefault];
        [self addNotification];
        [self initSubviews];
    }
    return self;
}

- (void)configDefault {
    self.isFullScreen = NO;
    self.isDragging = NO;
    self.isUserTapMaxButton = NO;
    self.isEnd = NO;
    self.repeatPlay = NO;
    self.isMute = NO;
    self.isLandscape = NO;
    self.smallGestureControl = NO;
    self.autoRotate = YES;
    self.fullGestureControl = YES;
    self.backPlay = YES;
    self.isUserPlay = YES;
    self.statusBarHiddenState = YES;
    self.progressBackGroundColor = [UIColor colorWithRed:0.54118 green:0.51373 blue:0.50980 alpha:1.00000];
    self.progressPlayFinishColor = [UIColor whiteColor];
    self.progressBufferColor     = [UIColor redColor];
    self.videoFillMode = VideoFillModeResize;
    self.topToolBarHiddenType = TopToolBarHiddenTypeNever;
    self.fullStatusBarHiddenType = FullStatusBarHiddenNever;
    self.toolBarDisappearTime = 3;
}

- (void)addNotification {

    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    // 转屏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    // app挂起通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayground:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)initSubviews {
//    self.backgroundColor = [UIColor blackColor];
    
//    v = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    v.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
//    v.strokeColor = [UIColor redColor];
////    [v startAnimation];
//    [self addSubview:v];
//
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(10, 100, 100, 50);
//    btn.backgroundColor = [UIColor orangeColor];
//    [btn addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:btn];
//
//    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn2.frame = CGRectMake(10, 200, 100, 50);
//    btn2.backgroundColor = [UIColor orangeColor];
//    [btn2 addTarget:self action:@selector(clicked2) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:btn2];
    [self configureVolume];
    [self addSubview:self.playerMaskView];
}

- (void)configureVolume {
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    _volumeViewSlider = nil;
    for (UIView *view in volumeView.subviews) {
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]) {
            _volumeViewSlider = (UISlider *)view;
            break;
        }
    }
}

#pragma mark - layoutSubviews
-(void)layoutSubviews{
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
    self.playerMaskView.frame    = self.bounds;
}

- (void)resetPlay {
    _isEnd = NO;
    [self.player seekToTime:CMTimeMake(0, 1) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self playVideo];
}

- (void)destroyAllTimer {
    [self.sliderTimer cancelTimer];
    self.sliderTimer = nil;
    [self.tapTimer cancelTimer];
    self.tapTimer = nil;
}

// 缓冲
- (void)bufferingSomeSecond {
    self.state = PlayerStateBuffering;
    _isBuffering = YES;
    // 需要先暂停一会再播放
    [self pausePlay];
    
    [self performSelector:@selector(bufferingSomeSecondEnd) withObject:@"Buffering" afterDelay:5];
    
}
// 缓冲结束
- (void)bufferingSomeSecondEnd {
    [self playVideo];
    _isBuffering = NO;
    if (!self.playerItem.isPlaybackLikelyToKeepUp) {
        [self bufferingSomeSecond];
    }
}

#pragma mark - public

- (void)playVideo {
    self.playerMaskView.playButton.selected = YES;
    if (_isEnd && self.playerMaskView.slider.value == 1) {
        [self resetPlay];
    }  else {
        [self.player play];
        [self.sliderTimer resumeTimer];
    }
}

- (void)pausePlay {
    self.playerMaskView.playButton.selected = NO;
    [_player pause];
    [self.sliderTimer suspendTimer];
}

- (void)backButton:(BackButtonBlock)backButton {
    self.backBlock = backButton;
}

- (void)endPlay:(EndBlock)end {
    self.endBlock = end;
}

- (void)destroyPlayer {
    [self pausePlay];
    [self destroyAllTimer];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(bufferingSomeSecondEnd) object:@"Buffering"];
    [self.playerMaskView.loadingView destroyAnimation];
    self.playerMaskView.loadingView = nil;
    self.playerMaskView = nil;
    self.player = nil;
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer = nil;
    [self removeFromSuperview];
}

- (void)resetPlayer {
    self.state = PlayerStateStopped;
    _isUserPlay = YES;
    _isDisappear = NO;
    [self pausePlay];
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer = nil;
    self.player = nil;
    
    self.playerMaskView.slider.value = 0;
    [self.playerMaskView.progress setProgress:0.0];
    self.playerMaskView.currentTimeLabel.text = @"00:00";
    self.playerMaskView.totalTimeLabel.text = @"00:00";
    [self.sliderTimer resumeTimer];
    [self destroyToolBarTimer];
    //重置定时消失
    [UIView animateWithDuration:0.5 animations:^{
        self.playerMaskView.topToolBar.alpha    = 1.0;
        self.playerMaskView.bottomToolBar.alpha = 1.0;
    }];
    self.toolBarDisappearTime = _toolBarDisappearTime;
    self.playerMaskView.failButton.hidden = YES;
    
    [self.playerMaskView.loadingView startAnimation];
}


#pragma mark - action

- (void)panDirection:(UIPanGestureRecognizer *)panGesture {
    // 根据在view上Pan的位置，确定是调节音量还是亮度
    CGPoint locationPoint = [panGesture locationInView:self];
    // 响应水平移动和垂直移动
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [panGesture velocityInView:self];
    // 判断垂直移动还是水平移动
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan: {
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) { // 水平移动
                [self progressSliderTouchBegan:nil];
                // 显示
                [UIView animateWithDuration:0.5 animations:^{
                    self.playerMaskView.topToolBar.alpha = 1.0;
                    self.playerMaskView.bottomToolBar.alpha = 1.0;
                }];
                if (_fullStatusBarHiddenType == FullStatusBarHiddenFollowToolBar && _isFullScreen) {
                    [self setStatusBarHidden:NO];
                }
                self.panDirection = PanDirectionHorizontalMoved;
                // 给sumTime初始化
                CMTime time = self.player.currentTime;
                self.sumTime = time.value / time.timescale;
            } else if (x < y) { //垂直移动
                self.panDirection = PanDirectionVerticalMoved;
                // 开始滑动的时候，状态改为正在控制音量
                if (locationPoint.x > self.bounds.size.width / 2.0) {
                    // 右边调节音量
                    self.isVolume = YES;
                } else {
                    // 左边调节亮度
                    self.isVolume = NO;
                }
            }
        }
            break;
        case UIGestureRecognizerStateChanged: { // 正在移动
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:
                    [self horizontalMoved:veloctyPoint.x];
                    break;
                    
                case PanDirectionVerticalMoved:
                    [self verticalMoved:veloctyPoint.y];
                    break;
            }
            
        }
            break;
        case UIGestureRecognizerStateEnded: { // 移动停止
            // 移动结束也需要判断是垂直还是平移
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved: {
                    self.sumTime = 0;
                    [self progressSliderTouchEnded:nil];
                }
                    break;
                case PanDirectionVerticalMoved:{
                    // 移动结束，把状态改为不是在调节音量
                    self.isVolume = NO;
                }
                    break;
            }
        }
            break;
        default:
            break;
    }
}
/** 播放进度调节 */
- (void)horizontalMoved:(CGFloat)value {
    if (value == 0) return;
    // 每次滑动需要叠加时间
    self.sumTime += value / 200;
    CMTime totalTime = self.playerItem.duration;
    CGFloat totalMovieDuration = (CGFloat)totalTime.value / totalTime.timescale;
    if (self.sumTime > totalMovieDuration) {
        self.sumTime = totalMovieDuration;
    }
    if (self.sumTime < 0) {
        self.sumTime = 0;
    }
    BOOL style = value > 0 ? YES : NO;
    self.isDragging = YES;
    // 计算出拖动的当前秒数
    CGFloat dragedSeconds = self.sumTime;
    // 滑杆进度
    CGFloat sliderValue = dragedSeconds / totalMovieDuration;
    self.playerMaskView.slider.value = sliderValue;
    // 转换CMTime
    CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
    [self.player seekToTime:dragedCMTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    NSInteger progressMin = (NSInteger)CMTimeGetSeconds(dragedCMTime) / 60;
    NSInteger progressSec = (NSInteger)CMTimeGetSeconds(dragedCMTime) % 60;
    self.playerMaskView.currentTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)progressMin, (long)progressSec];
}
/** 音量/亮度 调节 */
- (void)verticalMoved:(CGFloat)value {
    self.isVolume ? (self.volumeViewSlider.value -= value / 10000) : ([UIScreen mainScreen].brightness -= value / 10000);
}

- (void)disappearAction:(UITapGestureRecognizer *)tapGesture {
    // 取消定时消失
    [self destroyToolBarTimer];
    if (!_isDisappear) {
        [UIView animateWithDuration:0.5 animations:^{
            self.playerMaskView.topToolBar.alpha = 0.0;
            self.playerMaskView.bottomToolBar.alpha = 0.0;
        }];
    } else {
        // 重新添加工具条定时消失定时器
        self.toolBarDisappearTime = _toolBarDisappearTime;
        // 重置定时消失
        [UIView animateWithDuration:0.5 animations:^{
            self.playerMaskView.topToolBar.alpha    = 1.0;
            self.playerMaskView.bottomToolBar.alpha = 1.0;
        }];
    }
    if (_fullStatusBarHiddenType == FullStatusBarHiddenFollowToolBar && _isFullScreen) {
        [self setStatusBarHidden:!_isDisappear];
    }
    _isDisappear = !_isDisappear;
}

#pragma mark - NSNotification Action
- (void)orientationChange:(NSNotification *)notification {
    if (_autoRotate) {
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (orientation == UIDeviceOrientationLandscapeLeft) {
            if (!_isFullScreen) {
                if (_isLandscape) {
                    // 播放器所在控制器页面支持旋转情况下，和正常情况相反
                    [self fullScreenWithDirection:UIInterfaceOrientationLandscapeRight];
                } else {
                    [self fullScreenWithDirection:UIInterfaceOrientationLandscapeLeft];
                }
            }
        } else if (orientation == UIDeviceOrientationLandscapeRight) {
            if (!_isFullScreen) {
                if (_isLandscape) {
                    [self fullScreenWithDirection:UIInterfaceOrientationLandscapeLeft];
                } else {
                    [self fullScreenWithDirection:UIInterfaceOrientationLandscapeRight];
                }
            }
        } else if (orientation == UIDeviceOrientationPortrait) {
            if (_isFullScreen) {
                [self originalscreen];
            }
        }
    }
}

- (void)appDidEnterBackground:(NSNotification *)notification {
    [self pausePlay];
}

- (void)appDidEnterPlayground:(NSNotification *)notification {
    // 继续播放
    if (_isUserPlay && _backPlay) {
        [self playVideo];
    }
}

- (void)moviePlayDidEnd:(NSNotification *)notif {
    _isEnd = YES;
    if (!_repeatPlay) {
        [self pausePlay];
    } else {
        [self resetPlay];
    }
    if (self.endBlock) {
        self.endBlock();
    }
}


#pragma mark - 监听

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {

    if ([keyPath isEqualToString:@"status"]) {
        /**
         预播放状态，有三种情况
         AVPlayerItemStatusUnknown,AVPlayerItemStatusReadyToPlay,AVPlayerItemStatusFailed
         */
        if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
            /**
             加载完成后，在添加平移手势
             添加平移手势，用来控制音量，亮度，快进快退
             */
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDirection:)];
            pan.delegate = self;
            [pan setMaximumNumberOfTouches:1];
            [pan setDelaysTouchesBegan:YES];
            [pan setDelaysTouchesEnded:YES];
            [pan setCancelsTouchesInView:YES];
            [self.playerMaskView addGestureRecognizer:pan];
            self.player.muted = self.isMute;
        } else if (self.player.currentItem.status == AVPlayerItemStatusFailed) {
            self.state = PlayerStateFailed;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        // 缓冲进度，可有可无，可以增加用户体验
        NSTimeInterval timeInterval = [self availableDuration];
        CMTime duration = self.playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        [self.playerMaskView.progress setProgress:timeInterval / totalDuration animated:NO];
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
        // seekToTime后，缓冲数据为空，而且有效时间内数据无法补充，播放失败
        if (self.playerItem.isPlaybackBufferEmpty) {
            [self bufferingSomeSecond];
        }
    }
}

#pragma mark - timer action
- (void)timeStack {
    if (self.playerItem.duration.timescale != 0) {
        // 设置进度条
        self.playerMaskView.slider.maximumValue = 1;
        self.playerMaskView.slider.value = CMTimeGetSeconds([self.playerItem currentTime]) / (self.playerItem.duration.value / self.playerItem.duration.timescale);
        // 判断是否真正在播放
        if (self.playerItem.isPlaybackLikelyToKeepUp && self.playerMaskView.slider > 0) {
            self.state = PlayerStatePlaying;
        }
        //当前时长
        NSInteger progressMin = (NSInteger)CMTimeGetSeconds([self.playerItem currentTime]) / 60; // 当前分钟
        NSInteger progressSec = (NSInteger)CMTimeGetSeconds([self.playerItem currentTime]) % 60; // 当前秒
        self.playerMaskView.currentTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)progressMin, (long)progressSec];
        // 总时长
        NSInteger durationMin = (NSInteger)self.playerItem.duration.value / self.playerItem.duration.timescale / 60; // 分钟
        NSInteger durationSec = (NSInteger)self.playerItem.duration.value / self.playerItem.duration.timescale % 60; // 秒
        self.playerMaskView.totalTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)durationMin, (long)durationSec];
    }
}

- (void)disappear {
    [UIView animateWithDuration:0.5 animations:^{
        self.playerMaskView.topToolBar.alpha = 0.0;
        self.playerMaskView.bottomToolBar.alpha = 0.0;
    }];
    if (_fullStatusBarHiddenType == FullStatusBarHiddenFollowToolBar && _isFullScreen) {
        [self setStatusBarHidden:YES];
    }
    _isDisappear = YES;
}


#pragma mark - private

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
}

- (void)setStatusBarHidden:(BOOL)hidden{
    //设置是否隐藏
    self.statusBar.hidden = hidden;
}

/** 销毁定时消失定时器 */
- (void)destroyToolBarTimer{
    [self.tapTimer cancelTimer];
    self.tapTimer = nil;
}

- (void)originalscreen {
    _isFullScreen = NO;
    _isUserTapMaxButton = NO;
    self.topToolBarHiddenType = _topToolBarHiddenType;
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
    if (self.isLandscape) {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
        [self setStatusBarHidden:_statusBarHiddenState];
    } else {
        [self setStatusBarHidden:YES];
        CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        [UIView animateWithDuration:duration animations:^{
            self.transform = CGAffineTransformMakeRotation(0);
        }completion:^(BOOL finished) {
            [self setStatusBarHidden:_statusBarHiddenState];
        }];
    }
    self.frame = _customFrame;
    [self.superView addSubview:self];
    self.playerMaskView.fullButton.selected = NO;
    self.statusBar.userInteractionEnabled = YES;
}

- (void)fullScreenWithDirection:(UIInterfaceOrientation)direction {
    // 记录播放器父类
    self.superView = self.superview;
    // 记录原始大小
    _customFrame = self.frame;
    _isFullScreen = YES;
    
    self.topToolBarHiddenType = _topToolBarHiddenType;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    if (_isLandscape) {
        // 手动点击需要旋转方向
        if (_isUserTapMaxButton) {
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
        }
        [self hiddenStatusBarWithFullStatusBarHiddenType];
    } else {
        // 播放器所在控制器不支持选择，采用旋转view的方式实现
        [self setStatusBarHidden:YES];
        CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        if (direction == UIInterfaceOrientationLandscapeLeft) {
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
            [UIView animateWithDuration:duration animations:^{
                self.transform = CGAffineTransformMakeRotation(M_PI_2);
            } completion:^(BOOL finished) {
                [self hiddenStatusBarWithFullStatusBarHiddenType];
            }];
        } else if (direction == UIInterfaceOrientationLandscapeRight) {
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
            [UIView animateWithDuration:duration animations:^{
                self.transform = CGAffineTransformMakeRotation(-M_PI_2);
            } completion:^(BOOL finished) {
                [self hiddenStatusBarWithFullStatusBarHiddenType];
            }];
        }
    }
    self.playerMaskView.fullButton.selected = YES;
    self.frame = keyWindow.bounds;
    self.statusBar.userInteractionEnabled = NO;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)hiddenStatusBarWithFullStatusBarHiddenType {
    switch (_fullStatusBarHiddenType) {
        case FullStatusBarHiddenNever:
            [self setStatusBarHidden:NO];
            break;
        case FullStatusBarHiddenAlways:
            [self setStatusBarHidden:YES];
            break;
        case FullStatusBarHiddenFollowToolBar:
            [self setStatusBarHidden:_isDisappear];
            break;
    }
}
/** 缓冲进度 */
- (NSTimeInterval)availableDuration {
    NSArray *loadTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadTimeRanges.firstObject CMTimeRangeValue]; // 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds; // 缓冲总进度
    return result;
}

#pragma mark - UIGestureRecognizerDelegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ((!_smallGestureControl && !_isFullScreen) || (!_fullGestureControl && _isFullScreen)) {
        return NO;
    }
    if ([touch.view isDescendantOfView:self.playerMaskView.bottomToolBar]) {
        return  NO;
    }
    return YES;
}

#pragma mark - XLVideoPlayerMaskViewDelegate

/**返回按钮代理*/
- (void)backAction:(UIButton *)button {
    if (_isFullScreen) {
        [self originalscreen];
    } else {
        if (self.backBlock) self.backBlock(button);
    }
    self.toolBarDisappearTime = _toolBarDisappearTime;
}
/**播放按钮代理*/
- (void)playAction:(UIButton *)button {
    if (!button.selected) {
        _isUserPlay = NO;
        [self pausePlay];
    } else {
        _isUserPlay = YES;
        [self playVideo];
    }
    self.toolBarDisappearTime = _toolBarDisappearTime;
}
/**全屏按钮代理*/
- (void)fullAction:(UIButton *)button {
    if (!_isFullScreen) {
        _isUserTapMaxButton = YES;
        [self fullScreenWithDirection:UIInterfaceOrientationLandscapeLeft];
    } else {
        [self originalscreen];
    }
    self.toolBarDisappearTime = _toolBarDisappearTime;
}
/**失败按钮代理*/
- (void)failAction:(UIButton *)button {
    [self setVideoUrl:_videoUrl];
    [self playVideo];
}
/**开始滑动*/
- (void)progressSliderTouchBegan:(XLSlider *)slider {
    
    [self pausePlay];
    [self destroyToolBarTimer];
}
/**滑动中*/
- (void)progressSliderValueChanged:(XLSlider *)slider {
    // 计算出拖动的当前秒数
    CGFloat total = (CGFloat)self.playerItem.duration.value / self.playerItem.duration.timescale; // 总时长
    CGFloat dragedSeconds = total * slider.value;
    // 转换CMTime才能给player来控制播放进度
    CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
    [self.player seekToTime:dragedCMTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    NSInteger progressMin = (NSInteger)CMTimeGetSeconds(dragedCMTime) / 60; //分钟
    NSInteger progressSec = (NSInteger)CMTimeGetSeconds(dragedCMTime) % 60; //秒
    self.playerMaskView.currentTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)progressMin, (long)progressSec];
}
/**滑动结束*/
- (void)progressSliderTouchEnded:(XLSlider *)slider {
    if (slider.value != 1) {
        _isEnd = NO;
    }
    if (!self.playerItem.isPlaybackLikelyToKeepUp) {
        [self bufferingSomeSecond];
    } else {
        [self playVideo];
    }
    self.toolBarDisappearTime = _toolBarDisappearTime;
}

#pragma mark - setter
- (void)setVideoFillMode:(VideoFillMode)videoFillMode {
    _videoFillMode = videoFillMode;
    switch (videoFillMode) {
        case VideoFillModeResize:
            // 填充视频内容达到边框占满，但不按原比例拉伸
            _fillMode = AVLayerVideoGravityResize;
            break;
        case VideoFillModeResizeAspect:
            // 原比例显示
            _fillMode = AVLayerVideoGravityResizeAspect;
            break;
        case VideoFillModeResizeAspectFill:
            _fillMode = AVLayerVideoGravityResizeAspectFill;
            break;
    }
}

- (void)setTopToolBarHiddenType:(TopToolBarHiddenType)topToolBarHiddenType {
    _topToolBarHiddenType = topToolBarHiddenType;
    switch (topToolBarHiddenType) {
        case TopToolBarHiddenTypeNever:
            self.playerMaskView.topToolBar.hidden = NO;
            break;
        case TopToolBarHiddenTypeAlways:
            self.playerMaskView.topToolBar.hidden = YES;
            break;
        case TopToolBarHiddenTypeSmall:
            self.playerMaskView.topToolBar.hidden = !self.isFullScreen;
            break;
    }
}

- (void)setFullStatusBarHiddenType:(FullStatusBarHiddenType)fullStatusBarHiddenType {
    _fullStatusBarHiddenType = fullStatusBarHiddenType;
//    switch (fullStatusBarHiddenType) {
//        case FullStatusBarHiddenNever:
//            <#statements#>
//            break;
//
//        default:
//            break;
//    }
}

- (void)setProgressBackGroundColor:(UIColor *)progressBackGroundColor {
    _progressBackGroundColor = progressBackGroundColor;
    self.playerMaskView.progressBackgroundColor = progressBackGroundColor;
}

- (void)setProgressBufferColor:(UIColor *)progressBufferColor {
    _progressBufferColor = progressBufferColor;
    self.playerMaskView.progressBufferColor = progressBufferColor;
}

- (void)setProgressPlayFinishColor:(UIColor *)progressPlayFinishColor {
    _progressPlayFinishColor = progressPlayFinishColor;
    self.playerMaskView.progressPlayFinishColor = progressPlayFinishColor;
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    _strokeColor = strokeColor;
    self.playerMaskView.loadingView.strokeColor = strokeColor;
}

- (void)setSmallGestureControl:(BOOL)smallGestureControl {
    _smallGestureControl = smallGestureControl;
}

- (void)setFullGestureControl:(BOOL)fullGestureControl {
    _fullGestureControl = fullGestureControl;
}

- (void)setIsLandscape:(BOOL)isLandscape {
    _isLandscape = isLandscape;
}

- (void)setAutoRotate:(BOOL)autoRotate {
    _autoRotate = autoRotate;
}

- (void)setRepeatPlay:(BOOL)repeatPlay {
    _repeatPlay = repeatPlay;
}

- (void)setIsMute:(BOOL)isMute {
    _isMute = isMute;
    self.player.muted = isMute;
}

- (void)setBackPlay:(BOOL)backPlay {
    _backPlay = backPlay;
}

- (void)setToolBarDisappearTime:(NSInteger)toolBarDisappearTime {
    _toolBarDisappearTime = toolBarDisappearTime;
    [self destroyToolBarTimer];
    [self.tapTimer startTimer];
}

- (void)setVideoUrl:(NSURL *)videoUrl {
    _videoUrl = videoUrl;
    [self resetPlayer];
    self.playerItem = [AVPlayerItem playerItemWithAsset:[AVAsset assetWithURL:videoUrl]];
    if (self.player) {
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    } else {
        self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    }
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.videoGravity = AVLayerVideoGravityResize;
    // 设置静音模式播放声音
    AVAudioSession * session  = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    self.playerLayer.videoGravity = _fillMode;
    
    [self.layer insertSublayer:self.playerLayer atIndex:0];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [self addObserver];
}

- (void)setState:(PlayerState)state {
    if (_state == state) return;
    _state = state;
    if (state == PlayerStateBuffering) {
        [self.playerMaskView.loadingView startAnimation];
    } else if (state == PlayerStateFailed) {
        [self.playerMaskView.loadingView stopAnimation];
        self.playerMaskView.failButton.hidden = NO;
        self.playerMaskView.playButton.selected = NO;
    } else {
        [self.playerMaskView.loadingView stopAnimation];
        if (_isUserPlay) {
            [self playVideo];
        }
    }
}

#pragma mark - getter
- (XLVideoPlayerMaskView *)playerMaskView {
    if (!_playerMaskView) {
        _playerMaskView = [[XLVideoPlayerMaskView alloc] init];
        _playerMaskView.progressBackgroundColor = self.progressBackGroundColor;
        _playerMaskView.progressBufferColor = self.progressBufferColor;
        _playerMaskView.progressPlayFinishColor = self.progressPlayFinishColor;
        _playerMaskView.delegate = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappearAction:)];
        [_playerMaskView addGestureRecognizer:tap];
        //计时器，循环执行
        [self.sliderTimer startTimer];
    }
    return _playerMaskView;
}

- (GCDTimer *)sliderTimer {
    if (!_sliderTimer) {
        __weak typeof(self) weakSelf = self;
        _sliderTimer = [[GCDTimer alloc] initDispatchTimerWithInterval:1.0f delaySecs:0 queue:dispatch_get_main_queue() repeats:YES action:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf timeStack];
        }];
    }
    return _sliderTimer;
}

- (GCDTimer *)tapTimer {
    if (!_tapTimer) {
        __weak typeof(self) weakSelf = self;
        _tapTimer = [[GCDTimer alloc] initDispatchTimerWithInterval:_toolBarDisappearTime delaySecs:_toolBarDisappearTime queue:dispatch_get_main_queue() repeats:YES action:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf disappear];
        }];
    }
    return _tapTimer;
}

- (UIView *)statusBar {
    if (_statusBar == nil){
        _statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    }
    return _statusBar;
}

@end
