//
//  MainNavigationController.m
//  OC_APP
//
//  Created by xingl on 2017/6/7.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "MainNavigationController.h"

@interface MainNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation MainNavigationController


#pragma mark - life
//APP生命周期中 只会执行一次
+ (void)initialize {
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    [navBar setTintColor:[UIColor whiteColor]];
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName: [UIFont systemFontOfSize:18]}];
    
    [navBar setBackgroundImage:[UIImage xl_imageWithColor:THEME_CLOLR] forBarMetrics:UIBarMetricsDefault];
    
    navBar.shadowImage = [[UIImage alloc] init];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
//    if (animated) {
//        CATransition *animation = [CATransition animation];
//        //动画时间
//        animation.duration = 1.0f;
//        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        //过渡效果
//        animation.type = @"cube";
//        //过渡方向
//        animation.subtype = kCATransitionFromRight;
//        [self.view.layer addAnimation:animation forKey:nil];
//    }
    
    [super pushViewController:viewController animated:animated];
    
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
//    if (animated) {
//        CATransition *animation = [CATransition animation];
//        //动画时间
//        animation.duration = 1.0f;
//        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        //过渡效果
//        animation.type = @"cube";
//        //过渡方向
//        animation.subtype = kCATransitionFromLeft;
//        [self.view.layer addAnimation:animation forKey:nil];
//    }
    
    return [super popViewControllerAnimated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = (id)self;
    self.delegate = self;
}
#pragma mark - <UIGestureRecognizerDelegate>
/**
 * 每当用户触发[返回手势]时都会调用一次这个方法
 * 返回值:返回YES,手势有效; 返回NO,手势失效
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 如果当前显示的是第一个子控制器,就应该禁止掉[返回手势]
    //    if (self.childViewControllers.count == 1) return NO;
    //    return YES;
    return self.childViewControllers.count > 1; // 处理后，就不会出现黑边效果的bug了。
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -------- Navigation delegate
//该方法可以解决popRootViewController时tabbar的bug
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    //删除系统自带的tabBarButton
//    for (UIView *tabBar in self.tabBarController.tabBar.subviews) {
//        if ([tabBar isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
//            [tabBar removeFromSuperview];
//        }
//    }
//}

#pragma mark - StatusBar
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}

#pragma mark -Autorotate
- (BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}
@end
