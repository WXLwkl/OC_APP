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


@implementation UIButton (Button)


static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";

- (NSTimeInterval)xl_acceptEventInterval {
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

- (void)setXl_acceptEventInterval:(NSTimeInterval)cs_acceptEventInterval {
    objc_setAssociatedObject(self, UIControl_acceptEventInterval,@(cs_acceptEventInterval),OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static const char *UIControl_acceptEventTime = "UIControl_acceptEventTime";

- (NSTimeInterval)xl_acceptEventTime {
    return  [objc_getAssociatedObject(self, UIControl_acceptEventTime) doubleValue];
}

- (void)setXl_acceptEventTime:(NSTimeInterval)cs_acceptEventTime {
    objc_setAssociatedObject(self, UIControl_acceptEventTime, @(cs_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



//+ (void)load {
//    Method before   = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
//    Method after    = class_getInstanceMethod(self, @selector(xl_sendAction:to:forEvent:));
//    method_exchangeImplementations(before, after);
//}

- (void)xl_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if ([NSDate date].timeIntervalSince1970 - self.xl_acceptEventTime < self.xl_acceptEventInterval) {
        return;
    }
    
    if (self.xl_acceptEventInterval > 0) {
        self.xl_acceptEventTime = [NSDate date].timeIntervalSince1970;
    }
    
    [self xl_sendAction:action to:target forEvent:event];
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
