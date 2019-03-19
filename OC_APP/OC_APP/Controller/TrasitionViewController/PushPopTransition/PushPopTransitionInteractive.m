//
//  PushPopTransitionInteractive.m
//  OC_APP
//
//  Created by xingl on 2019/3/7.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "PushPopTransitionInteractive.h"

@implementation PushPopTransitionInteractive

- (void)addPanGestureForViewController:(UIViewController *)viewController {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    self.vc = viewController;
    [viewController.view addGestureRecognizer:pan];
}

- (void)handleGesture:(UIPanGestureRecognizer *)gesture {
    switch (_interactiveType) {
        case PushPopInteractiveTypePush:
            [self pushInteractive:gesture];
            break;
        case PushPopInteractiveTypePop:
            [self popInteractive:gesture];
            break;
    }
}

- (void)pushInteractive:(UIPanGestureRecognizer *)panGesture {
    
}

- (void)popInteractive:(UIPanGestureRecognizer *)panGesture {
    CGPoint translation = [panGesture translationInView:panGesture.view];
    CGFloat percentComplete = 0.0;
    
    percentComplete = translation.x / (panGesture.view.frame.size.width);
    percentComplete = fabs(percentComplete);
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            _isInteractive = YES;
            [_vc.navigationController popViewControllerAnimated:YES];
            break;
        case UIGestureRecognizerStateChanged:
            [self updateInteractiveTransition:percentComplete];
            break;
        case UIGestureRecognizerStateEnded: {
            _isInteractive = NO;
            if (percentComplete > 0.5) {
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
