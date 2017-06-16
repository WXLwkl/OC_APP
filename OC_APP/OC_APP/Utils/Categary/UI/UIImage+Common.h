//
//  UIImage+Common.h
//  OC_APP
//
//  Created by xingl on 2017/6/6.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Common)


/**
 图片裁剪，适用于圆形头像之类

 @param image 要切圆的图片
 @param borderWidth 边框宽度
 @return 切圆的图片
 */
+ (UIImage *)xl_imageWithClipImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)color;


/**
 截屏或者截取某个view视图

 @param captureView 要截取的view视图
 @return 返回截图
 */
+ (UIImage *)xl_imageWithCaptureView:(UIView *)captureView;


/**
 根据颜色返回图片

 @param color 颜色
 @return 图片
 */
+ (UIImage *)xl_imageWithColor:(UIColor *)color;


/**
 图片的等比例缩放

 @param image 要缩放的原始图片
 @param defineWidth 要缩放到的宽度
 @return 返回与原图片等宽高比的图片
 */
+ (UIImage *)xl_imageWithOriginImage:(UIImage *)image scaleToWidth:(CGFloat)defineWidth;


/**
 根据图片名返回一张能够自由拉伸的图片

 @param name 图片名
 @param width 自由拉伸的宽度
 @param height 自由拉伸的高度
 @return 返回图片
 */
+ (UIImage *)xl_imageWithResizedImage:(NSString *)name leftCapWidth:(CGFloat)width topCapHeight:(CGFloat)height;

/**
 添加文字水印
 
 @param imageName 图片名
 @param markString 文字内容
 @param color 文本颜色
 @param font 字体
 @return 添加后的图片
 */

+ (UIImage *)xl_imageWithWaterMarkImage:(NSString *)imageName
                             markString:(NSString *)markString
                                  color:(UIColor *)color
                                   font:(UIFont *)font;


@end



