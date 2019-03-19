//
//  CircleSpreadAnimation.m
//  OC_APP
//
//  Created by xingl on 2019/3/11.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "CircleSpreadAnimation.h"

@interface CircleSpreadAnimation ()<CAAnimationDelegate>

/** 动画的中心坐标 */
@property (nonatomic, assign) CGPoint centerPoint;
// 半径
@property (nonatomic, assign) CGFloat radius;
// 保存layer
@property (nonatomic, strong) CAShapeLayer *maskShapeLayer;
// 保存转场动画开始路径
@property (nonatomic, strong) UIBezierPath *startPath;

@end

@implementation CircleSpreadAnimation

- (instancetype)initWithStartPoint:(CGPoint)point radius:(CGFloat)radius {
    self = [super init];
    if (self) {
        _centerPoint = point;
        _radius = radius;
    }
    return self;
}

- (void)setToAnimation:(id<UIViewControllerContextTransitioning>)contextTransition {
    UIViewController *toVC = [contextTransition viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [contextTransition containerView];
    [containerView addSubview:toVC.view];
    
    UIBezierPath *startPath = [UIBezierPath bezierPathWithArcCenter:self.centerPoint radius:self.radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    CGFloat x = self.centerPoint.x;
    CGFloat y = self.centerPoint.y;
    
    CGFloat radius_x = MAX(x, containerView.frame.size.width - x);
    CGFloat radius_y = MAX(y, containerView.frame.size.height - y);
    
    CGFloat endRadius = sqrtf(pow(radius_x, 2) + pow(radius_y, 2));
    
    UIBezierPath *endPath = [UIBezierPath bezierPathWithArcCenter:self.centerPoint radius:endRadius startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    //创建CAShapeLayer 用以后面的动画
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = endPath.CGPath;
    toVC.view.layer.mask = shapeLayer;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue = (__bridge id _Nullable)(startPath.CGPath);
    animation.duration = self.duration;
    animation.delegate = self;
    
    [animation setValue:contextTransition forKey:@"pathContextTransition"];
    [shapeLayer addAnimation:animation forKey:nil];
    
    self.maskShapeLayer = shapeLayer;
}

- (void)setBackAnimation:(id<UIViewControllerContextTransitioning>)contextTransition {
    UIViewController *toVC = [contextTransition viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [contextTransition viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [contextTransition containerView];
    [containerView insertSubview:toVC.view atIndex:0];
    
    UIBezierPath *endPath = [UIBezierPath bezierPathWithArcCenter:self.centerPoint radius:self.radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    CAShapeLayer *shapeLayer = (CAShapeLayer *)fromVC.view.layer.mask;
    self.maskShapeLayer = shapeLayer;
    
    UIBezierPath *startPath = [UIBezierPath bezierPathWithCGPath:shapeLayer.path];
    self.startPath = startPath;
    shapeLayer.path = endPath.CGPath;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue = (__bridge id _Nullable)(startPath.CGPath);
    animation.toValue = (__bridge id _Nullable)(endPath.CGPath);
    animation.duration = self.duration;
    animation.delegate = (id)self;
    //    animation.removedOnCompletion = NO;//执行后移除动画
    //保存contextTransition  后面动画结束的时候调用
    [animation setValue:contextTransition forKey:@"pathContextTransition"];
    [shapeLayer addAnimation:animation forKey:nil];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    id<UIViewControllerContextTransitioning> contextTransition = [anim valueForKey:@"pathContextTransition"];
    if (contextTransition.transitionWasCancelled) {
        self.maskShapeLayer.path = self.startPath.CGPath;
    }
    /** 声明过渡结束 */
    [contextTransition completeTransition:!contextTransition.transitionWasCancelled];
}

@end
