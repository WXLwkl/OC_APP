//
//  UIView+Common.m
//  OC_APP
//
//  Created by xingl on 2017/6/19.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "UIView+Common.h"
#import <objc/runtime.h>


NSString const *UIView_badgeKey = @"UIView_badgeKey";
NSString const *UIView_badgeValueKey = @"UIView_badgeValueKey";
NSString const *UIView_badgeBGColorKey = @"UIView_badgeBGColorKey";
NSString const *UIView_badgeTextColorKey = @"UIView_badgeTextColorKey";
NSString const *UIView_badgeFontKey = @"UIView_badgeFontKey";
NSString const *UIView_badgePaddingKey = @"UIView_badgePaddingKey";
NSString const *UIView_badgeMinSizeKey = @"UIView_badgeMinSizeKey";
NSString const *UIView_badgeOriginXKey = @"UIView_badgeOriginXKey";
NSString const *UIView_badgeOriginYKey = @"UIView_badgeOriginYKey";

NSString const *UIView_shouldAnimateBadgeKey = @"UIView_shouldAnimateBadgeKey";
NSString const *UIView_shouldHideBadgeAtZeroKey = @"UIView_shouldHideBadgeAtZeroKey";

static char kActionHandlerTapBlockKey;
static char kActionHandlerTapGestureKey;
static char kActionHandlerLongPressBlockKey;
static char kActionHandlerLongPressGestureKey;

@implementation UIView (Common)

//@dynamic xl_badge,xl_badgeValue,xl_badgeBGColor,xl_badgeTextColor,xl_badgeFont,xl_badgePadding,xl_badgeMinSize,xl_badgeOriginX,xl_badgeOriginY,xl_shouldAnimateBadge,xl_shouldHideBadgeAtZero;


- (void)xl_badgeInit {
    
    self.xl_badgeBGColor = [UIColor redColor];
    self.xl_badgeTextColor = [UIColor whiteColor];
    self.xl_badgeFont = [UIFont systemFontOfSize:9.0];
    self.xl_badgePadding = 5;
    self.xl_badgeMinSize = 4;
    self.xl_badgeOriginX = self.frame.size.width - self.xl_badge.frame.size.width / 2 - 3;
    self.xl_badgeOriginY = -6;
    self.xl_shouldHideBadgeAtZero = YES;
    self.xl_shouldAnimateBadge = YES;
    self.clipsToBounds = NO;
}

- (void)refreshBadge {
    
    self.xl_badge.textColor = self.xl_badgeTextColor;
    self.xl_badge.backgroundColor = self.xl_badgeBGColor;
    self.xl_badge.font = self.xl_badgeFont;

}

- (CGSize)badgeExpectedSize {
    UILabel *frameLabel = [self duplicateLabel:self.xl_badge];
    [frameLabel sizeToFit];
    CGSize expectedLabelSize = frameLabel.frame.size;
    return expectedLabelSize;
}
- (void)updateBadgeFrame {
    CGSize expectedLabelSize = [self badgeExpectedSize];
    
    CGFloat minHeight = expectedLabelSize.height;
    minHeight = (minHeight < self.xl_badgeMinSize) ? self.xl_badgeMinSize : minHeight;
    
    CGFloat minWidth = expectedLabelSize.width;
    CGFloat padding = self.xl_badgePadding;
    minWidth = (minWidth < minHeight) ? minHeight : minWidth;
    self.xl_badge.frame = CGRectMake(self.xl_badgeOriginX, self.xl_badgeOriginY, minWidth + padding, minHeight + padding);
    self.xl_badge.layer.cornerRadius = (minHeight + padding) / 2;
    self.xl_badge.layer.masksToBounds = YES;
}

- (void)updateBadgeValueAnimated:(BOOL)animated {
    if (animated && self.xl_shouldAnimateBadge &&![self.xl_badge.text isEqualToString:self.xl_badgeValue]) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [animation setFromValue:@(1.5)];
        [animation setToValue:@(1)];
        [animation setDuration:0.2];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.4f :1.3f :1.f :1.f]];
        [self.xl_badge.layer addAnimation:animation forKey:@"bounceAnimation"];
    }
    self.xl_badge.text = self.xl_badgeValue;
    NSTimeInterval duration = animated ? 0.2 : 0;
    [UIView animateWithDuration:duration animations:^{
        [self updateBadgeFrame];
    }];
}

- (UILabel *)duplicateLabel:(UILabel *)labelToCopy
{
    UILabel *duplicateLabel = [[UILabel alloc] initWithFrame:labelToCopy.frame];
    duplicateLabel.text = labelToCopy.text;
    duplicateLabel.font = labelToCopy.font;
    
    return duplicateLabel;
}

- (void)removeBadge {
    [UIView animateWithDuration:0.2 animations:^{
        self.xl_badge.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        [self.xl_badge removeFromSuperview];
        self.xl_badge = nil;
    }];
}

#pragma mark - getters/setters

- (UILabel *)xl_badge {
    return objc_getAssociatedObject(self, &UIView_badgeKey);
}
- (void)setXl_badge:(UILabel *)badgeLabel {
    objc_setAssociatedObject(self, &UIView_badgeKey, badgeLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)xl_badgeValue {
    return objc_getAssociatedObject(self, &UIView_badgeValueKey);
}

- (void)setXl_badgeValue:(NSString *)badgeValue {
    objc_setAssociatedObject(self, &UIView_badgeValueKey, badgeValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (!badgeValue || [badgeValue isEqualToString:@""] || ([badgeValue isEqualToString:@"0"] && self.xl_shouldHideBadgeAtZero)) {
        [self removeBadge];
    } else if (!self.xl_badge) {
        self.xl_badge = [[UILabel alloc] initWithFrame:CGRectMake(self.xl_badgeOriginX, self.xl_badgeOriginY, 20, 20)];
        self.xl_badge.textColor = self.xl_badgeTextColor;
        self.xl_badge.backgroundColor = self.xl_badgeBGColor;
        self.xl_badge.font = self.xl_badgeFont;
        self.xl_badge.textAlignment = NSTextAlignmentCenter;
        [self xl_badgeInit];
        [self addSubview:self.xl_badge];
        [self updateBadgeValueAnimated:NO];
    } else {
        [self updateBadgeValueAnimated:YES];
    }
}

- (UIColor *)xl_badgeBGColor {
    return objc_getAssociatedObject(self, &UIView_badgeBGColorKey);
}
- (void)setXl_badgeBGColor:(UIColor *)badgeBGColor {
    objc_setAssociatedObject(self, &UIView_badgeBGColorKey, badgeBGColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.xl_badge) {
        [self refreshBadge];
    }
}

- (UIColor *)xl_badgeTextColor {
    return objc_getAssociatedObject(self, &UIView_badgeTextColorKey);
}
- (void)setXl_badgeTextColor:(UIColor *)badgeTextColor
{
    objc_setAssociatedObject(self, &UIView_badgeTextColorKey, badgeTextColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.xl_badge) {
        [self refreshBadge];
    }
}

- (UIFont *)xl_badgeFont {
    return objc_getAssociatedObject(self, &UIView_badgeFontKey);
}
- (void)setXl_badgeFont:(UIFont *)badgeFont
{
    objc_setAssociatedObject(self, &UIView_badgeFontKey, badgeFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.xl_badge) {
        [self refreshBadge];
    }
}

- (CGFloat)xl_badgePadding {
    NSNumber *number = objc_getAssociatedObject(self, &UIView_badgePaddingKey);
    return number.floatValue;
}
- (void)setXl_badgePadding:(CGFloat)badgePadding {
    NSNumber *number = [NSNumber numberWithDouble:badgePadding];
    objc_setAssociatedObject(self, &UIView_badgePaddingKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.xl_badge) {
        [self updateBadgeFrame];
    }
}

- (CGFloat)xl_badgeMinSize {
    NSNumber *number = objc_getAssociatedObject(self, &UIView_badgeMinSizeKey);
    return number.floatValue;
}
- (void)setXl_badgeMinSize:(CGFloat)badgeMinSize {
    NSNumber *number = [NSNumber numberWithDouble:badgeMinSize];
    objc_setAssociatedObject(self, &UIView_badgeMinSizeKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.xl_badge) {
        [self updateBadgeFrame];
    }
}

- (CGFloat)xl_badgeOriginX {
    NSNumber *number = objc_getAssociatedObject(self, &UIView_badgeOriginXKey);
    return number.floatValue;
}
- (void)setXl_badgeOriginX:(CGFloat)badgeOriginX {
    NSNumber *number = [NSNumber numberWithDouble:badgeOriginX];
    objc_setAssociatedObject(self, &UIView_badgeOriginXKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.xl_badge) {
        [self updateBadgeFrame];
    }
}

- (CGFloat)xl_badgeOriginY {
    NSNumber *number = objc_getAssociatedObject(self, &UIView_badgeOriginYKey);
    return number.floatValue;
}
- (void)setXl_badgeOriginY:(CGFloat)badgeOriginY {
    NSNumber *number = [NSNumber numberWithDouble:badgeOriginY];
    objc_setAssociatedObject(self, &UIView_badgeOriginYKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.xl_badge) {
        [self updateBadgeFrame];
    }
}

- (BOOL)xl_shouldHideBadgeAtZero {
    NSNumber *number = objc_getAssociatedObject(self, &UIView_shouldHideBadgeAtZeroKey);
    return number.boolValue;
}
- (void)setXl_shouldHideBadgeAtZero:(BOOL)shouldHideBadgeAtZero {
    NSNumber *number = [NSNumber numberWithBool:shouldHideBadgeAtZero];
    objc_setAssociatedObject(self, &UIView_shouldHideBadgeAtZeroKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)xl_shouldAnimateBadge {
    NSNumber *number = objc_getAssociatedObject(self, &UIView_shouldAnimateBadgeKey);
    return number.boolValue;
}
- (void)setXl_shouldAnimateBadge:(BOOL)shouldAnimateBadge {
    NSNumber *number = [NSNumber numberWithBool:shouldAnimateBadge];
    objc_setAssociatedObject(self, &UIView_shouldAnimateBadgeKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark -

- (void)xl_setGradientLayer:(UIColor *)startColor endColor:(UIColor *)endColor {
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.layer addSublayer:gradientLayer];
    
    //设置渐变区域的起始和终止位置（范围为0-1）
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    
    //设置颜色数组
    //    gradientLayer.colors = @[(__bridge id)[UIColor blueColor].CGColor,
    //                                  (__bridge id)[UIColor redColor].CGColor];
    gradientLayer.colors = @[(__bridge id)startColor.CGColor,
                             (__bridge id)endColor.CGColor];
    
    //设置颜色分割点（范围：0-1）
    gradientLayer.locations = @[@(0.5f), @(1.0f)];
}


- (void)xl_removeAllSubviews {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}



- (void)xl_addTapActionWithBlock:(TapActionBlock)block
{
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kActionHandlerTapGestureKey);
    if (!gesture)
    {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &kActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)handleActionForTapGesture:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        TapActionBlock block = objc_getAssociatedObject(self, &kActionHandlerTapBlockKey);
        if (block)
        {
            block(gesture);
        }
    }
}

- (void)xl_addLongPressActionWithBlock:(LongPressActionBlock)block
{
    UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, &kActionHandlerLongPressGestureKey);
    if (!gesture)
    {
        gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForLongPressGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kActionHandlerLongPressGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &kActionHandlerLongPressBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)handleActionForLongPressGesture:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        LongPressActionBlock block = objc_getAssociatedObject(self, &kActionHandlerLongPressBlockKey);
        if (block)
        {
            block(gesture);
        }
    }
}


//抖动动画
- (void)xl_shake {
    CALayer *viewLayer = self.layer;
    CGPoint position = viewLayer.position;
    CGPoint left = CGPointMake(position.x - 10, position.y);
    CGPoint right = CGPointMake(position.x + 10, position.y);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:left]];
    [animation setToValue:[NSValue valueWithCGPoint:right]];
    [animation setAutoreverses:YES]; // 平滑结束
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    [viewLayer addAnimation:animation forKey:nil];
}

//设置圆角
- (void)xl_setCornerRadius:(CGFloat)radius {
    [self xl_setCornerWithRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
}
- (void)xl_setCornerWithRoundingCorners:(UIRectCorner)corners
                                 radius:(CGFloat)radius {
    [self xl_setCornerWithRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
}
- (void)xl_setCornerWithRoundingCorners:(UIRectCorner)corners
                            cornerRadii:(CGSize)cornerRadii {
    [self xl_setCornerWithRoundingCorners:corners cornerRadii:cornerRadii borderColor:nil];
}
- (void)xl_setCornerWithRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii borderColor:(UIColor *)borderColor {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    [self.layer setMask:maskLayer];

    if (borderColor) {
        
        CAShapeLayer *borderLayer = [[CAShapeLayer alloc] init];
        borderLayer.fillColor = [UIColor clearColor].CGColor;
        borderLayer.strokeColor = borderColor.CGColor;
        borderLayer.lineWidth = 2;
        borderLayer.lineJoin = kCALineJoinRound;
        borderLayer.lineCap = kCALineCapRound;
        borderLayer.path = maskPath.CGPath;
        [self.layer insertSublayer:borderLayer atIndex:0];
        //    [self.layer addSublayer:borderLayer];
    }
}

- (void)xl_setBorderWithDashLineWidth:(NSInteger)lineWidth lineColor:(UIColor *)lineColor {
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame = self.bounds;
    borderLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:self.layer.cornerRadius].CGPath;
    borderLayer.lineWidth = lineWidth;
    //虚线边框
    borderLayer.lineDashPattern = @[@8, @8];
    //实线边框
//    borderLayer.lineDashPattern = nil;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = lineColor.CGColor;
    [self.layer addSublayer:borderLayer];
}


- (void)xl_setBorder:(CGFloat)borderWidth color:(UIColor *)color {
    
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = color.CGColor;
}

- (void)setCornerRadius:(CGFloat)radius {
    
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

/** 空白页 */
static char BlankPageViewKey;

- (void)setBlankPageView:(EaseBlankPageView *)blankPageView{
    [self willChangeValueForKey:@"BlankPageViewKey"];
    objc_setAssociatedObject(self, &BlankPageViewKey,
                             blankPageView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"BlankPageViewKey"];
}

- (EaseBlankPageView *)blankPageView{
    return objc_getAssociatedObject(self, &BlankPageViewKey);
}

- (void)configBlankPage:(EaseBlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void (^)(id))block {
    if (hasData) {
        if (self.blankPageView) {
            self.blankPageView.hidden = YES;
            [self.blankPageView removeFromSuperview];
        }
    } else {
        if (!self.blankPageView) {
            self.blankPageView = [[EaseBlankPageView alloc] initWithFrame:self.bounds];
        }
        self.blankPageView.hidden = NO;
        [self.blankPageContainer addSubview:self.blankPageView];
        
        [self.blankPageView configWithType:blankPageType hasData:hasData hasError:hasError reloadButtonBlock:block];
    }
}

- (UIView *)blankPageContainer{
    UIView *blankPageContainer = self;
    for (UIView *aView in [self subviews]) {
        if ([aView isKindOfClass:[UITableView class]]) {
            blankPageContainer = aView;
        }
    }
    return blankPageContainer;
}
@end
