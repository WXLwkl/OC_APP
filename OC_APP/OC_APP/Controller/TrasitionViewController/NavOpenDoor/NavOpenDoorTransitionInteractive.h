//
//  NavOpenDoorTransitionInteractive.h
//  OC_APP
//
//  Created by xingl on 2019/3/7.
//  Copyright © 2019 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, NavOpenDoorInteractiveType) {
    NavOpenDoorInteractiveTypePush,
    NavOpenDoorInteractiveTypePop
};

@interface NavOpenDoorTransitionInteractive : UIPercentDrivenInteractiveTransition

@property (nonatomic,   weak) UIViewController *vc;
@property (nonatomic, assign) BOOL isInteractive;

@property (nonatomic, assign) NavOpenDoorInteractiveType interactiveType;

- (void)addPanGestureForViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
