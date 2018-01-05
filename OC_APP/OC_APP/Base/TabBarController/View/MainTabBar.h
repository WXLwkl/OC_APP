//
//  MainTabBar.h
//  OC_APP
//
//  Created by xingl on 2017/6/7.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainTabBar;


@protocol MainTabBarDelegate <NSObject>

@optional
- (void)tabBarClickWriteButton:(MainTabBar *)tabBar;
@end


@interface MainTabBar : UITabBar

@property (nonatomic, weak) id<MainTabBarDelegate> delegateTab;

@end
