//
//  PopTransitionInteractive.m
//  OC_APP
//
//  Created by xingl on 2019/3/8.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "PopTransitionInteractive.h"

@implementation PopTransitionInteractive

//给控制器的View添加相应的手势
- (void)addPanGestureForViewController:(UIViewController *)viewController{
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    self.vc = viewController;
    [viewController.view addGestureRecognizer:pan];
}
//关键的手势过渡的过程
- (void)handleGesture:(UIPanGestureRecognizer *)panGesture{
    CGFloat percentComplete = 0.0;
    if (_interactiveType == PopInteractiveTypePresent) {
        CGFloat translationY = -[panGesture translationInView:panGesture.view].y;
        percentComplete = translationY / panGesture.view.frame.size.width;
    } else {
        CGFloat translationY = [panGesture translationInView:panGesture.view].y;
        percentComplete = translationY / panGesture.view.frame.size.width;
    }
    NSLog(@"percentComplete=%.2f", percentComplete);
    
    switch (panGesture.state) {
            case UIGestureRecognizerStateBegan: {
                self.isInteractive = YES;
                if (_interactiveType == PopInteractiveTypeDismiss) {
                    [_vc dismissViewControllerAnimated:YES completion:nil];
                } else {
                    if (_presentConifg) {
                        _presentConifg();
                    }
                }
            }
            break;
            case UIGestureRecognizerStateChanged:
            [self updateInteractiveTransition:percentComplete];
            break;
            case UIGestureRecognizerStateEnded:{
                self.isInteractive = NO;
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
