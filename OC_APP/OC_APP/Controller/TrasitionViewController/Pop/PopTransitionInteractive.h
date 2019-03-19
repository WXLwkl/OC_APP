//
//  PopTransitionInteractive.h
//  OC_APP
//
//  Created by xingl on 2019/3/8.
//  Copyright © 2019 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^GestureConifg)();

typedef NS_ENUM(NSUInteger, PopInteractiveType) {
    PopInteractiveTypePresent,
    PopInteractiveTypeDismiss
};
@interface PopTransitionInteractive : UIPercentDrivenInteractiveTransition

@property (nonatomic,   weak) UIViewController *vc;
@property (nonatomic, assign) BOOL isInteractive;

@property (nonatomic, copy) GestureConifg presentConifg;

@property (nonatomic, assign) PopInteractiveType interactiveType;

- (void)addPanGestureForViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
