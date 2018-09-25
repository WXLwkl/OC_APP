//
//  XLRecordProgressView.m
//  OC_APP
//
//  Created by xingl on 2018/9/21.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "XLRecordProgressView.h"
#define Line_Width 4
#define Spring_damping  50
#define Spring_velocity 29

@interface XLRecordProgressView()
@property (nonatomic ,strong) CALayer *centerlayer;
@end

@implementation XLRecordProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.layer.cornerRadius = self.bounds.size.height / 2;
    self.clipsToBounds = YES;
    
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.24];
    
    CALayer *centerLayer = [CALayer layer];
    centerLayer.backgroundColor = [UIColor whiteColor].CGColor;
    centerLayer.position = self.center;
    centerLayer.bounds = CGRectMake(0, 0, 116/2, 116/2);
    centerLayer.cornerRadius = 116/4;
    centerLayer.masksToBounds = YES;
    [self.layer addSublayer:centerLayer];
    _centerlayer = centerLayer;
}

- (void)resetScale {
    [UIView animateWithDuration:0.25 animations:^{
        _centerlayer.transform = CATransform3DIdentity;
        self.transform = CGAffineTransformIdentity;
    }];
}

- (void)setScale {
    [UIView animateWithDuration:0.25 animations:^{
        _centerlayer.transform = CATransform3DScale(_centerlayer.transform, 30/58.0, 30/58.0, 1);
        self.transform = CGAffineTransformScale(self.transform, 172/156.0, 172/156.0);
    }];
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef contexRef = UIGraphicsGetCurrentContext();
    CGPoint centerPoint = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2); // 圆心
    CGFloat radius = self.bounds.size.height / 2 - Line_Width / 2; // 设置半径
    CGFloat startA = -M_PI_2; // 设置初始点
    CGFloat endA = -M_PI_2 + M_PI*2*_progress; // 设置结束点
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:radius startAngle:startA endAngle:endA clockwise:YES];
    CGContextSetLineWidth(contexRef, Line_Width); // 设置线条宽度
    [[UIColor colorWithRed:255/255.0 green:214/255.0 blue:34/255.0 alpha:1] setStroke]; // 设置线条颜色
    CGContextAddPath(contexRef, path.CGPath); // 把贝赛尔曲线添加到上下文
    CGContextStrokePath(contexRef); //渲染
}

@end
