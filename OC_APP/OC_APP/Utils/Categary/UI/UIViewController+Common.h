//
//  UIViewController+Common.h
//  OC_APP
//
//  Created by xingl on 2017/8/1.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Common)


- (void)xl_setNavBackItem;

- (void)xl_setNavBackItemWithImage:(NSString *)imageName;

- (void)xl_setLeftBarButtonItemWithTitle:(NSString *)title action:(void(^)())block;

- (void)xl_closeSelfAction;


- (UINavigationController *)xl_navigationController;

/** 获得最前端的视图控制器 */
+ (UIViewController *)xl_currentViewController;
/** 获取最前端的 UINavigationController */
+ (UINavigationController *)xl_currentNavigatonController;



@end
