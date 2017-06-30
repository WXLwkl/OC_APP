//
//  UITextField+Placeholder.m
//  OC_APP
//
//  Created by xingl on 2017/6/27.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "UITextField+Placeholder.h"

#import <objc/message.h>

static const void *placeHolderKey;

@implementation UITextField (Placeholder)

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    //给成员属性赋值  runtime给系统的类添加成员属性
    objc_setAssociatedObject(self, &placeHolderKey, placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 获取占位文字label控件
    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
    
    // 设置占位文字颜色
    placeholderLabel.textColor = placeholderColor;
}
- (UIColor *)placeholderColor
{
    return objc_getAssociatedObject(self, &placeHolderKey);
}

// 设置占位文字 和 文字颜色
- (void)set_Placeholder:(NSString *)placeholder {
    [self set_Placeholder:placeholder];
    
    self.placeholderColor = self.placeholderColor;
}

// runtime 交换方法
+ (void)load
{
    // setPlaceholder
    Method setPlaceholderMethod = class_getInstanceMethod(self, @selector(setPlaceholder:));
    Method set_PlaceholderMethod = class_getInstanceMethod(self, @selector(set_Placeholder:));
    
    method_exchangeImplementations(setPlaceholderMethod, set_PlaceholderMethod);
}

- (void)xl_error {
    
    CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    keyFrame.duration = 0.3;
    CGFloat x = self.layer.position.x;
    keyFrame.values = @[@(x - 30), @(x - 30), @(x + 20), @(x - 20), @(x + 10), @(x - 10), @(x + 5), @(x - 5)];
    [self.layer addAnimation:keyFrame forKey:@"shake"];
}

@end
