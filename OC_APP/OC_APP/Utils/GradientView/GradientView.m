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


@interface GradientView (){
    CGFloat _waveAmplitude; //振幅
    CGFloat _waveCycle;     //周期
    CGFloat _waveSpeed;     //速度

    CGFloat _waterWaveWidth;
    CGFloat _wavePointY;
    CGFloat _waveMargin;    //高度
    CGFloat _waveOffsetX;   //波浪x位移
    UIColor *_waveColor;    //波浪颜色
}

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) CAGradientLayer *gradLayer;

@property (nonatomic, strong) CAShapeLayer *firstWaveLayer;
@property (nonatomic, strong) CAShapeLayer *secondWaveLayer;
@property (nonatomic, strong) CAShapeLayer *thirdWaveLayer;

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
    }
    return self;
}
//配置参数
- (void)configParams {
    
    _waterWaveWidth = self.frame.size.width;
    _waveColor = RGBAColor(255, 255, 255, 0.15);
    _waveSpeed = 0.05/M_PI;
    
    _waveOffsetX = 0;
    _wavePointY = 0;
    _waveMargin = 50; //距顶部的距离
    _waveAmplitude = 15;
    _waveCycle = 1.3*M_PI / _waterWaveWidth;
}
- (void)initBottomLayer {
    if (self.gradLayer == nil) {
        self.gradLayer = [CAGradientLayer layer];
        self.gradLayer.frame = self.bounds;
    }
    self.gradLayer.startPoint = CGPointMake(0, 1);
    self.gradLayer.endPoint = CGPointMake(0, 0);
    self.gradLayer.colors = @[(id)[RGBAColor(originRed, originGreen, originBlue, 1.0) CGColor],
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
        y = _waveAmplitude * sin(-_waveCycle * x + _waveOffsetX - 10) + _wavePointY + _waveMargin;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    CGPathAddLineToPoint(path, nil, _waterWaveWidth, _wavePointY);
    CGPathAddLineToPoint(path, nil, 0, _wavePointY);
    CGPathCloseSubpath(path);
    
    self.firstWaveLayer.path = path;
    
    CGPathRelease(path);
}
- (void)setSecondWaveLayerPath {
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = _wavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    
    for (float x = 0.0f; x<=_waterWaveWidth; x ++) {
        
        y = _waveAmplitude *sin(-(1.0*M_PI / _waterWaveWidth)*x + _waveOffsetX - 5 ) +_wavePointY + 10 + _waveMargin;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, _waterWaveWidth, _wavePointY);
    CGPathAddLineToPoint(path, nil, 0, _wavePointY);
    CGPathCloseSubpath(path);
    
    self.secondWaveLayer.path = path;
    CGPathRelease(path);
}
- (void)setThirdWaveLayerPath {
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = _wavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    
    for (float x = 0.0f; x<=_waterWaveWidth; x ++) {
        
        y = 18*sin(-(0.6*M_PI / _waterWaveWidth)*x + _waveOffsetX ) +_wavePointY + 18 + _waveMargin;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, _waterWaveWidth, _wavePointY);
    CGPathAddLineToPoint(path, nil, 0, _wavePointY);
    CGPathCloseSubpath(path);
    
    self.thirdWaveLayer.path = path;
    CGPathRelease(path);
}

- (void)dealloc {
    
    [self.displayLink invalidate];
    self.displayLink = nil;
}

@end
