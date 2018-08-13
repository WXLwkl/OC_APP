//
//  XLVideoPlayerMaskView.m
//  OC_APP
//
//  Created by xingl on 2018/8/7.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "XLVideoPlayerMaskView.h"

#import <Masonry.h>

//间隙
#define Margin        10
//顶部底部工具条高度
#define ToolBarHeight     50


@implementation XLVideoPlayerMaskView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    [self addSubview:self.topToolBar];
    [self addSubview:self.bottomToolBar];
    [self addSubview:self.loadingView];
    [self addSubview:self.failButton];
    
    [self.topToolBar addSubview:self.backButton];
    
    [self.bottomToolBar addSubview:self.playButton];
    [self.bottomToolBar addSubview:self.currentTimeLabel];
    [self.bottomToolBar addSubview:self.progress];
    [self.bottomToolBar addSubview:self.slider];
    [self.bottomToolBar addSubview:self.totalTimeLabel];
    [self.bottomToolBar addSubview:self.fullButton];
    
    self.topToolBar.backgroundColor    = [UIColor colorWithRed:0.00000f green:0.00000f blue:0.00000f alpha:0.20000f];
    self.bottomToolBar.backgroundColor = [UIColor colorWithRed:0.00000f green:0.00000f blue:0.00000f alpha:0.20000f];
    
}

#pragma mark - 布局
-(void)layoutSubviews{
    [super layoutSubviews];

    [self makeConstraints];
}

- (void)makeConstraints {
    [self.topToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self);
        make.height.mas_equalTo(ToolBarHeight);
    }];
    [self.bottomToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self);
        make.height.mas_equalTo(ToolBarHeight);
    }];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(Margin);
        make.bottom.mas_equalTo(-Margin);
        make.width.mas_equalTo(self.backButton.mas_height);
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(Margin);
        make.bottom.mas_equalTo(-Margin);
        make.width.mas_equalTo(self.playButton.mas_height);
    }];
    [self.fullButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Margin);
        make.right.bottom.mas_equalTo(-Margin);
        make.width.mas_equalTo(self.fullButton.mas_height);
    }];
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.playButton.mas_right).mas_offset(Margin);
        make.width.mas_equalTo(45);
        make.centerY.mas_equalTo(self.bottomToolBar);
    }];
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.fullButton.mas_left).mas_offset(-Margin);
        make.width.mas_equalTo(45);
        make.centerY.mas_equalTo(self.currentTimeLabel);
    }];
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.currentTimeLabel.mas_right).mas_offset(Margin);
        make.right.mas_equalTo(self.totalTimeLabel.mas_left).mas_offset(-Margin);
        make.height.mas_equalTo(2);
        make.centerY.mas_equalTo(self.currentTimeLabel);
    }];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.progress);
    }];
    [self.failButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
}

#pragma mark - button action
// 返回
- (void)backButtonAction:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backAction:)]) {
        [self.delegate backAction:btn];
    }
}
// 播放/暂停
- (void)playButtonAction:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(playAction:)]) {
        [self.delegate playAction:btn];
    }
}
// 全屏/小屏
- (void)fullButtonAction:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(fullAction:)]) {
        [self.delegate fullAction:btn];
    }
}
// 失败
- (void)failButtonAction:(UIButton *)btn {
    self.failButton.hidden = YES;
    self.loadingView.hidden = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(failAction:)]) {
        [self.delegate failAction:btn];
    }
}

- (void)sliderTouchBegan:(XLSlider *)slider {
    if (self.delegate && [self.delegate respondsToSelector:@selector(progressSliderTouchBegan:)]) {
        [self.delegate progressSliderTouchBegan:slider];
    }
}

- (void)sliderValueChanged:(XLSlider *)slider {
    if (self.delegate && [self.delegate respondsToSelector:@selector(progressSliderValueChanged:)]) {
        [self.delegate progressSliderValueChanged:slider];
    }
}

- (void)sliderTouchEnded:(XLSlider *)slider {
    if (self.delegate && [self.delegate respondsToSelector:@selector(progressSliderTouchEnded:)]) {
        [self.delegate progressSliderTouchEnded:slider];
    }
}

#pragma mark - setter
- (void)setProgressBackgroundColor:(UIColor *)progressBackgroundColor {
    _progressBackgroundColor = progressBackgroundColor;
    _progress.trackTintColor = progressBackgroundColor;
}

- (void)setProgressBufferColor:(UIColor *)progressBufferColor {
    _progressBufferColor = progressBufferColor;
    _progress.progressTintColor = progressBufferColor;
}

- (void)setProgressPlayFinishColor:(UIColor *)progressPlayFinishColor {
    _progressPlayFinishColor = progressPlayFinishColor;
    _slider.minimumTrackTintColor = progressPlayFinishColor;
}

#pragma mark - getter
//顶部工具条
- (UIView *)topToolBar {
    if (!_topToolBar) {
        _topToolBar = [[UIView alloc] init];
    }
    return _topToolBar;
}
//底部工具条
- (UIView *)bottomToolBar {
    if (!_bottomToolBar) {
        _bottomToolBar = [[UIView alloc] init];
    }
    return _bottomToolBar;
}

- (UIButton *)backButton {
    if (_backButton == nil){
        _backButton = [[UIButton alloc] init];
        [_backButton setImage:[UIImage imageNamed:@"BackBtn"] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"BackBtn"] forState:UIControlStateHighlighted];
        [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)playButton {
    if (_playButton == nil){
        _playButton = [[UIButton alloc] init];
        [_playButton setImage:[UIImage imageNamed:@"PlayBtn"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"PauseBtn"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (UIButton *)fullButton {
    if (_fullButton == nil){
        _fullButton = [[UIButton alloc] init];
        [_fullButton setImage:[UIImage imageNamed:@"MaxBtn"] forState:UIControlStateNormal];
        [_fullButton setImage:[UIImage imageNamed:@"MinBtn"] forState:UIControlStateSelected];
        [_fullButton addTarget:self action:@selector(fullButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullButton;
}

- (UILabel *)currentTimeLabel {
    if (_currentTimeLabel == nil){
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.adjustsFontSizeToFitWidth = YES;
        _currentTimeLabel.text = @"00:00";
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}

- (UILabel *)totalTimeLabel {
    if (_totalTimeLabel == nil) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.adjustsFontSizeToFitWidth = YES;
        _totalTimeLabel.text = @"00:00";
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}

- (UIProgressView *)progress {
    if (!_progress) {
        _progress = [[UIProgressView alloc] init];
        _progress.progress = 0.4;
    }
    return _progress;
}

- (LoadingView *)loadingView {
    if (_loadingView == nil) {
        _loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _loadingView.strokeColor = THEME_color;
    }
    return _loadingView;
}

- (XLSlider *)slider {
    if (!_slider) {
        _slider = [[XLSlider alloc] init];
        // 开始滑动
        [_slider addTarget:self action:@selector(sliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        // 滑动中
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // 结束滑动
        [_slider addTarget:self action:@selector(sliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
        _slider.maximumTrackTintColor = [UIColor clearColor];
    }
    return _slider;
}

- (UIButton *)failButton {
    if (_failButton == nil) {
        _failButton = [[UIButton alloc] init];
        _failButton.hidden = YES;
        [_failButton setTitle:@"加载失败,点击重试" forState:UIControlStateNormal];
        [_failButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _failButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _failButton.backgroundColor = [UIColor colorWithRed:0.00000f green:0.00000f blue:0.00000f alpha:0.50000f];
        [_failButton addTarget:self action:@selector(failButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _failButton;
}

@end
