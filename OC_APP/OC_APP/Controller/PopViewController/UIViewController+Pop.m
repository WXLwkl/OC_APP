//
//  UIViewController+Pop.m
//  OC_APP
//
//  Created by xingl on 2018/6/5.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "UIViewController+Pop.h"
#import "PresentBottomController.h"

@implementation UIViewController (Pop)

static const char ControllerHeight = '\0';
- (void)setControllerHeight:(CGFloat)controllerHeight {
    objc_setAssociatedObject(self, &ControllerHeight, @(controllerHeight), OBJC_ASSOCIATION_ASSIGN);
}
- (CGFloat)controllerHeight {
    return [objc_getAssociatedObject(self, &ControllerHeight) floatValue];
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return [[PresentBottomController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

- (void)modal:(UIViewController *)vc controllerHeight:(CGFloat)controllerHeight {
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.controllerHeight = controllerHeight;
    vc.transitioningDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}


@end
