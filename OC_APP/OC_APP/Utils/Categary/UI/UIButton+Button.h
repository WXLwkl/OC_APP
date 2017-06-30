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


@property (nonatomic, assign)NSTimeInterval xl_acceptEventInterval;//重复点击的时间

@property (nonatomic, assign)NSTimeInterval xl_acceptEventTime;



//快速创建按钮
+ (instancetype)xl_buttonWithTitle:(NSString *)title backColor:(UIColor *)backColor backImageName:(NSString *)backImageName titleColor:(UIColor *)color fontSize:(int)fontSize frame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius;

//点击按钮之后的动作
- (void)xl_addActionHandler:(TouchedButtonBlock)touchHandler;

/** 显示菊花 */
- (void)xl_showIndicator;

/** 隐藏菊花 */
- (void)xl_hideIndicator;



@end
