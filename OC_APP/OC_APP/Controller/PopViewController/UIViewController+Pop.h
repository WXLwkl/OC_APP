//
//  UIViewController+Pop.h
//  OC_APP
//
//  Created by xingl on 2018/6/5.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Pop) <UIViewControllerTransitioningDelegate>

/** 控制器高度 */
@property (assign, nonatomic) CGFloat controllerHeight;

- (void)modal:(UIViewController *)vc controllerHeight:(CGFloat)controllerHeight;

@end
