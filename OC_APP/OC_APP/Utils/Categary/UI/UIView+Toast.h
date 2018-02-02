//
//  UIView+Toast.h
//  OC_APP
//
//  Created by xingl on 2018/1/11.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const ToastPositionTop;
extern NSString * const ToastPositionCenter;
extern NSString * const ToastPositionBottom;

@interface UIView (Toast)

- (void)makeToast:(NSString *)message;
- (void)makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position;
- (void)makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position image:(UIImage *)image;
- (void)makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position title:(NSString *)title;
- (void)makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position title:(NSString *)title image:(UIImage *)image;

- (void)makeToastActivity;
- (void)makeToastActivity:(id)position;
- (void)hideToastActivity;

- (void)showToast:(UIView *)toast;
- (void)showToast:(UIView *)toast duration:(NSTimeInterval)interval position:(id)point;
- (void)showToast:(UIView *)toast duration:(NSTimeInterval)interval position:(id)point tapCallback:(void(^)(void))tapCallback;


@end
