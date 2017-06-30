//
//  UIView+Common.h
//  OC_APP
//
//  Created by xingl on 2017/6/19.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TapActionBlock)(UITapGestureRecognizer *gestureRecoginzer);
typedef void (^LongPressActionBlock)(UILongPressGestureRecognizer *gestureRecoginzer);

@interface UIView (Common)



//badge
@property (strong, nonatomic) UILabel *badge;

/** badge的文字 */
@property (nonatomic) NSString *badgeValue;

/** 背景颜色 */
@property (nonatomic) UIColor *badgeBGColor;

/** 文字颜色 */
@property (nonatomic) UIColor *badgeTextColor;

/** 文字的字体 */
@property (nonatomic) UIFont *badgeFont;

/** badge的padding */
@property (nonatomic) CGFloat badgePadding;

/** 最小的size */
@property (nonatomic) CGFloat badgeMinSize;

/** x坐标 */
@property (nonatomic) CGFloat badgeOriginX;

/** y坐标 */
@property (nonatomic) CGFloat badgeOriginY;

/** 如果是数字0的话就隐藏不显示 */
@property BOOL shouldHideBadgeAtZero;

/** 是否要缩放动画 */
@property BOOL shouldAnimateBadge;

/** 颜色渐变 */
- (void)setGradientLayer:(UIColor*)startColor endColor:(UIColor*)endColor;

/** 移除所有子视图 */
- (void)xl_removeAllSubviews;

/** 添加tap手势 */
- (void)xl_addTapActionWithBlock:(TapActionBlock)block;

/** 添加长按手势 */
- (void)xl_addLongPressActionWithBlock:(LongPressActionBlock)block;


@end
