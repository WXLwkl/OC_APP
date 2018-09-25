//
//  BannerScrollView.m
//  无限轮播Demo
//
//  Created by xingl on 16/7/25.
//  Copyright © 2016年 yjpal. All rights reserved.
//


#import "BannerScrollView.h"
#import "BannerImageView.h"


@interface BannerScrollView () <UIScrollViewDelegate, CAAction> {
    
    NSInteger pagesCount;
    NSInteger _centerPageIndex;
    BOOL changeCurrentAnimate;
}

@property (nonatomic, strong) BannerImageView *leftImageView;
@property (nonatomic, strong) BannerImageView *centerImageView;
@property (nonatomic, strong) BannerImageView *rightImageView;

@property (nonatomic, assign) NSInteger leftPageIndex;
@property (nonatomic, assign) NSInteger centerPageIndex;
@property (nonatomic, assign) NSInteger rightPageIndex;

@property (nonatomic, assign) NSInteger currentPageIndex;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation BannerScrollView

- (void)dealloc
{
    NSLog(@"---- BannerScrollView dealloc");
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        {
            self.scrollView.frame = self.bounds;
            self.scrollView.backgroundColor = [UIColor whiteColor];
            [self addSubview:self.scrollView];
        }
        {
            [self.scrollView addSubview:self.leftImageView];
            [self.scrollView addSubview:self.centerImageView];
            [self.scrollView addSubview:self.rightImageView];
        }
        
        _scrollDuration = 2.5;
        [self addSubview:self.pageControl];
        [self addPageControlLayout];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleStatusBarOrientationDidChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.scrollView.bounds);
    if (pagesCount > 1) {
        self.scrollView.scrollEnabled = YES;
        [self.scrollView setContentSize:CGSizeMake(width * 3, 0)];
    } else {
        self.scrollView.scrollEnabled = NO;
        [self.scrollView setContentSize:CGSizeMake(width, 0)];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview && self.timer) {
        // 销毁定时器
        [self.timer invalidate];
        self.timer = nil;
    }
    if (newSuperview) {
        [self reloadContents];
    }
}

- (void)addPageControlLayout {
    
    self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0
                                                      constant:-20.0]];
}


- (void)updateCurrentPageIndex:(NSInteger)currentPageIndex {
    if (currentPageIndex > pagesCount - 1) {
        currentPageIndex = 0;
    } else if (currentPageIndex < 0) {
        currentPageIndex = pagesCount - 1;
    }
    self.pageControl.currentPage = currentPageIndex;
    [self.pageControl updateCurrentPageDisplay];
    
    if (changeCurrentAnimate) {
        CGFloat width = CGRectGetWidth(self.scrollView.bounds);
        CGFloat offsetX = width * 2;
        _centerPageIndex = currentPageIndex;
        [self.scrollView setContentOffset:CGPointMake(offsetX, 0.0) animated:YES];
        [self performSelector:@selector(updateContentFrame) withObject:nil afterDelay:0.35];
    } else {
        _centerPageIndex = currentPageIndex;
        [self updateContentFrame];
    }
    
    if ([self.delegate respondsToSelector:@selector(bannerScrollView:currentIndex:)]) {
        [self.delegate bannerScrollView:self currentIndex:_centerPageIndex];
    }
}

- (void)updateContentFrame {
    CGFloat width = CGRectGetWidth(self.scrollView.bounds);
    CGFloat height = CGRectGetHeight(self.scrollView.bounds);
    
    self.scrollView.contentOffset = CGPointMake(width, 0.0);
    self.leftImageView.frame = CGRectMake(0.0, 0.0, width, height);
    self.centerImageView.frame = CGRectMake(width, 0.0, width, height);
    self.rightImageView.frame = CGRectMake(width * 2, 0.0, width, height);
    
    if (pagesCount > 0) {
        [self updateImagesContent];
    }
}

- (void)updateImagesContent {
    if ([self.delegate respondsToSelector:@selector(bannerScrollView:imageAtIndex:imageView:)]) {
        
        [self.delegate bannerScrollView:self
                           imageAtIndex:self.centerPageIndex
                              imageView:self.centerImageView.imageView];
        
        [self.delegate bannerScrollView:self
                           imageAtIndex:self.leftPageIndex
                              imageView:self.leftImageView.imageView];
        
        [self.delegate bannerScrollView:self
                           imageAtIndex:self.rightPageIndex
                              imageView:self.rightImageView.imageView];
    }
}

#pragma mark - timerHelp
- (void)timerPause{
    
    if (![self.timer isValid]) return;
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)timerResume{
    
    if (![self.timer isValid]) return;
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)timerResumeAfter:(NSTimeInterval)timeInterval{
    
    if (![self.timer isValid]) return;
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:timeInterval]];
}

#pragma mark - out
- (void)reloadContents {
//    CGFloat width = CGRectGetWidth(self.scrollView.bounds);
    pagesCount = 0;
    if ([self.delegate respondsToSelector:@selector(bannerScrollViewNumbersOfContents:)]) {
        pagesCount = [self.delegate bannerScrollViewNumbersOfContents:self];
    }
    self.pageControl.numberOfPages = pagesCount;
    [self.pageControl sizeToFit];
    
//    if (pagesCount > 1) {
//        self.scrollView.scrollEnabled = YES;
//        [self.scrollView setContentSize:CGSizeMake(width*3, 0)];
//    } else {
//        self.scrollView.scrollEnabled = NO;
//        [self.scrollView setContentSize:CGSizeMake(width, 0)];
//    }
    [self setNeedsLayout];
    
    [self updateContentFrame];
}
- (UIImageView *)currentImageView {
    
    return self.centerImageView.imageView;
}
- (void)clearImageContents {
    self.centerImageView.imageView.image = nil;
    self.leftImageView.imageView.image = nil;
    self.rightImageView.imageView.image = nil;
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = CGRectGetWidth(self.scrollView.bounds);
    CGFloat offsetX  = scrollView.contentOffset.x;
    
    if (offsetX > 2 * width) {
        self.centerPageIndex = self.centerPageIndex - 1;
    } else if (offsetX < 0.0) {
        self.centerPageIndex = self.centerPageIndex + 1;
    }
    NSLog(@"------ %.2f",offsetX);
    if (self.pullStyle) {
        CGFloat height = CGRectGetHeight(self.scrollView.bounds);
        if (offsetX > width) {
            self.rightImageView.frame = CGRectMake(2 * width, 0.0, offsetX - width, height);
            self.centerImageView.frame = CGRectMake(offsetX, 0.0, 2 * width - offsetX, height);
        } else if (offsetX < width) {
            self.leftImageView.frame = CGRectMake(offsetX, 0.0, width - offsetX, height);
            self.centerImageView.frame = CGRectMake(width, 0.0, offsetX, height);
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    scrollView.userInteractionEnabled = YES;
    CGFloat width = CGRectGetWidth(self.scrollView.bounds);
    NSInteger index = round(scrollView.contentOffset.x / width);
    self.centerPageIndex = self.centerPageIndex + index - 1;
    if (self.autoScroll) {
        [self timerResumeAfter:_scrollDuration];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.autoScroll) {
        [self timerPause];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    scrollView.userInteractionEnabled = YES;
}

#pragma mark - CAAction
//- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {
//    if ([event isEqualToString:kCAOnOrderIn] || [event isEqualToString:kCAOnOrderOut]) {
//        return self;
//    }
//    return nil;
//}
//
//- (void)runActionForKey:(NSString *)event object:(id)anObject arguments:(NSDictionary *)dict {
//    if (self.autoScroll) {
//        if ([event isEqualToString:kCAOnOrderIn]) {
//            [self timerResume];
//        } else if ([event isEqualToString:kCAOnOrderOut]) {
//            [self timerPause];
//        }
//    }
//}

#pragma mark - Action

- (void)handleStatusBarOrientationDidChange:(NSNotification *)notification {
    //1.获取 当前设备 实例
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight: {
            if (pagesCount == 0) {
                [self reloadContents];
            } else {
                [self setNeedsLayout];

                [self updateContentFrame];
            }
            break;
        }
        case UIInterfaceOrientationUnknown:
            break;
        default:
            NSLog(@"无法辨识");
            break;
    }
}

- (void)autoScrollAction:(NSTimer *)timer {
    if (pagesCount > 1) {
        self.currentPageIndex = self.centerPageIndex + 1;
    }
}

- (void)scrollContentClick:(UIControl *)control {
    if (pagesCount < 1) return;
    if ([self.delegate respondsToSelector:@selector(bannerScrollView:clickContentAtIndex:)]) {
        [self.delegate bannerScrollView:self clickContentAtIndex:self.centerPageIndex];
    }
}

#pragma mark - getter && setter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:1.0 alpha:0.7];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.defersCurrentPageDisplay = YES;
        [_pageControl sizeToFit];
    }
    return _pageControl;
}

- (BannerImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[BannerImageView alloc] init];
    }
    return _leftImageView;
}

- (BannerImageView *)centerImageView {
    if (!_centerImageView) {
        _centerImageView = [[BannerImageView alloc] init];
        [_centerImageView addTarget:self action:@selector(scrollContentClick:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _centerImageView;
}

- (BannerImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[BannerImageView alloc] init];
    }
    return _rightImageView;
}

- (NSInteger)leftPageIndex {
    if (pagesCount == 0) {
        return 0;
    }
    NSInteger leftIndex = self.centerPageIndex - 1;
    if (leftIndex < 0) {
        leftIndex = pagesCount - 1;
    }
    return leftIndex;
}

- (NSInteger)centerPageIndex {
    
    if (_centerPageIndex > pagesCount - 1) {
        
        _centerPageIndex = pagesCount - 1;
    } else if (_centerPageIndex < 0) {
        _centerPageIndex = 0;
    }
    return _centerPageIndex;
}

- (NSInteger)rightPageIndex {
    if (pagesCount == 0) {
        return 0;
    }
    NSInteger rightIndex = self.centerPageIndex + 1;
    if (rightIndex > pagesCount - 1) {
        rightIndex = 0;
    }
    return rightIndex;
}

- (NSInteger)currentPageIndex {

    return self.centerPageIndex;
}


- (NSTimer *)timer {
    
    if (!_timer) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:_scrollDuration
                                                  target:self
                                                selector:@selector(autoScrollAction:)
                                                userInfo:nil
                                                 repeats:YES];
    }
    return _timer;
}

- (void)setAutoScroll:(BOOL)autoScroll {
    
    if (_autoScroll != autoScroll) {
        _autoScroll = autoScroll;
        if (_autoScroll) {
            [self timer];
        } else {
            if (_timer) [_timer isValid];
        }
    }
}

- (void)setCenterPageIndex:(NSInteger)centerPageIndex {
    changeCurrentAnimate = NO;
    [self updateCurrentPageIndex:centerPageIndex];
}

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex {

    changeCurrentAnimate = YES;
    [self updateCurrentPageIndex:currentPageIndex];
}

@end
