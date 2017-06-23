//
//  BannerScrollView.h
//  无限轮播Demo
//
//  Created by xingl on 16/7/25.
//  Copyright © 2016年 yjpal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UIPageControlShowStyle) {
    UIPageControlShowStyleNone,//default
    UIPageControlShowStyleLeft,
    UIPageControlShowStyleCenter,
    UIPageControlShowStyleRight,
};


//typedef void(^openURLBlock)(NSString *);

@interface BannerScrollView : UIScrollView

@property (assign,nonatomic,readwrite) UIPageControlShowStyle  PageControlShowStyle;
//@property (nonatomic, copy) openURLBlock block;


@property (nonatomic, copy) void (^openURLBlock)(NSString *keyWord);

@end
