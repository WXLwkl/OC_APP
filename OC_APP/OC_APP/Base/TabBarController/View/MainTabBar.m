//
//  MainTabBar.m
//  OC_APP
//
//  Created by xingl on 2017/6/7.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "MainTabBar.h"

@interface MainTabBar ()

@property (nonatomic, weak) UIButton *centerBtn;

@end

@implementation MainTabBar

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

    CGFloat add = self.items.count;

    CGFloat itemW = self.frame.size.width/(add + 1);

    NSInteger itemCurrent = 0;

    for (UIControl *button in self.subviews) {  // 遍历UITabBar中的所有子控件进行布局

        if (![button isKindOfClass:NSClassFromString(@"UITabBarButton")])
            continue;

        if (itemCurrent == 2) {
            itemCurrent = 3;
        }
        button.xl_x = itemCurrent * itemW;
        button.xl_width = itemW;
        itemCurrent ++;
    }

    self.centerBtn.xl_centerX = self.xl_centerX;

}
- (void)SetupWriteButton {

//    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, -1, self.bounds.size.width, 1)];
//    topLine.backgroundColor = [UIColor lightGrayColor];
//    [self addSubview:topLine];

    UIButton *writeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [writeBtn setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
    [writeBtn setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateSelected];
    [writeBtn addTarget:self action:@selector(writeButtonClick) forControlEvents:UIControlEventTouchDown];
    writeBtn.xl_size = writeBtn.currentBackgroundImage.size;
    [self addSubview:writeBtn];
    self.centerBtn = writeBtn;
}

//特殊按钮点击方法
- (void)writeButtonClick {
    if ([self.delegateTab respondsToSelector:@selector(tabBarClickWriteButton:)]) {

        [self.delegateTab tabBarClickWriteButton:self];
    }
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.isHidden == NO) {

        CGPoint newP = [self convertPoint:point toView:self.centerBtn];

        if ([self.centerBtn pointInside:newP withEvent:event]) {
            return self.centerBtn;
        }
    }
    return [super hitTest:point withEvent:event];
}

@end

