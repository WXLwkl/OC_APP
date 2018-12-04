//
//  XLRouter.m
//  OC_APP
//
//  Created by xingl on 2018/11/29.
//  Copyright © 2018 兴林. All rights reserved.
//


NSString * const kRouterSchemePresent = @"kRouterSchemePresent";
NSString * const kRouterSchemePush    = @"kRouterSchemePush";

#import "XLRouter.h"

@implementation XLRouter

#pragma mark - out
+ (UIViewController *)openUrl:(NSString *)urlString {
    
    NSURL *url = [NSURL URLWithString:urlString];
    return [XLRouter openURL:url query:nil];
}

+ (UIViewController *)openUrl:(NSString *)urlString query:(NSDictionary *)query {
    NSURL *url = [NSURL URLWithString:urlString];
    return [XLRouter openURL:url query:query];
}

+ (UIViewController *)openURL:(NSURL *)URL query:(NSDictionary *)query {
    
    if (!URL || ![URL isKindOfClass:[NSURL class]]) return nil;
    
    NSString *scheme = URL.scheme;
    NSLog(@"scheme=%@", scheme);
    
    UIViewController *vc = [XLRouter getControllerFromURL:URL query:query];
    if (!vc) return nil;
    
    [XLRouter displayStyle:scheme viewController:vc];
    
    return vc;
}

//通过类名获取控制器
+ (UIViewController *)getControllerFromClassName:(NSString *)controllerName {

    const char * name = [controllerName cStringUsingEncoding:NSASCIIStringEncoding];
    // 从一个类名返回一个类
    Class newClass = objc_getClass(name);
    // 创建对象
    if (newClass == nil) return nil;
    return [[newClass alloc] init];
}


#pragma mark - private
//通过URL获取控制器
+ (UIViewController *)getControllerFromURL:(NSURL *)URL query:(NSDictionary *)query {
    
    if (!URL || ![URL isKindOfClass:[NSURL class]]) return nil;
    
    UIViewController *viewController = [UIViewController initFromString:URL.absoluteString withQuery:query];
    return viewController;
}

+ (void)displayStyle:(NSString *)style viewController:(UIViewController *)controller{
    UIViewController *currentVC = [XLRouter getCurrentVC];
    if (currentVC.class != controller.class) {
        
        if ([style isEqualToString:kRouterSchemePresent]) {
            [XLRouter presentWith:controller];
        } else {
            [XLRouter pushWith:controller];
        }
    }
}
// 导航推出控制器
+ (void)pushWith:(UIViewController *)controller {
    UINavigationController *nav = [XLRouter getCurrentVC].navigationController;
    controller.hidesBottomBarWhenPushed = YES;
    if (nav) {
        [nav pushViewController:controller animated:YES];
    }
}
// 模态弹出控制器
+ (void)presentWith:(UIViewController *)controller {
    UIViewController *vc = [XLRouter getCurrentVC];
    if (vc.class != controller.class) {
        [vc presentViewController:controller animated:YES completion:nil];
    }
}

/** 获取当前vc */
+ (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tmpWindow in windows) {
            if (tmpWindow.windowLevel == UIWindowLevelNormal) {
                window = tmpWindow;
                break;
            }
        }
    }
    id nextResponder = nil;
    UIViewController *appRootVC = window.rootViewController;
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    } else {
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    if ([nextResponder isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabbar = (UITabBarController *)nextResponder;
        UINavigationController *nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
//        UINavigationController *nav = tabbar.selectedViewController;
        result = nav.childViewControllers.lastObject;
    } else if ([nextResponder isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    } else {
        result = nextResponder;
    }
    return result;
}

@end
