//
//  XLVideoPlayerView.h
//  OC_APP
//
//  Created by xingl on 2018/8/7.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VideoFillMode) {
    VideoFillModeResize = 0,       // 填充占满整个模仿器，不按原比例填充
    VideoFillModeResizeAspect,     // 按原视频比例填充，是竖屏的就显示出竖屏，两边留黑
    VideoFillModeResizeAspectFill  // 按原视频比例占满整个播放器，但视频内容超出部分会被剪切
};

typedef NS_ENUM(NSUInteger, TopToolBarHiddenType) {
    TopToolBarHiddenTypeNever = 0, // 大小屏都不隐藏
    TopToolBarHiddenTypeAlways,    // 大小屏都隐藏
    TopToolBarHiddenTypeSmall      // 小屏隐藏，大屏不隐藏
};

typedef NS_ENUM(NSUInteger, FullStatusBarHiddenType) {
    FullStatusBarHiddenNever = 0,     //一直不隐藏
    FullStatusBarHiddenAlways,        //一直隐藏
    FullStatusBarHiddenFollowToolBar, //跟随工具条，工具条隐藏就隐藏，工具条不隐藏就不隐藏
};

typedef void(^BackButtonBlock)(UIButton *button);
typedef void(^EndBlock)(void);


@interface XLVideoPlayerView : UIView
/** 后台返回是否自动播放，默认YES */
@property (nonatomic, assign) BOOL backPlay;
/** 重复播放，默认NO */
@property (nonatomic, assign) BOOL repeatPlay;
/** 当前页面是否支持横屏，默认NO */
@property (nonatomic, assign) BOOL isLandscape;
/** 自动旋转，默认YES */
@property (nonatomic, assign) BOOL autoRotate;
/** 静音，默认NO */
@property (nonatomic, assign) BOOL isMute;
/** 小屏手势控制,默认NO */
@property (nonatomic, assign) BOOL smallGestureControl;
/** 全屏手势控制,默认Yes */
@property (nonatomic, assign) BOOL fullGestureControl;;
/** 是否全屏 */
@property (nonatomic, assign, readonly) BOOL isFullScreen;
/** 工具条消失时间，默认5s */
@property (nonatomic, assign) NSInteger toolBarDisappearTime;
/** 填充方式，默认全屏填充 */
@property (nonatomic, assign) VideoFillMode videoFillMode;
/** 顶部工具条隐藏方式，默认不隐藏 */
@property (nonatomic, assign) TopToolBarHiddenType topToolBarHiddenType;
/** 全屏状态栏隐藏方式，默认不隐藏 */
@property (nonatomic, assign) FullStatusBarHiddenType fullStatusBarHiddenType;

/** 视频url */
@property (nonatomic, strong) NSURL *videoUrl;

/** 进度条背景颜色 */
@property (nonatomic, strong) UIColor *progressBackGroundColor;
/** 缓冲条缓冲进度颜色 */
@property (nonatomic, strong) UIColor *progressBufferColor;
/** 进度条播放完成颜色 */
@property (nonatomic, strong) UIColor *progressPlayFinishColor;
/** 转子线条颜色 */
@property (nonatomic, strong) UIColor *strokeColor;


/** 播放 */
- (void)playVideo;
/** 暂停 */
- (void)pausePlay;
/** 返回按钮回调方法，如果小屏会调用，全屏点击默认回到小屏 */
- (void)backButton:(BackButtonBlock)backButton;
/** 播放完成回调 */
- (void)endPlay:(EndBlock)end;
/** 销毁播放器 */
- (void)destroyPlayer;

@end
