//
//  XLInteractiveTransition.h
//  OC_APP
//
//  Created by xingl on 2019/3/1.
//  Copyright © 2019 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//typedef void(^GestureConfig)();
//
//typedef NS_ENUM(NSUInteger, XLInteractiveTransitionGestureDirection) {
//    XLInteractiveTransitionGestureDirectionLeft = 0,
//    XLInteractiveTransitionGestureDirectionRight,
//    XLInteractiveTransitionGestureDirectionUp,
//    XLInteractiveTransitionGestureDirectionDown
//};
//
//typedef NS_ENUM(NSUInteger, XLInteractiveTransitionType) {
//    XLInteractiveTransitionTypePresent = 0,
//    XLInteractiveTransitionTypeDismiss,
//    XLInteractiveTransitionTypePush,
//    XLInteractiveTransitionTypePop
//};


typedef NS_ENUM(NSUInteger, XLInteractiveTransitionGestureDirection) {
    XLInteractiveTransitionGestureDirectionLeft = 0,
    XLInteractiveTransitionGestureDirectionRight,
    XLInteractiveTransitionGestureDirectionUp,
    XLInteractiveTransitionGestureDirectionDown
};

///**
// 手势转场类型
//
// - GLInteractiveTransitionPush: push
// - GLInteractiveTransitionPop: pop
// - GLInteractiveTransitionPresent: present
// - GLInteractiveTransitionDismiss: dismiss
// */
//typedef NS_ENUM(NSInteger,GLInteractiveTransitionType) {
//    GLInteractiveTransitionPush = 0,
//    GLInteractiveTransitionPop,
//    GLInteractiveTransitionPresent ,
//    GLInteractiveTransitionDismiss
//};


@interface XLInteractiveTransition : UIPercentDrivenInteractiveTransition

/**
 是否满足侧滑手势交互
 */
@property (nonatomic,assign) BOOL isPanGestureInteration;


/**
 转场时的操作 不用传参数的block
 */
@property (nonatomic,copy) dispatch_block_t eventBlcok;

/**
 添加侧滑手势
 
 @param view 添加手势的view
 @param direction 手势的方向
 */
- (void)addEdgePageGestureWithView:(UIView *)view direction:(XLInteractiveTransitionGestureDirection)direction;


///** 是否手势交互，判断pop操作是手势触发 还是按钮返回 */
//@property (nonatomic, assign) BOOL interation;
///**促发手势present的时候的config，config中初始化并present需要弹出的控制器*/
//@property (nonatomic, copy) GestureConfig presentConfig;
///**促发手势push的时候的config，config中初始化并push需要弹出的控制器*/
//@property (nonatomic, copy) GestureConfig pushConfig;
//
//
//+ (instancetype)interactiveTransitionWithTransitionType:(XLInteractiveTransitionType)type gestureDirection:(XLInteractiveTransitionGestureDirection)direction;
//
//- (instancetype)initWithTransitionType:(XLInteractiveTransitionType)type gestureDirection:(XLInteractiveTransitionGestureDirection)direction;
//
//- (void)addPanGestureForViewController:(UIViewController *)viewController;



@end

NS_ASSUME_NONNULL_END
