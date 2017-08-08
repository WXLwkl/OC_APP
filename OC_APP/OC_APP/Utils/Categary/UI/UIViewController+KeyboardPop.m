//
//  UIViewController+KeyboardPop.m
//  OC_APP
//
//  Created by xingl on 2017/8/8.
//  Copyright © 2017年 兴林. All rights reserved.
//
//    解决有键盘的页面 导航条手势返回时 键盘不下去，效果为仿微信的
//

#import "UIViewController+KeyboardPop.h"
#import <objc/runtime.h>

@interface UIViewController ()

@property (nonatomic, strong) UIResponder *previousResponder;

@end

@implementation UIViewController (KeyboardPop)

+ (void)load {
    if ([self instancesRespondToSelector:@selector(transitionCoordinator)]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self tap_swizzleSelector:@selector(viewWillAppear:) withSelector:@selector(tap_viewWillAppear:)];
            [self tap_swizzleSelector:@selector(viewWillDisappear:) withSelector:@selector(tap_viewWillDisappear:)];
            [self tap_swizzleSelector:@selector(beginAppearanceTransition:animated:) withSelector:@selector(tap_beginAppearanceTransition:animated:)];
        });
    }
}

+ (void)tap_swizzleSelector:(SEL)originalSelector withSelector:(SEL)swizzledSelector {
    
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}
- (void)tap_viewWillAppear:(BOOL)animated {
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(tap_didBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [center addObserver:self selector:@selector(tap_didBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [center addObserver:self selector:@selector(tap_didEndEditing:) name:UIKeyboardDidHideNotification object:nil];
    
    [self tap_viewWillAppear:animated];
}
- (void)tap_didBeginEditing:(NSNotification *)note {
    UIResponder *firstResponder = note.object;
    self.previousResponder = firstResponder;
    if (!firstResponder.inputAccessoryView) {
        [firstResponder performSelector:@selector(setInputAccessoryView:) withObject:[UIView new]];
    }
}
- (void)tap_didEndEditing:(NSNotification *)note {
    self.previousResponder = nil;
}

- (void)tap_viewWillDisappear:(BOOL)animated {
    [self tap_viewWillDisappear:animated];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:nil];
    [center removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
    
    [center removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}
- (void)tap_beginAppearanceTransition:(BOOL)isAppearing animated:(BOOL)animated {
    
    [self tap_beginAppearanceTransition:isAppearing animated:animated];
    if (isAppearing || !animated || self.previousResponder == nil)  return;
    
    UIView *keyboardView = self.previousResponder.inputAccessoryView.superview;
    if (!keyboardView) {
        [self.previousResponder becomeFirstResponder];
        keyboardView = self.previousResponder.inputAccessoryView.superview;
        if (!keyboardView) {
            return;
        } else {
            [self.previousResponder resignFirstResponder];
        }
    }
    
    [self.previousResponder becomeFirstResponder];
    [self.transitionCoordinator animateAlongsideTransitionInView:keyboardView animation:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        UIView *fromView = [[context viewControllerForKey:UITransitionContextFromViewControllerKey] view];
        CGRect endFrame = keyboardView.frame;
        endFrame.origin.x = fromView.frame.origin.x;
        keyboardView.frame = endFrame;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if ([context isCancelled]) {
            return;
        }
        [self.previousResponder resignFirstResponder];
        self.previousResponder = nil;
    }];
}

- (UIResponder *)previousResponder {
    return objc_getAssociatedObject(self, @selector(previousResponder));
}
- (void)setPreviousResponder:(UIResponder *)previousResponder {
    objc_setAssociatedObject(self, @selector(previousResponder), previousResponder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);//objc_association_retain_nonatomic
}


@end
