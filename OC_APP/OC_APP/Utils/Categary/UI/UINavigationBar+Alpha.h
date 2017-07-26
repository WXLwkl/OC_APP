//
//  UINavigationBar+Alpha.h
//
//  Created by xingl on 2017/6/7.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (Alpha)

///设置背景颜色
- (void)xl_setBackgroundColor:(UIColor *)backgroundColor;

///设置导航栏中包含的视图元素的透明度
- (void)xl_setElementsAlpha:(CGFloat)alpha;

///重置导航栏为默认样式
- (void)xl_reset;

@end
