//
//  GradientView.m
//  OC_APP
//
//  Created by xingl on 2017/6/21.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "GradientView.h"
// 起点 RGB
#define originRed 37
#define originGreen 191
#define originBlue 191
// 终点 RGB
#define endRed 10
#define endGreen 145
#define endBlue 171

#define lifeCycle 25


@interface GradientView (){
    CGFloat _waveAmplitude; //振幅
    CGFloat _waveCycle;     //周期
    CGFloat _waveSpeed;     //速度
    CGFloat _waterWaveHeight;
    CGFloat _waterWaveWidth;
    CGFloat _wavePointY;
    CGFloat _waveOffsetX;   //波浪x位移
    UIColor *_waveColor;    //波浪颜色
}

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) CAShapeLayer *firstWaveLayer;
@property (nonatomic, strong) CAShapeLayer *secondWaveLayer;
@property (nonatomic, strong) CAShapeLayer *thirdWaveLayer;
@property (nonatomic, strong) CAGradientLayer *gradLayer;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger number;

@end

@implementation GradientView

#pragma mark - lazy
- (CAShapeLayer *)firstWaveLayer {
    if (!_firstWaveLayer) {
        _firstWaveLayer = [CAShapeLayer layer];
        _firstWaveLayer.fillColor = [_waveColor CGColor];
    }
    return _firstWaveLayer;
}
- (CAShapeLayer *)secondWaveLayer {
    if (!_secondWaveLayer) {
        _secondWaveLayer = [CAShapeLayer layer];
        _secondWaveLayer.fillColor = [_waveColor CGColor];
    }
    return _secondWaveLayer;
}
- (CAShapeLayer *)thirdWaveLayer {
    if (!_thirdWaveLayer) {
        _thirdWaveLayer = [CAShapeLayer layer];
        _thirdWaveLayer.fillColor = [_waveColor CGColor];
    }
    return _thirdWaveLayer;
}

- (CADisplayLink *)displayLink {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave)];
    }
    return _displayLink;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configParams];
        [self initBottomLayer];
        [self startWave];
        [self setupTimer];
    }
    return self;
}
//配置参数
- (void)configParams {
    _waterWaveWidth = self.frame.size.width;
    _waterWaveHeight = self.frame.size.height;
    _waveColor = RGBAColor(255, 255, 255, 0.15);
    _waveSpeed = 0.05/M_PI;
    
    _waveOffsetX = 0;
    _wavePointY = 0;
    _waveAmplitude = 15;
    _waveCycle = 1.3*M_PI / _waterWaveWidth;
}
- (void)initBottomLayer {
    if (self.gradLayer == nil) {
        self.gradLayer = [CAGradientLayer layer];
        self.gradLayer.frame = self.bounds;
    }
    self.gradLayer.startPoint = CGPointMake(0, 1);
    self.gradLayer.endPoint = CGPointMake(1, 0);
    self.gradLayer.colors = @[
                              (id)[RGBAColor(originRed, originGreen, originBlue, 1.0) CGColor],
                              (id)[RGBAColor(0.5*(originRed+endRed), 0.5*(originGreen+endGreen), 0.5*(originBlue+endBlue), 1.0) CGColor],
                              (id)[RGBAColor(endRed, endGreen, endBlue, 1.0) CGColor]];
    [self.layer addSublayer:self.gradLayer];
}
- (void)startWave {
    [self.layer addSublayer:self.firstWaveLayer];
    [self.layer addSublayer:self.secondWaveLayer];
    [self.layer addSublayer:self.thirdWaveLayer];
    
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}
- (void)setupTimer {
    CGFloat interval = 0.5;
    if (self.timer == nil) {
        self.timer = [NSTimer timerWithTimeInterval:interval target:self selector:@selector(timerFunc) userInfo:nil repeats:YES];
    }
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

#pragma mark 帧刷新事件
- (void)getCurrentWave {
    _waveOffsetX += _waveSpeed;
    
    [self setFirstWaveLayerPath];
    [self setSecondWaveLayerPath];
    [self setThirdWaveLayerPath];
}

- (void)setFirstWaveLayerPath {
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = _wavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <= _waterWaveWidth; x++) {
        y = _waveAmplitude * sin(-_waveCycle * x + _waveOffsetX - 10) + _wavePointY + 10;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    CGPathAddLineToPoint(path, nil, _waterWaveWidth, _wavePointY);
    CGPathAddLineToPoint(path, nil, 0, _wavePointY);
    CGPathCloseSubpath(path);
    
    self.firstWaveLayer.path = path;
    
    CGPathRelease(path);
}
- (void)setSecondWaveLayerPath
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = _wavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    
    for (float x = 0.0f; x<=_waterWaveWidth; x ++) {
        
        y = _waveAmplitude *sin(-(1.0*M_PI / _waterWaveWidth)*x + _waveOffsetX - 5 ) +_wavePointY + 10 ;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, _waterWaveWidth, _wavePointY);
    CGPathAddLineToPoint(path, nil, 0, _wavePointY);
    CGPathCloseSubpath(path);
    
    self.secondWaveLayer.path = path;
    
    CGPathRelease(path);
}
- (void)setThirdWaveLayerPath
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = _wavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    
    for (float x = 0.0f; x<=_waterWaveWidth; x ++) {
        
        y = 18*sin(-(0.6*M_PI / _waterWaveWidth)*x + _waveOffsetX ) +_wavePointY + 18;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, _waterWaveWidth, _wavePointY);
    CGPathAddLineToPoint(path, nil, 0, _wavePointY);
    CGPathCloseSubpath(path);
    
    self.thirdWaveLayer.path = path;
    
    CGPathRelease(path);
}

- (void)timerFunc {
    NSInteger R_A = 0.5 * (originRed - endRed);
    NSInteger R_B = 0.5 * (originRed + endRed);
    

    NSInteger G_A = 0.5 * (originGreen - endGreen);
    NSInteger G_B = 0.5 * (originGreen + endGreen);
    
    NSInteger B_A = 0.5 * (originBlue - endBlue);
    NSInteger B_B = 0.5 * (originBlue + endBlue);
    
    if (self.number > lifeCycle) {
        self.number = 0;
    }
    
//    计算起点 RGB
    CGFloat originR = R_A * sin(2*M_PI/lifeCycle * self.number + M_PI_2) + R_B;
    CGFloat originG = G_A * sin(2*M_PI/lifeCycle * self.number + M_PI_2) + G_B;
    CGFloat originB = B_A * sin(2*M_PI/lifeCycle * self.number + M_PI_2) + B_B;
    
    // 计算中点 RGB
    CGFloat centerR = R_A*sin(2*M_PI/lifeCycle * self.number + M_PI) + R_B;
    CGFloat centerG = G_A*sin(2*M_PI/lifeCycle * self.number + M_PI) + G_B;
    CGFloat centerB = B_A*sin(2*M_PI/lifeCycle * self.number + M_PI) + B_B;
    
    // 计算结束点 RGB
    CGFloat endR = R_A*sin(2*M_PI/lifeCycle * self.number + 3*M_PI_2) + R_B;
    CGFloat endG = G_A*sin(2*M_PI/lifeCycle * self.number + 3*M_PI_2) + G_B;
    CGFloat endB = B_A*sin(2*M_PI/lifeCycle * self.number + 3*M_PI_2) + B_B;
    
    self.number += 1;
    
    self.gradLayer.colors = @[(id)[RGBAColor(originR, originG, originB, 1.0) CGColor],
                              (id)[RGBAColor(centerR, centerG, centerB, 1.0) CGColor],
                              (id)[RGBAColor(endR, endG, endB, 1.0) CGColor]];
    
    
}
- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
    [self.displayLink invalidate];
    self.displayLink = nil;
}

@end
