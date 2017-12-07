//
//  UIButton+Button.h
//  OC_APP
//
//  Created by xingl on 2017/6/29.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TouchedButtonBlock)(void);

@interface UIButton (Button)

//扩大点击区域
@property(nonatomic, assign) UIEdgeInsets xl_hitTestEdgeInsets;



//快速创建按钮
+ (instancetype)xl_buttonWithTitle:(NSString *)title backColor:(UIColor *)backColor backImageName:(NSString *)backImageName titleColor:(UIColor *)color fontSize:(int)fontSize frame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius;

//点击按钮之后的动作
- (void)xl_addActionHandler:(TouchedButtonBlock)touchHandler;

/** 显示菊花 */
- (void)xl_showIndicator;

/** 隐藏菊花 */
- (void)xl_hideIndicator;



@end
