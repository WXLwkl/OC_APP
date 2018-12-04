//
//  AppDelegate+AppService.m
//  OC_APP
//
//  Created by xingl on 2017/6/8.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "AppDelegate+AppService.h"
#import "AppManager.h"
#import <WRNavigationBar.h>

#import "XLRouter.h"

@implementation AppDelegate (AppService)

+ (AppDelegate *)shareAppDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)initWindowWithGuideOrAD {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = [XLRouter getControllerFromClassName:@"MainTabBarController"];

//    [AppManager appStartWithMainViewController:mainTabBar guideImages:@[@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg"]];

//    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil]];

    [self.window makeKeyAndVisible];
    [self setNavBarAppearence];
}



- (void)setNavBarAppearence {
    //    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor purpleColor]}];
    //    [UINavigationBar appearance].tintColor = [UIColor yellowColor];
    //    [UINavigationBar appearance].barTintColor = [UIColor redColor];
    
    // 设置是 广泛使用WRNavigationBar，还是局部使用WRNavigationBar，目前默认是广泛使用
    [WRNavigationBar wr_widely];
    [WRNavigationBar wr_setBlacklist:@[@"SpecialController",
                                       @"TZPhotoPickerController",
                                       @"TZGifPhotoPreviewController",
                                       @"TZAlbumPickerController",
                                       @"TZPhotoPreviewController",
                                       @"TZVideoPlayerController"]];
    
    // 设置导航栏默认的背景颜色
    [WRNavigationBar wr_setDefaultNavBarBarTintColor:THEME_color];
    // 设置导航栏所有按钮的默认颜色
    [WRNavigationBar wr_setDefaultNavBarTintColor:[UIColor whiteColor]];
    // 设置导航栏标题默认颜色
    [WRNavigationBar wr_setDefaultNavBarTitleColor:[UIColor whiteColor]];
    // 统一设置状态栏样式
    [WRNavigationBar wr_setDefaultStatusBarStyle:UIStatusBarStyleLightContent];
    // 如果需要设置导航栏底部分割线隐藏，可以在这里统一设置
    [WRNavigationBar wr_setDefaultNavBarShadowImageHidden:YES];
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
