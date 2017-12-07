//
//  UIBarButtonItem+Common.h
//  OC_APP
//
//  Created by xingl on 2017/8/1.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Common)


+ (UIBarButtonItem *)xl_itemImage:(NSString *)imageName
                   highlightImage:(NSString *)imageNameH
                           target:(NSObject *)target
                              sel:(SEL)sel;

+ (UIBarButtonItem *)xl_itemImage:(UIImage *)image
                        highlight:(UIImage *)imageH
                           target:(NSObject *)target
                              sel:(SEL)sel;

+ (UIBarButtonItem *)xl_itemTitle:(NSString *)title
                            color:(UIColor *)titleColor
                           target:(NSObject *)target
                              sel:(SEL)sel;

+ (UIBarButtonItem *)xl_itemTitle:(NSString *)title
                            color:(UIColor *)titleColor
                             font:(UIFont *)font
                           target:(NSObject *)target
                              sel:(SEL)sel;

@end
