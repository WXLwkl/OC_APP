//
//  MainTabBar.h
//  OC_APP
//
//  Created by xingl on 2017/6/7.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarItem.h"
@class MainTabBar;


@protocol MainTabBarDelegate <NSObject>

@optional
- (void)tabBar:(MainTabBar *)tabBar didSelectedButtonFrom:(long)fromBtnTag to:(long)toBtnTag;
- (void)tabBarClickWriteButton:(MainTabBar *)tabBar;
@end


@interface MainTabBar : UIView

@property (nonatomic, strong) NSMutableArray *tabBarItems;
@property (nonatomic, weak) TabBarItem *selectedButton;
@property (nonatomic, weak) id<MainTabBarDelegate> delegate;
- (void)addTabBarButtonWithTabBarItem:(UITabBarItem *)tabBarItem;

@end
