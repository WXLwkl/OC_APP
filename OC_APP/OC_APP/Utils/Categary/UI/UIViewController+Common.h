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

@end
