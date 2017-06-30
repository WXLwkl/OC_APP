//
//  UITextField+Placeholder.h
//  OC_APP
//
//  Created by xingl on 2017/6/27.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Placeholder)
/*
 *设置占位文字的颜色
 * @param placeholderColor  占位文字的颜色 属性
 * 通过这个属性名，就可以修改textField内部的占位文字颜色
 */
@property UIColor *placeholderColor;


- (void)xl_error;

@end
