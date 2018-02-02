//
//  UIView+Toast.m
//  OC_APP
//
//  Created by xingl on 2018/1/11.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "UIView+Toast.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

// general appearance
static const CGFloat ToastMaxWidth            = 0.8;      // 80% of parent view width
static const CGFloat ToastMaxHeight           = 0.8;      // 80% of parent view height
static const CGFloat ToastHorizontalPadding   = 10.0;
static const CGFloat ToastVerticalPadding     = 10.0;
static const CGFloat ToastCornerRadius        = 10.0;
static const CGFloat ToastOpacity             = 0.8;
static const CGFloat ToastFontSize            = 16.0;
static const CGFloat ToastMaxTitleLines       = 0;
static const CGFloat ToastMaxMessageLines     = 0;
static const NSTimeInterval ToastFadeDuration = 0.2;

// shadow appearance
static const CGFloat ToastShadowOpacity       = 0.8;
static const CGFloat ToastShadowRadius        = 6.0;
static const CGSize  ToastShadowOffset        = { 4.0, 4.0 };
static const BOOL    ToastDisplayShadow       = YES;

// display duration
static const NSTimeInterval ToastDefaultDuration  = 3.0;

// image view size
static const CGFloat ToastImageViewWidth      = 80.0;
static const CGFloat ToastImageViewHeight     = 80.0;

// activity
static const CGFloat ToastActivityWidth       = 100.0;
static const CGFloat ToastActivityHeight      = 100.0;
static const NSString * ToastActivityDefaultPosition = @"center";

// interaction
static const BOOL ToastHidesOnTap             = YES;     // excludes activity views

// associative reference keys
static const NSString * ToastTimerKey         = @"ToastTimerKey";
static const NSString * ToastActivityViewKey  = @"ToastActivityViewKey";
static const NSString * ToastTapCallbackKey   = @"ToastTapCallbackKey";

// positions
NSString * const ToastPositionTop             = @"top";
NSString * const ToastPositionCenter          = @"center";
NSString * const ToastPositionBottom          = @"bottom";



@implementation UIView (Toast)

- (void)makeToast:(NSString *)message {
    [self makeToast:message duration:ToastDefaultDuration position:nil];
}

- (void)makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position {
    UIView *toast = [self viewForMessage:message title:nil image:nil];
    [self showToast:toast duration:duration position:position];
}

- (void)makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position title:(NSString *)title {
    UIView *toast = [self viewForMessage:message title:title image:nil];
    [self showToast:toast duration:duration position:position];
}

- (void)makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position image:(UIImage *)image {
    UIView *toast = [self viewForMessage:message title:nil image:image];
    [self showToast:toast duration:interval position:position];
}

- (void)makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position title:(NSString *)title image:(UIImage *)image {
    UIView *toast = [self viewForMessage:message title:title image:image];
    [self showToast:toast duration:interval position:position];
}

- (void)showToast:(UIView *)toast {
    [self showToast:toast duration:ToastDefaultDuration position:nil];
}

- (void)showToast:(UIView *)toast duration:(NSTimeInterval)interval position:(id)point {
    [self showToast:toast duration:interval position:point tapCallback:nil];
}

- (void)showToast:(UIView *)toast duration:(NSTimeInterval)interval position:(id)position tapCallback:(void (^)(void))tapCallback {
    toast.center = [self centerPointForPosition:position withToast:toast];
    toast.alpha = 0.0;

    if (ToastHidesOnTap) {
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:toast action:@selector(handleToastTapped:)];
        [toast addGestureRecognizer:recognizer];
        toast.userInteractionEnabled = YES;
        toast.exclusiveTouch = YES;
    }
    [self addSubview:toast];

    [UIView animateKeyframesWithDuration:ToastFadeDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction animations:^{
        toast.alpha = 1.0;
    } completion:^(BOOL finished) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(toastTimerDidFinish:) userInfo:toast repeats:NO];
        objc_setAssociatedObject(toast, &ToastTimerKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(toast, &ToastTapCallbackKey, tapCallback, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }];
}

- (void)hideToast:(UIView *)toast {
    [UIView animateWithDuration:ToastFadeDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState animations:^{
        toast.alpha = 0.0;
    } completion:^(BOOL finished) {
        [toast removeFromSuperview];
    }];
}

#pragma mark - Events
- (void)toastTimerDidFinish:(NSTimer *)timer {
    [self hideToast:(UIView *)timer.userInfo];
}

- (void)handleToastTapped:(UITapGestureRecognizer *)recognizer {
    NSTimer *timer = (NSTimer *)objc_getAssociatedObject(self, &ToastTimerKey);
    [timer invalidate];

    void (^callback)(void) = objc_getAssociatedObject(self, &ToastTapCallbackKey);
    if (callback) {
        callback();
    }
    [self hideToast:recognizer.view];
}

#pragma mark - Toast Activity Methods
- (void)makeToastActivity {
    [self makeToastActivity:ToastActivityDefaultPosition];
}

- (void)makeToastActivity:(id)position {
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &ToastActivityViewKey);
    if (existingActivityView != nil) return;

    UIView *activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ToastActivityWidth, ToastActivityHeight)];
    activityView.center = [self centerPointForPosition:position withToast:activityView];
    activityView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:ToastOpacity];
    activityView.alpha = 0.0;
    activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    activityView.layer.cornerRadius = ToastCornerRadius;

    if (ToastDisplayShadow) {
        activityView.layer.shadowColor = [UIColor blackColor].CGColor;
        activityView.layer.shadowOpacity = ToastShadowOpacity;
        activityView.layer.shadowRadius = ToastShadowRadius;
        activityView.layer.shadowOffset = ToastShadowOffset;
    }

    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.center = CGPointMake(activityView.bounds.size.width / 2, activityView.bounds.size.height / 2);
    [activityView addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];

    objc_setAssociatedObject(self, &ToastActivityViewKey, activityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addSubview:activityView];

    [UIView animateWithDuration:ToastFadeDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        activityView.alpha = 1.0;
    } completion:nil];
}

- (void)hideToastActivity {
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &ToastActivityViewKey);
    if (existingActivityView != nil) {
        [UIView animateWithDuration:ToastFadeDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState animations:^{
            existingActivityView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [existingActivityView removeFromSuperview];
            objc_setAssociatedObject(self, &ToastActivityViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }];
    }
}

#pragma mark - Helpers
- (CGPoint)centerPointForPosition:(id)position withToast:(UIView *)toast {
    if ([position isKindOfClass:[NSString class]]) {
        if ([position caseInsensitiveCompare:ToastPositionTop] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width / 2, (toast.frame.size.height / 2) + ToastVerticalPadding);
        } else if ([position caseInsensitiveCompare:ToastPositionCenter] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        }
    } else if ([position isKindOfClass:[NSValue class]]) {
        return [position CGPointValue];
    }
    return CGPointMake(self.bounds.size.width / 2, self.bounds.size.height - (toast.frame.size.height / 2) - ToastVerticalPadding);
}


- (CGSize)sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode {
    if ([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = lineBreakMode;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
        CGRect boundingRect = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        return CGSizeMake(ceilf(boundingRect.size.width), ceilf(boundingRect.size.height));
    }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [string sizeWithFont:font constrainedToSize:constrainedSize lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
}

- (UIView *)viewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image {
    if ((message == nil) && (title == nil) && (image == nil)) return nil;

    UILabel *messageLabel = nil;
    UILabel *titleLabel = nil;
    UIImageView *imageView = nil;

    UIView *wrapperView = [[UIView alloc] init];
    wrapperView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    wrapperView.layer.cornerRadius = ToastCornerRadius;

    if (ToastDisplayShadow) {
        wrapperView.layer.shadowColor = [UIColor blackColor].CGColor;
        wrapperView.layer.shadowOpacity = ToastShadowOpacity;
        wrapperView.layer.shadowRadius = ToastCornerRadius;
        wrapperView.layer.shadowOffset = ToastShadowOffset;
    }
    wrapperView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:ToastOpacity];
    if (image != nil) {
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(ToastHorizontalPadding, ToastVerticalPadding, ToastImageViewWidth, ToastImageViewHeight);
    }
    CGFloat imageWidth, imageHeight, imageLeft;
    if (imageView != nil) {
        imageWidth = imageView.bounds.size.width;
        imageHeight = imageView.bounds.size.height;
        imageLeft = ToastHorizontalPadding;
    } else {
        imageWidth = imageHeight = imageLeft = 0.0;
    }
    if (title != nil) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = ToastMaxTitleLines;
        titleLabel.font = [UIFont boldSystemFontOfSize:ToastFontSize];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.alpha = 1.0;
        titleLabel.text = title;

        CGSize maxsizeTitle = CGSizeMake(self.bounds.size.width * ToastMaxWidth - imageWidth, self.bounds.size.height * ToastMaxHeight);
        CGSize expectedSizeTitle = [self sizeForString:title font:titleLabel.font constrainedToSize:maxsizeTitle lineBreakMode:titleLabel.lineBreakMode];
        titleLabel.frame = CGRectMake(0.0, 0.0, expectedSizeTitle.width, expectedSizeTitle.height);
    }
    if (message != nil) {
        messageLabel = [[UILabel alloc] init];
        messageLabel.numberOfLines = ToastMaxMessageLines;
        messageLabel.font = [UIFont systemFontOfSize:ToastFontSize];
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.alpha = 1.0;
        messageLabel.text = message;

        CGSize maxSizeMessage = CGSizeMake(self.bounds.size.width * ToastMaxWidth - imageWidth, self.bounds.size.height * ToastMaxHeight);
        CGSize expectedSizeMessage = [self sizeForString:message font:messageLabel.font constrainedToSize:maxSizeMessage lineBreakMode:messageLabel.lineBreakMode];
        messageLabel.frame = CGRectMake(0.0, 0.0, expectedSizeMessage.width, expectedSizeMessage.height);
    }
    CGFloat titleWidth, titleHeight, titleTop, titleLeft;
    if (titleLabel != nil) {
        titleWidth = titleLabel.bounds.size.width;
        titleHeight = titleLabel.bounds.size.height;
        titleTop = ToastVerticalPadding;
        titleLeft = imageLeft + imageWidth + ToastHorizontalPadding;
    } else {
        titleWidth = titleHeight = titleTop = titleLeft = 0.0;
    }
    // messageLabel frame values
    CGFloat messageWidth, messageHeight, messageLeft, messageTop;

    if(messageLabel != nil) {
        messageWidth = messageLabel.bounds.size.width;
        messageHeight = messageLabel.bounds.size.height;
        messageLeft = imageLeft + imageWidth + ToastHorizontalPadding;
        messageTop = titleTop + titleHeight + ToastVerticalPadding;
    } else {
        messageWidth = messageHeight = messageLeft = messageTop = 0.0;
    }

    CGFloat longerWidth = MAX(titleWidth, messageWidth);
    CGFloat longerLeft = MAX(titleLeft, messageLeft);

    CGFloat wrapperWidth = MAX((imageWidth + (ToastHorizontalPadding * 2)), (longerLeft + longerWidth + ToastHorizontalPadding));
    CGFloat wrapperHeight = MAX((messageTop + messageHeight + ToastVerticalPadding), (imageHeight + (ToastVerticalPadding * 2)));
    wrapperView.frame = CGRectMake(0.0, 0.0, wrapperWidth, wrapperHeight);

    if (titleLabel != nil) {
        titleLabel.frame = CGRectMake(titleLeft, titleTop, titleWidth, titleHeight);
        [wrapperView addSubview:titleLabel];
    }
    if (messageLabel != nil) {
        messageLabel.frame = CGRectMake(messageLeft, messageTop, messageWidth, messageHeight);
        [wrapperView addSubview:messageLabel];
    }
    if (imageView != nil) {
        [wrapperView addSubview:imageView];
    }
    return wrapperView;
}

@end
