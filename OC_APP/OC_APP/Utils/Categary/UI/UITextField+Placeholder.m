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

static const void *limitMaxLength = &limitMaxLength;

@implementation UITextField (Placeholder)



- (void)setXl_placeholderColor:(UIColor *)xl_placeholderColor {
    //给成员属性赋值  runtime给系统的类添加成员属性
    objc_setAssociatedObject(self, &placeHolderKey, xl_placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 获取占位文字label控件
    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
    
    // 设置占位文字颜色
    placeholderLabel.textColor = xl_placeholderColor;
}
- (UIColor *)xl_placeholderColor
{
    return objc_getAssociatedObject(self, &placeHolderKey);
}

// 设置占位文字 和 文字颜色
- (void)setXL_Placeholder:(NSString *)placeholder {
    [self setXL_Placeholder:placeholder];
    
    self.xl_placeholderColor = self.xl_placeholderColor;
}

// runtime 交换方法
+ (void)load
{
    // setPlaceholder
    Method setPlaceholderMethod = class_getInstanceMethod(self, @selector(setPlaceholder:));
    Method set_PlaceholderMethod = class_getInstanceMethod(self, @selector(setXL_Placeholder:));
    
    method_exchangeImplementations(setPlaceholderMethod, set_PlaceholderMethod);
}


- (NSInteger)xl_maxLength {
    return [objc_getAssociatedObject(self, limitMaxLength) integerValue];
}
- (void)setXl_maxLength:(NSInteger)xl_maxLength {
    objc_setAssociatedObject(self, limitMaxLength, @(xl_maxLength), OBJC_ASSOCIATION_ASSIGN);
    [self addTarget:self action:@selector(xl_textFieldTextDidChange) forControlEvents:UIControlEventEditingChanged];
}
- (void)xl_textFieldTextDidChange {
    NSString *toBeString = self.text;
    //获取高亮部分
    UITextRange *selectedRange = [self markedTextRange];
    UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
    
    //没有高亮选择的字，则对已输入的文字进行字数统计和限制
    //在iOS7下,position对象总是不为nil
    if ( (!position ||!selectedRange) && (self.xl_maxLength > 0 && toBeString.length > self.xl_maxLength)) {
        NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.xl_maxLength];
        if (rangeIndex.length == 1) {
            self.text = [toBeString substringToIndex:self.xl_maxLength];
        } else {
            NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.xl_maxLength)];
            NSInteger tmpLength;
            if (rangeRange.length > self.xl_maxLength) {
                tmpLength = rangeRange.length - rangeIndex.length;
            }else{
                tmpLength = rangeRange.length;
            }
            self.text = [toBeString substringWithRange:NSMakeRange(0, tmpLength)];
        }
    }
}







- (void)xl_error {
    
    CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    keyFrame.duration = 0.3;
    CGFloat x = self.layer.position.x;
    keyFrame.values = @[@(x - 30), @(x - 30), @(x + 20), @(x - 20), @(x + 10), @(x - 10), @(x + 5), @(x - 5)];
    [self.layer addAnimation:keyFrame forKey:@"shake"];
}

@end
