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

@end
