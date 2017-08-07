//
//  UIColor+Common.h
//  OC_APP
//
//  Created by xingl on 2017/6/9.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Common)

+ (UIColor *)xl_colorWithHexString:(NSString *)hexString;
+ (UIColor *)xl_colorWithHexNumber:(NSUInteger)hexColor;


/** 随机颜色 */
+ (UIColor *)xl_randomColor;


/**
 获取图片的相应点的像素颜色

 @param point 图片中的店
 @param image 要选取颜色的图片
 @return 返回颜色
 */
+ (UIColor *)xl_getPixelColorAtLocation:(CGPoint)point inImage:(UIImage *)image;


/**
 根据图片获取图片的主色调

 @param image 要获取颜色的图片
 @return 主色调
 */
+ (UIColor *)xl_getMainColorFromImage:(UIImage *)image;
@end
