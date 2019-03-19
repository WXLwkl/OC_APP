//
//  TBInteractiveModel.m
//  OC_APP
//
//  Created by xingl on 2019/3/4.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "TBInteractiveModel.h"

@interface TBInteractiveModel()

@property (nonatomic, weak) UITabBarController *tabBar;

@end

@implementation TBInteractiveModel

- (instancetype)initWithGesture:(UITabBarController *)tabBar {
    self = [super init];
    if (self) {
        _tabBar = tabBar;
        [self addGesture:tabBar.view];
    }
    return self;
}

- (void)addGesture:(UIView *)view {
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [view addGestureRecognizer:recognizer];
}

- (void)pan:(UIPanGestureRecognizer *)gesture {
    CGPoint newPoint = [gesture translationInView:gesture.view];
    CGFloat progress = fabs(newPoint.x) / CGRectGetWidth(gesture.view.bounds);
    progress = MIN(1, MAX(0, progress));
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
            _interation = YES;
            if (newPoint.x > 0 && self.tabBar.selectedIndex > 0) {
                self.tabBar.selectedIndex--;
            } else if (newPoint.x < 0 && self.tabBar.selectedIndex < self.tabBar.viewControllers.count) {
                self.tabBar.selectedIndex++;
            }
        }
            break;
        case UIGestureRecognizerStateChanged: {
            [self updateInteractiveTransition:progress];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            _interation = NO;
            if (progress > 0.4) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
        }
            break;
        default:
            break;
    }
}

@end
