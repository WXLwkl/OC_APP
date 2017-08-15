//
//  MainTabBar.m
//  OC_APP
//
//  Created by xingl on 2017/6/7.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "MainTabBar.h"

@interface MainTabBar ()

@property (nonatomic, weak) UIButton *writeButton;

@end

@implementation MainTabBar

- (NSMutableArray *)tabBarItems {
    if (!_tabBarItems) {
        _tabBarItems = [NSMutableArray array];
    }
    return _tabBarItems;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self SetupWriteButton];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.writeButton.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    CGFloat btnY = 0;
    CGFloat btnW = self.frame.size.width / self.subviews.count;
    CGFloat btnH = self.frame.size.height;
    
    for (int nIndex = 0; nIndex < self.tabBarItems.count; nIndex++) {
        CGFloat btnX = btnW * nIndex;
        TabBarItem *tabBarBtn = self.tabBarItems[nIndex];
        if (nIndex > 1) {
            btnX += btnW;
        }
        tabBarBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        tabBarBtn.tag = nIndex;
    }
}
- (void)SetupWriteButton {
    UIButton *writeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [writeBtn setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
    [writeBtn setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateSelected];
    [writeBtn addTarget:self action:@selector(writeButtonClick) forControlEvents:UIControlEventTouchDown];
    writeBtn.bounds = CGRectMake(0, 0, writeBtn.currentBackgroundImage.size.width, writeBtn.currentBackgroundImage.size.height);
    [self addSubview:writeBtn];
    _writeButton = writeBtn;
}
//添加按钮
- (void)addTabBarButtonWithTabBarItem:(UITabBarItem *)tabBarItem {
    TabBarItem *tabBarBtn = [[TabBarItem alloc] init];
    tabBarBtn.tabBarItem = tabBarItem;
    [tabBarBtn addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:tabBarBtn];
    [self.tabBarItems addObject:tabBarBtn];
    //默认第一个输入选中
    if (self.tabBarItems.count == 1) {
        [self tabBarButtonClick:tabBarBtn];
    }
}
//按钮点击方法
- (void)tabBarButtonClick:(TabBarItem *)tabBarBtn {
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectedButtonFrom:self.selectedButton.tag to:tabBarBtn.tag];
    }
    self.selectedButton.selected = NO;
    tabBarBtn.selected = YES;
    self.selectedButton = tabBarBtn;
}
//特殊按钮点击方法
- (void)writeButtonClick {
    if ([self.delegate respondsToSelector:@selector(tabBarClickWriteButton:)]) {
        [self.delegate tabBarClickWriteButton:self];
    }
}
@end
