//
//  XLInteractiveTransition.m
//  OC_APP
//
//  Created by xingl on 2019/3/1.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "XLInteractiveTransition.h"

@interface XLInteractiveTransition ()

/**
 保存添加手势的view
 */
@property (nonatomic,strong) UIView *gestureView;

/**
 屏幕侧滑手势
 */
@property (nonatomic,strong) UIScreenEdgePanGestureRecognizer *panGesture;


//@property (nonatomic, weak) UIViewController *vc;
//
///**手势方向*/
//@property (nonatomic, assign) XLInteractiveTransitionGestureDirection direction;
///**手势类型*/
//@property (nonatomic, assign) XLInteractiveTransitionType type;

@end

@implementation XLInteractiveTransition

- (void)addEdgePageGestureWithView:(UIView *)view direction:(XLInteractiveTransitionGestureDirection)direction {
    UIScreenEdgePanGestureRecognizer *recognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRecognizer:)];
    switch (direction) {
        case XLInteractiveTransitionGestureDirectionLeft:
            recognizer.edges = UIRectEdgeLeft;
            break;
        case XLInteractiveTransitionGestureDirectionRight:
            recognizer.edges = UIRectEdgeRight;
            break;
        case XLInteractiveTransitionGestureDirectionUp:
            recognizer.edges = UIRectEdgeTop;
            break;
        case XLInteractiveTransitionGestureDirectionDown:
            recognizer.edges = UIRectEdgeBottom;
            break;
        default:
            break;
    }
    self.gestureView = view;
    [self.gestureView addGestureRecognizer:recognizer];
}

- (void)handleRecognizer:(UIPanGestureRecognizer*)recognizer {
    CGFloat progress = fabs([recognizer translationInView:self.gestureView].x) / (self.gestureView.bounds.size.width * 1.0);
    progress = MIN(1.0, MAX(0.0, progress));
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{
            self.isPanGestureInteration = YES;
            if (self.eventBlcok) {
                self.eventBlcok();
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
            [self updateInteractiveTransition:progress];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            self.isPanGestureInteration = NO;
            if (progress > 0.5) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
        }
        default:
            break;
    }
}


//
//+ (instancetype)interactiveTransitionWithTransitionType:(XLInteractiveTransitionType)type gestureDirection:(XLInteractiveTransitionGestureDirection)direction {
//    return [[self alloc] initWithTransitionType:type gestureDirection:direction];
//}
//
//- (instancetype)initWithTransitionType:(XLInteractiveTransitionType)type gestureDirection:(XLInteractiveTransitionGestureDirection)direction {
//    self = [super init];
//    if (self) {
//        _type = type;
//        _direction = direction;
//    }
//    return self;
//}
//
//- (void)addPanGestureForViewController:(UIViewController *)viewController {
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
//    self.vc = viewController;
//    [viewController.view addGestureRecognizer:pan];
//}
///** 手势过渡过程 */
//- (void)handleGesture:(UIPanGestureRecognizer *)panGesture {
//    CGFloat persent = 0;
//
//    switch (_direction) {
//        case XLInteractiveTransitionGestureDirectionLeft: {
//            CGFloat transitionX = - [panGesture translationInView:panGesture.view].x;
//            persent = transitionX / panGesture.view.frame.size.width;
//        }
//            break;
//        case XLInteractiveTransitionGestureDirectionRight: {
//            CGFloat transitionX = [panGesture translationInView:panGesture.view].x;
//            persent = transitionX / panGesture.view.frame.size.width;
//        }
//            break;
//        case XLInteractiveTransitionGestureDirectionUp: {
//            CGFloat transitionY = -[panGesture translationInView:panGesture.view].y;
//            persent = transitionY / panGesture.view.frame.size.width;
//        }
//            break;
//        case XLInteractiveTransitionGestureDirectionDown: {
//            CGFloat transitionY = [panGesture translationInView:panGesture.view].y;
//            persent = transitionY / panGesture.view.frame.size.width;
//        }
//            break;
//    }
//
//    switch (panGesture.state) {
//        case UIGestureRecognizerStateBegan: {
//            self.interation = true;
//            [self startGesture];
//        }
//            break;
//        case UIGestureRecognizerStateChanged:
//            [self updateInteractiveTransition:persent];
//            break;
//        case UIGestureRecognizerStateEnded: {
//            self.interation = false;
//            if (persent > 0.5) {
//                [self finishInteractiveTransition];
//            } else {
//                [self cancelInteractiveTransition];
//            }
//        }
//            break;
//        default:
//            break;
//    }
//}
//
//- (void)startGesture {
//    switch (_type) {
//        case XLInteractiveTransitionTypePresent: {
//            if (_presentConfig) {
//                _presentConfig();
//            }
//        }
//            break;
//        case XLInteractiveTransitionTypeDismiss:
//            [_vc dismissViewControllerAnimated:YES completion:nil];
//            break;
//        case XLInteractiveTransitionTypePush:{
//            if (_pushConfig) {
//                _pushConfig();
//            }
//        }
//            break;
//        case XLInteractiveTransitionTypePop:
//            [_vc.navigationController popViewControllerAnimated:YES];
//            break;
//    }
//}

@end
