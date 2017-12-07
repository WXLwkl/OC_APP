//
//  UIButton+Button.m
//  OC_APP
//
//  Created by xingl on 2017/6/29.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "UIButton+Button.h"
#import <objc/runtime.h>

static NSString *const IndicatorViewKey = @"indicatorView";
static NSString *const ButtonTextObjectKey = @"buttonTextObject";
static const NSString *HitTestEdgeInsetsKey = @"HitTestEdgeInsets";

@implementation UIButton (Button)

//@dynamic xl_hitTestEdgeInsets;

- (void)setXl_hitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = [NSValue value:&hitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, &HitTestEdgeInsetsKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIEdgeInsets)xl_hitTestEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, &HitTestEdgeInsetsKey);
    if (value) {
        UIEdgeInsets edgeInsets;
        [value getValue:&edgeInsets];
        return edgeInsets;
    } else {
        return UIEdgeInsetsZero;
    }
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (UIEdgeInsetsEqualToEdgeInsets(self.xl_hitTestEdgeInsets, UIEdgeInsetsZero) || !self.enabled || self.hidden) {
        return [super pointInside:point withEvent:event];
    }
    
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.xl_hitTestEdgeInsets);
    
    return CGRectContainsPoint(hitFrame, point);
}

+ (instancetype)xl_buttonWithTitle:(NSString *)title
                         backColor:(UIColor *)backColor
                     backImageName:(NSString *)backImageName
                        titleColor:(UIColor *)color
                          fontSize:(int)fontSize
                             frame:(CGRect)frame
                      cornerRadius:(CGFloat)cornerRadius {
    
    UIButton *button = [UIButton new];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundColor:backColor];
    [button setBackgroundImage:[UIImage imageNamed:backImageName] forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [button sizeToFit];
    button.frame = frame;
    button.layer.cornerRadius = cornerRadius;
    button.clipsToBounds = YES;
    return button;
}

- (void)xl_addActionHandler:(TouchedButtonBlock)touchHandler
{
    objc_setAssociatedObject(self, @selector(xl_addActionHandler:), touchHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(blockActionTouched:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)blockActionTouched:(UIButton *)btn {
    TouchedButtonBlock block = objc_getAssociatedObject(self, @selector(xl_addActionHandler:));
    if (block) {
        block();
    }
}

- (void)xl_showIndicator {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    [indicator startAnimating];
    
    NSString *currentButtonText = self.titleLabel.text;
    
    objc_setAssociatedObject(self, &ButtonTextObjectKey, currentButtonText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &IndicatorViewKey, indicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    self.enabled = NO;
    [self setTitle:@"" forState:UIControlStateNormal];
    [self addSubview:indicator];
}
- (void)xl_hideIndicator {
    NSString *currentButtonText = (NSString *)objc_getAssociatedObject(self, &ButtonTextObjectKey);
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)objc_getAssociatedObject(self, &IndicatorViewKey);
    
    self.enabled = YES;
    [indicator removeFromSuperview];
    [self setTitle:currentButtonText forState:UIControlStateNormal];
}


@end
