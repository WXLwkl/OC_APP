//
//  UIView+Common.h
//  OC_APP
//
//  Created by xingl on 2017/6/19.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaseBlankPageView.h"

typedef void (^TapActionBlock)(UITapGestureRecognizer *gestureRecoginzer);
typedef void (^LongPressActionBlock)(UILongPressGestureRecognizer *gestureRecoginzer);

@interface UIView (Common)

//badge
@property (strong, nonatomic) UILabel *xl_badge;

/** badge的文字 */
@property (nonatomic) NSString *xl_badgeValue;

/** 背景颜色 */
@property (nonatomic) UIColor *xl_badgeBGColor;

/** 文字颜色 */
@property (nonatomic) UIColor *xl_badgeTextColor;

/** 文字的字体 */
@property (nonatomic) UIFont *xl_badgeFont;

/** badge的padding */
@property (nonatomic) CGFloat xl_badgePadding;

/** 最小的size */
@property (nonatomic) CGFloat xl_badgeMinSize;

/** x坐标 */
@property (nonatomic) CGFloat xl_badgeOriginX;

/** y坐标 */
@property (nonatomic) CGFloat xl_badgeOriginY;

/** 如果是数字0的话就隐藏不显示 */
@property BOOL xl_shouldHideBadgeAtZero;

/** 是否要缩放动画 */
@property BOOL xl_shouldAnimateBadge;



/** 颜色渐变 */
- (void)xl_setGradientLayer:(UIColor*)startColor endColor:(UIColor*)endColor;

/** 移除所有子视图 */
- (void)xl_removeAllSubviews;

/** 添加tap手势 */
- (void)xl_addTapActionWithBlock:(TapActionBlock)block;

/** 添加长按手势 */
- (void)xl_addLongPressActionWithBlock:(LongPressActionBlock)block;

/** 抖动 */
- (void)xl_shake;

/**
 设置圆角(4个)

 @param radius 半径
 */
- (void)xl_setCornerRadius:(CGFloat)radius;

/**
 设置圆角

 @param corners 圆角方位
 @param radius 半径
 */
- (void)xl_setCornerWithRoundingCorners:(UIRectCorner)corners
                                 radius:(CGFloat)radius;
/**
 设置圆角

 @param corners 圆角方位
 @param cornerRadii 半径
 */
- (void)xl_setCornerWithRoundingCorners:(UIRectCorner)corners
                          cornerRadii:(CGSize)cornerRadii;

/**
 设置边框

 @param borderWidth 边框宽度
 @param color 边框颜色
 */
- (void)xl_setBorder:(CGFloat)borderWidth color:(UIColor *)color;


/**
 用Masonry时上面设置圆角方法有问题

 @param radius 圆角半径
 */
- (void)setCornerRadius:(CGFloat)radius;


@property (strong, nonatomic) EaseBlankPageView *blankPageView;
- (void)configBlankPage:(EaseBlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void(^)(id sender))block;
@end
