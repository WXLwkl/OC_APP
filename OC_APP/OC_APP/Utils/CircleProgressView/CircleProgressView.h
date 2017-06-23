//
//  CircleProgressView.h
//  OC_APP
//
//  Created by xingl on 2017/6/19.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleProgressView : UIView


/**
 设置圆弧渐变的起始色
 */
@property (nonatomic, strong) UIColor *minLineColor;

/**
 设置圆弧渐变的中间色
 */
@property (nonatomic, strong) UIColor *midLineColor;

/**
 设置圆弧渐变的终止色
 */
@property (nonatomic, strong) UIColor *maxLineColor;

/**
 设置圆弧的背景色
 */
@property (nonatomic, strong) UIColor *lineTintColor;

/**
 设置进度
 */
@property (nonatomic, assign) CGFloat progress;

/**
 设置圆弧线条的宽度 max = 20 min = 0.5
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 设置是否显示百分比标签
 */
@property (nonatomic, assign) BOOL showTipLabel;

/**
 设置百分比标签进度颜色
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 设置进度

 @param progress 进度 取值0-1
 @param animated 是否显示动画
 */
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;
@end
