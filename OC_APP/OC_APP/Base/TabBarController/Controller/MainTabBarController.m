//
//  MainTabBarController.m
//  OC_APP
//
//  Created by xingl on 2017/6/7.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "MainTabBarController.h"

#import "MainNavigationController.h"
#import "MainTabBar.h"

#import "HomeViewController.h"
#import "MeViewController.h"
#import "ContactsViewController.h"
#import "SubscriptionViewController.h"

#import "WriteViewController.h"


@interface MainTabBarController ()<MainTabBarDelegate>

@property (nonatomic, strong) NSDate *lastDate;
@property (nonatomic, weak) MainTabBar *mainTabBar;

@end

@implementation MainTabBarController

#pragma mark - life
- (void)viewDidLoad {
    [super viewDidLoad];

    // 通过appearance统一设置UITabbarItem的文字属性
    NSMutableDictionary * attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12.0];  // 设置文字大小
    attrs[NSForegroundColorAttributeName] = RGBColor(117, 117, 117);  // 设置文字的前景色

    NSMutableDictionary * selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = THEME_color; //RGBColor(205, 89, 75)

    UITabBarItem * item = [UITabBarItem appearance];  // 设置appearance
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];

    [self SetupMainTabBar];
    [self SetupAllControllers];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom
- (void)SetupMainTabBar {

    MainTabBar *tabBar = [[MainTabBar alloc] init];
    tabBar.tintColor = RGBColor(0, 186, 255);
    tabBar.delegateTab = self;
    // 更换tabbar
    [self setValue:tabBar forKey:@"tabBar"];
}

#pragma mark - MainTabBarDelegate
- (void)tabBarClickWriteButton:(MainTabBar *)tabBar {

    WriteViewController *writeVc = [[WriteViewController alloc] init];
    MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:writeVc];
    [self presentViewController:nav animated:YES completion:^{
        writeVc.title = @"写文章";
    }];
}

- (void)SetupAllControllers {
    NSArray *title = @[@"发现", @"关注", @"联系人", @"我的"];
    NSArray *images = @[@"icon_tabbar_home~iphone", @"icon_tabbar_subscription~iphone", @"icon_tabbar_notification~iphone", @"icon_tabbar_me~iphone"];
    NSArray *selectedImages = @[@"icon_tabbar_home_active~iphone", @"icon_tabbar_subscription_active~iphone", @"icon_tabbar_notification_active~iphone", @"icon_tabbar_me_active~iphone"];
    
    HomeViewController * homeVC = [[HomeViewController alloc] init];
 
    SubscriptionViewController * subscriptionVC = [[SubscriptionViewController alloc] init];

    ContactsViewController * messageVC = [[ContactsViewController alloc] init];

    MeViewController * meVC = [[MeViewController alloc] init];

    NSArray *viewControllers = @[homeVC, subscriptionVC, messageVC, meVC];
    for (int i = 0; i < viewControllers.count; i++) {
        UIViewController *childVC = viewControllers[i];
        [self setupChildVC:childVC title:title[i] image:images[i] selectedImage:selectedImages[i]];
    }
}
- (void)setupChildVC:(UIViewController *)childVC title:(NSString *)title image:(NSString *)imageName selectedImage:(NSString *)selectedImageName {
    MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:childVC];
    childVC.tabBarItem.title = title;
    childVC.tabBarItem.image = [UIImage imageNamed:imageName];
    childVC.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    [self addChildViewController:nav];
}

#pragma mark - StatusBar
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.selectedViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.selectedViewController;
}
#pragma mark - Autorotate
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.selectedViewController.supportedInterfaceOrientations;
}

- (BOOL)shouldAutorotate {
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}
@end
