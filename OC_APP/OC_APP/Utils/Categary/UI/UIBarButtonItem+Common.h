//
//  UIBarButtonItem+Common.h
//  OC_APP
//
//  Created by xingl on 2017/8/1.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Common)


/**
 根据图片名生成 UIBarButtonItem

 @param imageName 图片名
 @param imageNameH 高亮图片名
 */
+ (UIBarButtonItem *)xl_itemImage:(NSString *)imageName
                   highlightImage:(NSString *)imageNameH
                           target:(NSObject *)target
                              sel:(SEL)sel;

/**
 根据图片生成 UIBarButtonItem

 @param image 正常图片
 @param imageH 高亮图片
 */
+ (UIBarButtonItem *)xl_itemImage:(UIImage *)image
                        highlight:(UIImage *)imageH
                           target:(NSObject *)target
                              sel:(SEL)sel;

/**
 根据文字生成 UIBarButtonItem 可设置颜色

 @param title 文字
 @param titleColor 文字颜色
 */
+ (UIBarButtonItem *)xl_itemTitle:(NSString *)title
                            color:(UIColor *)titleColor
                           target:(NSObject *)target
                              sel:(SEL)sel;

/**
 根据文字生成 UIBarButtonItem 可设置颜色 字体

 @param title 文字
 @param titleColor 文字颜色
 @param font 字体
 */
+ (UIBarButtonItem *)xl_itemTitle:(NSString *)title
                            color:(UIColor *)titleColor
                             font:(UIFont *)font
                           target:(NSObject *)target
                              sel:(SEL)sel;

@end
