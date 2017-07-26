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
#import "MessageViewController.h"
#import "SubscriptionViewController.h"

#import "WriteViewController.h"


@interface MainTabBarController ()<MainTabBarDelegate>

@property (nonatomic, weak) MainTabBar *mainTabBar;

@end

@implementation MainTabBarController

#pragma mark - life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self SetupMainTabBar];
    [self SetupAllControllers];
//    self.selectedIndex = 1;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ————— 选中某个tab —————
- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    
    [super setSelectedIndex:selectedIndex];
    
    self.mainTabBar.selectedButton.selected = NO;
    self.mainTabBar.selectedButton = self.mainTabBar.tabBarItems[selectedIndex];
    self.mainTabBar.selectedButton.selected = YES;
}
#pragma mark - custom
- (void)SetupMainTabBar {
    MainTabBar *tabBar = [[MainTabBar alloc] init];
    tabBar.frame = self.tabBar.bounds;
    tabBar.delegate = self;
    [self.tabBar addSubview:tabBar];
    _mainTabBar = tabBar;
}

- (void)SetupAllControllers {
    NSArray *title = @[@"发现", @"关注", @"消息", @"我的"];
    NSArray *images = @[@"icon_tabbar_home~iphone", @"icon_tabbar_subscription~iphone", @"icon_tabbar_notification~iphone", @"icon_tabbar_me~iphone"];
    NSArray *selectedImages = @[@"icon_tabbar_home_active~iphone", @"icon_tabbar_subscription_active~iphone", @"icon_tabbar_notification_active~iphone", @"icon_tabbar_me_active~iphone"];
    
    
    HomeViewController * homeVC = [[HomeViewController alloc] init];
 
    SubscriptionViewController * subscriptionVC = [[SubscriptionViewController alloc] init];

    MessageViewController * messageVC = [[MessageViewController alloc] init];

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
    [self.mainTabBar addTabBarButtonWithTabBarItem:childVC.tabBarItem];
    [self addChildViewController:nav];
}


- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.selectedViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.selectedViewController;
}



#pragma mark - MainTabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectedButtonFrom:(long)fromBtnTag to:(long)toBtnTag {
    
    self.selectedIndex = toBtnTag;
}

- (void)tabBarClickWriteButton:(MainTabBar *)tabBar {
    
    WriteViewController *writeVc = [[WriteViewController alloc] init];
    MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:writeVc];
    [self presentViewController:nav animated:YES completion:^{
        writeVc.title = @"写文章";
    }];
}
@end
