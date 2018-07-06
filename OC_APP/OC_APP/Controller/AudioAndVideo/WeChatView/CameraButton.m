//
//  CameraButton.m
//  OC_APP
//
//  Created by xingl on 2018/6/27.
//  Copyright © 2018年 兴林. All rights reserved.
//

// 默认按钮大小
#define CAMERABUTTONWIDTH 75 // cameraButtonWidth
#define TOUCHVIEWWIDTH 55    // touchViewWidth

// 录制按钮动画轨道宽度
#define PROGRESSLINEWIDTH 3 //progressLineWidth

// 录制时按钮的缩放比
#define SHOOTCAMERABUTTONSCALE 1.6f
#define SHOOTTOUCHVIEWSCALE 0.5f

#import "CameraButton.h"

@interface CameraButton ()

@property (weak, nonatomic) UIView *touchView;
@property (strong, nonatomic) CAShapeLayer *trackLayer;
@property (strong, nonatomic) CAShapeLayer *progressLayer;

@property (copy, nonatomic) TapEventBlock tapEventBlock;
@property (copy, nonatomic) LongPressEventBlock longPressEventBlock;

@end

@implementation CameraButton

- (void)dealloc {
    NSLog(@"CameraButton dealloc");
}

+ (instancetype)defaultCameraButton {
    CameraButton *view = [[CameraButton alloc] initWithFrame:CGRectMake(0, 0, CAMERABUTTONWIDTH, CAMERABUTTONWIDTH)];
    [view.layer setCornerRadius:CAMERABUTTONWIDTH/2];
    view.backgroundColor = RGBColor(225, 225, 230);
    
    CGFloat touchViewX = (CAMERABUTTONWIDTH - TOUCHVIEWWIDTH) / 2;
    CGFloat touchViewY = touchViewX;
    UIView *touchView = [[UIView alloc] initWithFrame:CGRectMake(touchViewX, touchViewY, TOUCHVIEWWIDTH, TOUCHVIEWWIDTH)];
    view.touchView = touchView;
    [view addSubview:touchView];
    [view.touchView.layer setCornerRadius:(view.touchView.bounds.size.width / 2)];
    touchView.backgroundColor = [UIColor whiteColor];
    
    [view initCircleAnimationLayer];
    
    return view;
    
}

- (void)initCircleAnimationLayer {
    CGFloat centerX = self.bounds.size.width / 2.0;
    CGFloat centerY = self.bounds.size.height / 2.0;
    
    //半径
    CGFloat radius = (self.bounds.size.width - PROGRESSLINEWIDTH) / 2.0;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:-M_PI * 0.5f endAngle:M_PI * 1.5f clockwise:YES];
    
    CAShapeLayer *backLayer = [CAShapeLayer layer];
    backLayer.frame = self.bounds;
    backLayer.fillColor = [[UIColor clearColor] CGColor];
    backLayer.strokeColor = [RGBColor(225, 225, 230) CGColor];
    backLayer.lineWidth = PROGRESSLINEWIDTH;
    backLayer.path = [path CGPath];
    backLayer.strokeEnd = 1;
    [self.layer addSublayer:backLayer];
    
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor = [[UIColor clearColor] CGColor];
    _progressLayer.strokeColor = [[UIColor blackColor] CGColor];
    _progressLayer.lineCap = kCALineCapSquare;
    _progressLayer.lineWidth = PROGRESSLINEWIDTH;
    _progressLayer.path = [path CGPath];
    _progressLayer.strokeEnd = 0;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    [gradientLayer setColors:@[(id)[RGBColor(76, 192, 29) CGColor],(id)[RGBColor(76, 192, 29) CGColor]]];
//    [gradientLayer setColors:@[(id)[RGBColor(76, 192, 29) CGColor],(id)[[UIColor redColor] CGColor], (id)[THEME_color CGColor]]];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    [gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
    [self.layer addSublayer:gradientLayer];
}

#pragma mark - public Method
- (void)configureTapCameraButtonEventWithBlock:(TapEventBlock)tapEventBlock {
    self.tapEventBlock = tapEventBlock;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCameraButtonEvent:)];
    [self.touchView addGestureRecognizer:tapGesture];
}

- (void)tapCameraButtonEvent:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (self.tapEventBlock) {
        self.tapEventBlock(tapGestureRecognizer);
    }
}

- (void)configureLongPressCameraButtonEventWithBlock:(LongPressEventBlock)longPressEventBlock {
    
    self.longPressEventBlock = longPressEventBlock;
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCameraButtonEvent:)];
    [self.touchView addGestureRecognizer:longPressGestureRecognizer];
}

- (void)longPressCameraButtonEvent:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    if (self.longPressEventBlock) {
        self.longPressEventBlock(longPressGestureRecognizer);
    }
}

- (void)startShootAnimationWithDuration:(NSTimeInterval)duration {
    
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformMakeScale(SHOOTCAMERABUTTONSCALE, SHOOTCAMERABUTTONSCALE);
        self.touchView.transform = CGAffineTransformMakeScale(SHOOTTOUCHVIEWSCALE, SHOOTTOUCHVIEWSCALE);
    }];
}

- (void)stopShootAnimationWithDuration:(NSTimeInterval)duration {
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformIdentity;
        self.touchView.transform = CGAffineTransformIdentity;
    }];
}

- (void)setProgressPercentage:(CGFloat)progressPercentage {
    _progressPercentage = progressPercentage;
    _progressLayer.strokeEnd = progressPercentage;
    [_progressLayer removeAllAnimations];
}

@end
