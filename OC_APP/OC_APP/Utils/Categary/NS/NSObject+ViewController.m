//
//  NSObject+ViewController.m
//  OC_APP
//
//  Created by xingl on 2017/7/6.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "NSObject+ViewController.h"

@implementation NSObject (ViewController)


- (UIViewController *)xl_viewController {
    
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    //model
    if (vc.presentedViewController) {
        if ([vc.presentedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navVc = (UINavigationController *)vc.presentedViewController;
            vc = navVc.visibleViewController;
        } else if ([vc.presentedViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabBarCon = (UITabBarController *)vc.presentedViewController;
            if ([tabBarCon.selectedViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *nav = (UINavigationController *)tabBarCon.selectedViewController;
                return nav.visibleViewController;
            } else {
                return tabBarCon.selectedViewController;
            }
        } else {
            vc = vc.presentedViewController;
        }
    } else { //push
        if ([vc isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabBarCon = (UITabBarController *)vc;
            if ([tabBarCon.selectedViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *nav = (UINavigationController *)tabBarCon.selectedViewController;
                return nav.visibleViewController;
            } else {
                return tabBarCon.selectedViewController;
            }
        } else if ([vc isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)vc;
            vc = nav.visibleViewController;
        }
    }
    return vc;
}
@end
