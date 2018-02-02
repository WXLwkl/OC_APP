//
//  BannerScrollView.m
//  无限轮播Demo
//
//  Created by xingl on 16/7/25.
//  Copyright © 2016年 yjpal. All rights reserved.
//


#define HIGHT self.bounds.origin.y //由于_pageControl是添加进父视图的,所以实际位置要参考,滚动视图的y坐标
#define UISCREEN_WIDTH  self.bounds.size.width//广告的宽度
#define UISCREEN_HEIGHT  self.bounds.size.height//广告的高度
#define IMAGEVIEW_COUNT 3

#import "BannerScrollView.h"

static CGFloat const chageImageTime = 3.0;

@interface BannerScrollView () <UIScrollViewDelegate>
{
    UIPageControl *_pageControl;
    
    UIImageView *_leftImageView;
    UIImageView *_centerImageView;
    UIImageView *_rightImageView;
    
    int _currentImageIndex;//当前图片索引
    int _imageCount;//图片总数
    
    //循环滚动的周期时间
    NSTimer * _moveTime;
    BOOL _isTimeUp;
}
@end

@implementation BannerScrollView


#pragma mark - 自由指定广告所占的frame
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _currentImageIndex=0;
        _imageCount = 4;
    
        self.contentSize = CGSizeMake(UISCREEN_WIDTH*IMAGEVIEW_COUNT, UISCREEN_HEIGHT);
        self.contentOffset = CGPointMake(UISCREEN_WIDTH, 0);
        self.delegate = self;
        self.pagingEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        

        [self configUI];
        
        _moveTime = [NSTimer scheduledTimerWithTimeInterval:chageImageTime target:self selector:@selector(animalMoveImage) userInfo:nil repeats:YES];
        _isTimeUp = NO;
        
    }
    return self;
}
- (void)configUI {
    
    [self addImageViews];
}

- (void)setPageControlShowStyle:(UIPageControlShowStyle)PageControlShowStyle {
    
    if (PageControlShowStyle == UIPageControlShowStyleNone) {
        return;
    }
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.userInteractionEnabled = NO;
    CGSize size = [_pageControl sizeForNumberOfPages:_imageCount];
    _pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
    
    switch (PageControlShowStyle) {
            
        case UIPageControlShowStyleLeft:
            _pageControl.center = CGPointMake(20+size.width/2.0, HIGHT+UISCREEN_HEIGHT - 10);
            break;
        case UIPageControlShowStyleCenter:
            _pageControl.center = CGPointMake(UISCREEN_WIDTH/2.0, HIGHT+UISCREEN_HEIGHT - 10);
            break;
        case UIPageControlShowStyleRight:
            _pageControl.center = CGPointMake(UISCREEN_WIDTH-20-size.width/2.0, HIGHT+UISCREEN_HEIGHT - 10);
            break;
        default:
            break;
    }
    _pageControl.numberOfPages = _imageCount;
    //设置当前页
    _pageControl.currentPage=_currentImageIndex;
    //设置颜色
    _pageControl.pageIndicatorTintColor=[UIColor colorWithRed:193/255.0 green:219/255.0 blue:249/255.0 alpha:1];
    //设置当前页颜色
    _pageControl.currentPageIndicatorTintColor=[UIColor colorWithRed:0 green:150/255.0 blue:1 alpha:1];
    
    [self performSelector:@selector(adPageControl) withObject:nil afterDelay:0.1f];
 
    
    
}

- (void)adPageControl //由于PageControl这个空间必须要添加在滚动视图的父视图上(添加在滚动视图上的话会随着图片滚动,而达不到效果)
{
    [[self superview] addSubview:_pageControl];
}


- (void)addImageViews {
    
    _leftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT)];
//    _leftImageView.contentMode=UIViewContentModeScaleAspectFit;
    [self addSubview:_leftImageView];
    
    _centerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(UISCREEN_WIDTH, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT)];
//    _centerImageView.contentMode=UIViewContentModeScaleAspectFit;
    [self addSubview:_centerImageView];
    
    _rightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(2*UISCREEN_WIDTH, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT)];
//    _rightImageView.contentMode=UIViewContentModeScaleAspectFit;
    
    [self addSubview:_rightImageView];
    

    //加载默认图片
    _leftImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"image%i",_imageCount-1]];
    _centerImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"image%i",0]];
    _rightImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"image%i",1]];
    
    
    _centerImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    [_centerImageView addGestureRecognizer:tapGesture];
    
    
}
- (void)tapGestureRecognized:(UITapGestureRecognizer *)gesture {
    NSString *str = [NSString stringWithFormat:@"%d",_currentImageIndex];
    _openURLBlock(str);
}
#pragma mark - scrollView
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self reloadImage];
    
    [self setContentOffset:CGPointMake(UISCREEN_WIDTH, 0) animated:NO];
    
    _pageControl.currentPage = _currentImageIndex;
    
}
- (void)reloadImage {
    
    int leftImageIndex, rightImageIndex;
    
    CGPoint offset = [self contentOffset];
    
    if (offset.x > UISCREEN_WIDTH) {
        _currentImageIndex = (_currentImageIndex+1)%_imageCount;
    } else if (offset.x < UISCREEN_WIDTH) {
        _currentImageIndex = (_currentImageIndex+_imageCount-1)%_imageCount;
    }
    _centerImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"image%i",_currentImageIndex]];
    
    
    leftImageIndex = (_currentImageIndex-1+_imageCount)%_imageCount;
    rightImageIndex= (_currentImageIndex+1)%_imageCount;
    
    _leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"image%i",leftImageIndex]];
    _rightImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"image%i",rightImageIndex]];
    
    if (!_isTimeUp) {
        
        [_moveTime setFireDate:[NSDate dateWithTimeIntervalSinceNow:chageImageTime]];
    }
    _isTimeUp = NO;
}

- (void)animalMoveImage {
    [self setContentOffset:CGPointMake(UISCREEN_WIDTH * 2, 0) animated:YES];
    _isTimeUp = YES;
    [NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(scrollViewDidEndDecelerating:) userInfo:nil repeats:NO];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
