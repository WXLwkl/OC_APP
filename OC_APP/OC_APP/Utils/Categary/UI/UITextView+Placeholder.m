//
//  UITextView+Placeholder.m
//  OC_APP
//
//  Created by xingl on 2017/6/12.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "UITextView+Placeholder.h"
#import <objc/runtime.h>

static const void *placeHolderKey;

//@interface UITextView (Placeholder)

//@property (nonatomic, readonly) UILabel *placeholderLabel;

//@end

@implementation UITextView (Placeholder)

+ (void)load {
    [super load];
    Method layoutM = class_getInstanceMethod(self.class, NSSelectorFromString(@"layoutSubviews"));
    Method layoutSwizzlingM = class_getInstanceMethod(self.class, @selector(placeHolder_swizzling_layoutSubviews));
    method_exchangeImplementations(layoutM, layoutSwizzlingM);
    
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")), class_getInstanceMethod(self.class, @selector(placeHolder_swizzling_dealloc)));
    
}


- (void)placeHolder_swizzling_layoutSubviews {
    
    if (self.xl_placeholder) {
        UIEdgeInsets textContainerInset = self.textContainerInset;
        CGFloat lineFragmentPadding = self.textContainer.lineFragmentPadding;
        CGFloat x = lineFragmentPadding + textContainerInset.left + self.layer.borderWidth;
        CGFloat y = textContainerInset.top + self.layer.borderWidth;
        CGFloat width = CGRectGetWidth(self.bounds) - x - textContainerInset.right - 2*self.layer.borderWidth;
        CGFloat height = [self.placeholderLabel sizeThatFits:CGSizeMake(width, 0)].height;
        self.placeholderLabel.frame = CGRectMake(x, y, width, height);
    }
    [self placeHolder_swizzling_layoutSubviews];
    
}
- (void)placeHolder_swizzling_dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self placeHolder_swizzling_dealloc];
}
#pragma mark - associated
- (NSString *)xl_placeholder {
    
    return objc_getAssociatedObject(self, &placeHolderKey);
}

- (void)setXl_placeholder:(NSString *)xl_placeholder {
    objc_setAssociatedObject(self, &placeHolderKey, xl_placeholder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updatePlaceHolder];
}

- (UIColor *)xl_placeholderColor {
    return self.placeholderLabel.textColor;
}

- (void)setXl_placeholderColor:(UIColor *)xl_placeholderColor {
    self.placeholderLabel.textColor = xl_placeholderColor;
}
#pragma mark - update
- (void)updatePlaceHolder {
    if (self.text.length) {
        [self.placeholderLabel removeFromSuperview];
        return;
    }
    self.placeholderLabel.font = self.font ? self.font : self.cacutDefaultFont;
    self.placeholderLabel.textAlignment = self.textAlignment;
    self.placeholderLabel.text = self.xl_placeholder;
    [self insertSubview:self.placeholderLabel atIndex:0];
}

#pragma mark - lazy
- (UILabel *)placeholderLabel {
    UILabel *placeholderLabel = objc_getAssociatedObject(self, @selector(placeholderLabel));
    if (!placeholderLabel) {
        placeholderLabel = [UILabel new];
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.textColor = [UIColor lightGrayColor];
        objc_setAssociatedObject(self, @selector(placeholderLabel), placeholderLabel, OBJC_ASSOCIATION_RETAIN);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlaceHolder) name:UITextViewTextDidChangeNotification object:self];
    }
    return placeholderLabel;
}

- (UIFont *)cacutDefaultFont {
    static UIFont *font = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UITextView *textview = [[UITextView alloc] init];
        textview.text = @" ";
        font = textview.font;
    });
    return font;
}
@end
