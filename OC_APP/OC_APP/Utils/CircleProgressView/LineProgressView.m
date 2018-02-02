//
//  LineProgressView.m
//  OC_APP
//
//  Created by xingl on 2018/1/29.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "LineProgressView.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat kBorderWidth = 2.0f;

@interface LProgressLayer : CALayer

@property (nonatomic, strong) UIColor *progressTintColor;
@property (nonatomic, strong) UIColor *borderTintColor;
@property (nonatomic, strong) UIColor *trackTintColor;
@property (nonatomic) CGFloat progress;

@end

@implementation LProgressLayer

@dynamic progressTintColor;
@dynamic borderTintColor;
@dynamic trackTintColor;

+ (BOOL)needsDisplayForKey:(NSString *)key {
    return [key isEqualToString:@"progress"] ? YES : [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)ctx {
    
    //轮廓
    CGRect rect = CGRectInset(self.bounds, kBorderWidth, kBorderWidth);
    CGFloat radius = CGRectGetHeight(rect) / 2.0f;
    CGContextSetLineWidth(ctx, kBorderWidth);
    CGContextSetStrokeColorWithColor(ctx, self.borderTintColor.CGColor);
    [self drawRectangleInContext:ctx inRect:rect withRadius:radius];
    CGContextStrokePath(ctx);
    
    //进度背景
    CGContextSetFillColorWithColor(ctx, self.trackTintColor.CGColor);
    CGRect bgRect = CGRectInset(rect, kBorderWidth, kBorderWidth);
    CGFloat bgRadius = CGRectGetHeight(bgRect) / 2.0f;
    bgRect.size.width = fmaxf(bgRect.size.width, 2.0f * bgRadius);
    [self drawRectangleInContext:ctx inRect:bgRect withRadius:bgRadius];
    CGContextFillPath(ctx);
    
    //进度
    CGContextSetFillColorWithColor(ctx, self.progressTintColor.CGColor);
    CGRect progressRect = CGRectInset(rect, 2 * kBorderWidth, 2 * kBorderWidth);
    CGFloat progressRadius = CGRectGetHeight(progressRect) / 2.0f;
    progressRect.size.width = fmaxf(self.progress * progressRect.size.width, 2.0f * progressRadius);
    [self drawRectangleInContext:ctx inRect:progressRect withRadius:progressRadius];
    CGContextFillPath(ctx);
}

- (void)drawRectangleInContext:(CGContextRef)context inRect:(CGRect)rect withRadius:(CGFloat)radius {
    
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + radius);
    CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height - radius);
    CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, radius, M_PI, M_PI / 2, 1);
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height);
    CGContextAddArc(context, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height - radius, radius, M_PI / 2, 0.0f, 1);
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + radius);
    CGContextAddArc(context, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, radius, 0.0f, -M_PI / 2, 1);
    CGContextAddLineToPoint(context, rect.origin.x + radius, rect.origin.y);
    CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + radius, radius, -M_PI / 2, M_PI, 1);
}
@end

//MARK: - LineProgressView

@implementation LineProgressView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
}

- (void)didMoveToWindow {
    
    self.progressLayer.contentsScale = self.window.screen.scale;
}

+ (Class)layerClass {

    return [LProgressLayer class];
}

- (LProgressLayer *)progressLayer {
    return (LProgressLayer *)self.layer;
}


#pragma mark Getters & Setters

- (CGFloat)progress {
    return self.progressLayer.progress;
}

- (void)setProgress:(CGFloat)progress {
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    [self.progressLayer removeAnimationForKey:@"progress"];
    CGFloat pinnedProgress = MIN(MAX(progress, 0.0f), 1.0f);
    
    if (animated) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
        animation.duration = fabs(self.progress - pinnedProgress) + 0.1f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.fromValue = [NSNumber numberWithFloat:self.progress];
        animation.toValue = [NSNumber numberWithFloat:pinnedProgress];
        [self.progressLayer addAnimation:animation forKey:@"progress"];
    }
    else {
        [self.progressLayer setNeedsDisplay];
    }
    
    self.progressLayer.progress = pinnedProgress;
}

- (UIColor *)progressTintColor {
    return self.progressLayer.progressTintColor;
}

- (void)setProgressTintColor:(UIColor *)progressTintColor {
    self.progressLayer.progressTintColor = progressTintColor;
    [self.progressLayer setNeedsDisplay];
}

- (UIColor *)borderTintColor {
    return self.progressLayer.borderTintColor;
}

- (void)setBorderTintColor:(UIColor *)borderTintColor {
    self.progressLayer.borderTintColor = borderTintColor;
    [self.progressLayer setNeedsDisplay];
}

- (UIColor *)trackTintColor {
    return self.progressLayer.trackTintColor;
}

- (void)setTrackTintColor:(UIColor *)trackTintColor {
    self.progressLayer.trackTintColor = trackTintColor;
    [self.progressLayer setNeedsDisplay];
}

@end
