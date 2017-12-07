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
 图片增加圆角

 @param radius 圆角半径
 @return 带圆角的图片
 */
- (UIImage *)xl_imageByRoundCornerRadius:(CGFloat)radius;


/**
 图片增加圆角及边框

 @param radius 圆角半径
 @param borderWidth 边框宽度
 @param borderColor 边框颜色
 @return image
 */
- (UIImage *)xl_imageByRoundCornerRadius:(CGFloat)radius
                           borderWidth:(CGFloat)borderWidth
                           borderColor:(UIColor *)borderColor;



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

/** 图片的裁剪 */
- (UIImage *)xl_imageCutSize:(CGRect)rect;

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


/** 添加文字水印 */
- (UIImage *)xl_imageWithTitle:(NSString *)title
                      fontSize:(CGFloat)fontSize
                         color:(UIColor *)color;

/** 将图片旋转角度degrees */
- (UIImage *)xl_imageRotatedByDegrees:(CGFloat)degrees;

/** 将图片旋转弧度radians */
- (UIImage *)xl_imageRotatedByRadians:(CGFloat)radians;

/**
 图片压缩

 @param maxLength 最大字节
 @return 压缩后的图片
 */
- (NSData *)xl_compressWithMaxLength:(NSInteger)maxLength;



/** base64编码 */
- (NSString *)xl_base64EncodedString;

//图片加马赛克
- (UIImage *)xl_mosaicImageWithLevel:(int)level;


/**
 获取图片上某一点的颜色
 
 @param point  图片内的一个点。范围是 [0, image.width-1],[0, image.height-1]
 超出图片范围则返回nil
 */
- (UIColor *)xl_colorAtPoint:(CGPoint)point;

/**
 该图片是否有alpha通道
 */
- (BOOL)xl_hasAlphaChannel;


@end


@interface UIImage (Blur)

//玻璃化效果，这里与系统的玻璃化枚举效果一样，但只是一张图
- (UIImage *)xl_imageByBlurSoft;

- (UIImage *)xl_imageByBlurLight;

- (UIImage *)xl_imageByBlurExtraLight;

- (UIImage *)xl_imageByBlurDark;

- (UIImage *)xl_imageByBlurWithTint:(UIColor *)tintColor;

- (UIImage *)xl_imageByBlurRadius:(CGFloat)blurRadius
                     tintColor:(UIColor *)tintColor
                      tintMode:(CGBlendMode)tintBlendMode
                    saturation:(CGFloat)saturation
                     maskImage:(UIImage *)maskImage;

@end



@interface UIImage (ImageEffects)

//图片效果

- (UIImage *)xl_applyLightEffect;
- (UIImage *)xl_applyExtraLightEffect;
- (UIImage *)xl_applyDarkEffect;
- (UIImage *)xl_applyBlurEffect;
- (UIImage *)xl_applyTintEffectWithColor:(UIColor *)tintColor;
- (UIImage *)xl_applyBlurWithRadius:(CGFloat)blurRadius
                       tintColor:(UIColor *)tintColor
           saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                       maskImage:(UIImage *)maskImage;
@end

