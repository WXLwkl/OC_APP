//
//  LoadingView.m
//  OC_APP
//
//  Created by xingl on 2018/8/7.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView ()<CAAnimationDelegate>

@property (nonatomic, strong) CAShapeLayer *loadingLayer;

@property (nonatomic, strong) CABasicAnimation *strokeStartAnimation;
@property (nonatomic, strong) CABasicAnimation *strokeEndAnimation;
@property (nonatomic, strong) CAAnimationGroup *strokeAnimationGroup;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) BOOL realFinish;

@end

@implementation LoadingView
- (void)dealloc {
#ifdef DEBUG
    NSLog(@"转子动画销毁了");
#endif
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _index = 0;
        _duration = 2;
        self.strokeAnimationGroup.animations = @[self.strokeEndAnimation, self.strokeStartAnimation];
        [self.layer addSublayer:self.loadingLayer];
        [self loadingAnimation];
    }
    return self;
}


- (void)loadingAnimation {
    [self.loadingLayer addAnimation:self.strokeAnimationGroup forKey:@"strokeAnimationGroup"];
}


#pragma mark - public
- (void)startAnimation {
    if (self.loadingLayer.animationKeys.count > 0) {
        return;
    }
    self.hidden = NO;
    if (_realFinish) {
        [self loadingAnimation];
    }
}

- (void)stopAnimation {
    self.hidden = YES;
    self.index = 0;
    [self.loadingLayer removeAllAnimations];
}

- (void)destroyAnimation{
    [self stopAnimation];
    [self.loadingLayer removeFromSuperlayer];
    self.loadingLayer         = nil;
    self.strokeAnimationGroup = nil;
}


#pragma mark - CAAnimationDelegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.isHidden) {
        _realFinish = YES;
        return;
    }
    _index += 1;
    self.loadingLayer.path = [self cycleBezierPathIndex:_index % 3].CGPath;
    [self loadingAnimation];
}

- (UIBezierPath*)cycleBezierPathIndex:(NSInteger)index {
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5) radius:self.bounds.size.width * 0.5 startAngle:index * (M_PI * 2)/3  endAngle:index * (M_PI* 2)/3 + 2 * M_PI * 4/3 clockwise:YES];
    return path;
}

#pragma mark - setter && getter

- (void)setStrokeColor:(UIColor *)strokeColor{
    _strokeColor = strokeColor;
    self.loadingLayer.strokeColor  = strokeColor.CGColor;
}

- (CAShapeLayer *)loadingLayer {
    if (!_loadingLayer) {
        _loadingLayer = [CAShapeLayer layer];
        _loadingLayer.lineWidth = 2;
        _loadingLayer.fillColor = [UIColor clearColor].CGColor;
        _loadingLayer.strokeColor = [UIColor whiteColor].CGColor;
        _loadingLayer.lineCap = kCALineCapRound;
    }
    return _loadingLayer;
}

- (CABasicAnimation *)strokeStartAnimation {
    if (!_strokeStartAnimation) {
        _strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        _strokeStartAnimation.fromValue = @0;
        _strokeStartAnimation.toValue = @1.;
        _strokeStartAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    }
    return _strokeStartAnimation;
}
- (CABasicAnimation *)strokeEndAnimation {
    if (!_strokeEndAnimation) {
        _strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        _strokeEndAnimation.fromValue = @0;
        _strokeEndAnimation.toValue = @1;
        _strokeEndAnimation.duration = self.duration * 0.5;
    }
    return _strokeEndAnimation;
}

- (CAAnimationGroup *)strokeAnimationGroup {
    if (!_strokeAnimationGroup) {
        _strokeAnimationGroup = [CAAnimationGroup animation];
        _strokeAnimationGroup.duration = self.duration;
        _strokeAnimationGroup.delegate = self;
        _strokeAnimationGroup.removedOnCompletion = NO;
        _strokeAnimationGroup.fillMode = kCAFillModeForwards;
    }
    return _strokeAnimationGroup;
}

@end
