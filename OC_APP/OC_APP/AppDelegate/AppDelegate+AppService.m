//
//  AppDelegate+AppService.m
//  OC_APP
//
//  Created by xingl on 2017/6/8.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "AppDelegate+AppService.h"
#import "AppManager.h"

@implementation AppDelegate (AppService)

+ (AppDelegate *)shareAppDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)initWindowWithGuideOrAD {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    MainTabBarController *mainTabBar = [MainTabBarController new];

    UIViewController *vc = [AppManager appStartWithMainViewController:mainTabBar guideImages:@[@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg"]];

    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
}

- (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    UIWindow *window = kKeyWindow;
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [kApplication windows];
        for (UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }
    
    return result;
}

- (UIViewController *)getCurrentUIVC {
    
    UIViewController *superVC = [self getCurrentVC];
    
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        UIViewController *tabSelectVC = ((UITabBarController *)superVC).selectedViewController;
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            return ((UINavigationController *)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    } else {
        if ([superVC isKindOfClass:[UINavigationController class]]) {
            return ((UINavigationController *)superVC).viewControllers.lastObject;
        }
    }
    return superVC;
}

@end
