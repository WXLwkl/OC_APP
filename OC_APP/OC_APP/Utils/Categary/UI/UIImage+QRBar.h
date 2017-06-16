//
//  UIImage+QRBar.h
//  OC_APP
//
//  Created by xingl on 2017/6/6.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (QRBar)


//Avilable in iOS 7.0 and later

/*!
 *  @author 逍遥郎happy, 16-08-24 14:08:20
 *
 *  @brief 生成黑白相间的二维码
 *
 *  @param content 二维码内容
 *  @param lenght  输出二维码图片的边长
 *
 *  @return 二维码图片
 */
+ (UIImage *)xl_qrCodeImageWithContent:(NSString *)content
                    codeImageLenght:(CGFloat)lenght;
/*!
 *  @author 逍遥郎happy, 16-08-24 14:08:32
 *
 *  @brief 生成黑白相间带logo的二维码
 *
 *  @param content 二维码内容
 *  @param lenght  输出二维码图片的边长
 *  @param logo    二维码中心的logo图片
 *  @param radius  logo圆角的大小 5~15
 *
 *  @return 二维码图片
 */
+ (UIImage *)xl_qrCodeImageWithContent:(NSString *)content
                    codeImageLenght:(CGFloat)lenght
                               logo:(UIImage *)logo
                             radius:(CGFloat)radius;

/*!
 *  @author 逍遥郎happy, 16-08-24 14:08:42
 *
 *  @brief 生成可变颜色带logo的二维码
 *
 *  @param content 二维码内容
 *  @param lenght  输出二维码图片的边长
 *  @param logo    二维码中心的logo图片
 *  @param radius  logo圆角的大小 5~15
 *  @param red     red
 *  @param green   green
 *  @param blue    blue
 *
 *  @return 二维码图片
 */
+ (UIImage *)xl_qrCodeImageWithContent:(NSString *)content
                      codeImageLenght:(CGFloat)lenght
                               logo:(UIImage *)logo
                             radius:(CGFloat)radius
                                red:(CGFloat)red
                              green:(CGFloat)green
                               blue:(CGFloat)blue;

//Avilable in iOS 8.0 and later

/**
 彩色的条形码

 @param content 条形码信息
 @param size 条形码大小
 @param red red
 @param green gree
 @param blue blue
 @return 彩色的条形码
 */
+ (UIImage *)xl_barCodeImageWithContent:(NSString *)content
                       codeImageSize:(CGSize)size
                                 red:(CGFloat)red
                               green:(CGFloat)green
                                blue:(CGFloat)blue;

/**
 黑白的条形码

 @param content 条形码内容
 @param size 条形码大小
 @return 黑白条形码
 */
+ (UIImage *)xl_barCodeImageWithContent:(NSString *)content
                        codeImageSize:(CGSize)size;


@end
