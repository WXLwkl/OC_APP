//
//  XLVideoPlayerMaskView.h
//  OC_APP
//
//  Created by xingl on 2018/8/7.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "XLSlider.h"

@protocol XLVideoPlayerMaskViewDelegate <NSObject>

/**返回按钮代理*/
- (void)backAction:(UIButton *)button;
/**播放按钮代理*/
- (void)playAction:(UIButton *)button;
/**全屏按钮代理*/
- (void)fullAction:(UIButton *)button;
/**失败按钮代理*/
- (void)failAction:(UIButton *)button;
/**开始滑动*/
- (void)progressSliderTouchBegan:(XLSlider *)slider;
/**滑动中*/
- (void)progressSliderValueChanged:(XLSlider *)slider;
/**滑动结束*/
- (void)progressSliderTouchEnded:(XLSlider *)slider;

@end

@interface XLVideoPlayerMaskView : UIView
/** 顶部工具条 */
@property (nonatomic, strong) UIView *topToolBar;
/** 底部工具条 */
@property (nonatomic, strong) UIView *bottomToolBar;
/** 顶部工具条返回按钮 */
@property (nonatomic,strong) UIButton *backButton;
/** 底部工具条播放按钮 */
@property (nonatomic,strong) UIButton *playButton;
/** 底部工具条全屏按钮 */
@property (nonatomic,strong) UIButton *fullButton;
/** 底部工具条当前播放时间 */
@property (nonatomic,strong) UILabel *currentTimeLabel;
/** 底部工具条视频总时间 */
@property (nonatomic,strong) UILabel *totalTimeLabel;
/** 缓冲进度条 */
@property (nonatomic,strong) UIProgressView *progress;

/** 转子 */
@property (nonatomic,strong) LoadingView *loadingView;

/**播放进度条*/
@property (nonatomic,strong) XLSlider *slider;
/**加载失败按钮*/
@property (nonatomic,strong) UIButton *failButton;
/**代理人*/
@property (nonatomic,weak) id<XLVideoPlayerMaskViewDelegate> delegate;
/**进度条背景颜色*/
@property (nonatomic,strong) UIColor *progressBackgroundColor;
/**缓冲条缓冲进度颜色*/
@property (nonatomic,strong) UIColor *progressBufferColor;
/**进度条播放完成颜色*/
@property (nonatomic,strong) UIColor *progressPlayFinishColor;

@end
