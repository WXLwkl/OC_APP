//
//  PushPopTransitionInteractive.h
//  OC_APP
//
//  Created by xingl on 2019/3/7.
//  Copyright © 2019 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PushPopInteractiveType) {
    PushPopInteractiveTypePush,
    PushPopInteractiveTypePop
};

@interface PushPopTransitionInteractive : UIPercentDrivenInteractiveTransition

@property (nonatomic,   weak) UIViewController *vc;
@property (nonatomic, assign) BOOL isInteractive;

@property (nonatomic, assign) PushPopInteractiveType interactiveType;

- (void)addPanGestureForViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
