//
//  BannerScrollView.h
//  无限轮播Demo
//
//  Created by xingl on 16/7/25.
//  Copyright © 2016年 yjpal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BannerScrollView;

@protocol BannerScrollViewDelegate <NSObject>

- (NSInteger)bannerScrollViewNumbersOfContents:(BannerScrollView *)imageScrollView;
- (void)bannerScrollView:(BannerScrollView *)imageScrollView
            imageAtIndex:(NSInteger)index
               imageView:(UIImageView *)imageView;
@optional
- (void)bannerScrollView:(BannerScrollView *)imageScrollView
     clickContentAtIndex:(NSInteger)index;

- (void)bannerScrollView:(BannerScrollView *)imageScrollView
            currentIndex:(NSInteger)currentIndex;
@end

//typedef void(^openURLBlock)(NSString *);

@interface BannerScrollView : UIView

//@property (nonatomic, copy) openURLBlock block;
//@property (nonatomic, copy) void (^openURLBlock)(NSString *keyWord);

@property (nonatomic, assign) id<BannerScrollViewDelegate>delegate;

@property (nonatomic, assign) NSTimeInterval scrollDuration;
@property (nonatomic, assign) BOOL autoScroll;
@property (nonatomic, assign) BOOL pullStyle;

@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) UIPageControl *pageControl;

- (void)reloadContents;
- (UIImageView *)currentImageView;
- (void)clearImageContents;

@end
