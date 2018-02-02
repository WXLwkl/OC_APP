//
//  GuideView.m
//  OC_APP
//
//  Created by xingl on 2018/1/16.
//  Copyright © 2018年 兴林. All rights reserved.
//

#define pageCount 5
#define picH 2330 / 2
#define padding 200
#define topPicH 70
#define topPicW 112
#define btnH 35
#define btnW 140

#import "GuideView.h"

@interface GuideView ()<UIScrollViewDelegate>

/**
 *  底部滚动图片
 */
@property (nonatomic,strong)UIScrollView *guideView;
/**
 *  球形图片
 */
@property (nonatomic,strong)UIImageView *picView;
/**
 *  牌型滚动
 */
@property (nonatomic,strong)UIImageView *paiView;
/**
 *  指示
 */
@property (nonatomic,strong)UIPageControl *pageControl;
/**
 *  顶部图片滚动
 */
@property (nonatomic,strong)UIScrollView *topView;


@property (nonatomic, strong) UIWindow *window;

@end

@implementation GuideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /**
         背景图片
         */
        UIImageView *backView = [[UIImageView alloc]initWithFrame:self.frame];
        backView.image = [UIImage imageNamed:@"page_bg_35"];
        [self addSubview:backView];

        /**
         滚动 辅助作用
         */
        UIScrollView *ado_guideView = [[UIScrollView alloc] initWithFrame:self.frame];
        ado_guideView.contentSize = CGSizeMake(frame.size.width * pageCount, frame.size.height);
        ado_guideView.bounces = NO;
        ado_guideView.pagingEnabled = YES;
        ado_guideView.delegate = self;
        ado_guideView.showsHorizontalScrollIndicator = NO;

        /**
         滚动球

         */
        UIImageView *picView = [[UIImageView alloc] init];
        picView.xl_width = picH ;
        picView.xl_height = picH;
        picView.xl_centerX = frame.size.width / 2;
        picView.xl_centerY = frame.size.height + padding;
#warning 设置锚点是个坑
        picView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        picView.image = [UIImage imageNamed:@"guider_qiu_35"];

        /**
         滚动牌
         */
        UIImageView *paiView = [[UIImageView alloc] init];
        paiView.xl_width = picH;
        paiView.xl_height = picH;
        paiView.xl_centerX = frame.size.width / 2 ;
        paiView.xl_centerY = frame.size.height + padding;
        paiView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        paiView.image = [UIImage imageNamed:@"guider_pai_35"];

        /**
         指示器
         */
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(frame.size.width / 2 - 50, frame.size.height - 20, 100, 20)];
        pageControl.numberOfPages = 5;
        pageControl.currentPage = 0;
        pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        [backView addSubview:pageControl];

        /**
         顶部滚动图片
         */
        UIScrollView *topView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, frame.size.width, topPicH)];
        topView.contentSize = CGSizeMake(frame.size.width * pageCount, topPicH);
        topView.bounces = NO;
        topView.pagingEnabled = YES;
        for (int i = 0; i < pageCount; i ++) {
            UIImageView *topPic =  [[UIImageView alloc] init];
            topPic.xl_width = topPicW;
            topPic.xl_height = topPicH;
            topPic.xl_centerX = i * frame.size.width + frame.size.width / 2;
            topPic.xl_y = 0;
            NSString *picName = [NSString stringWithFormat:@"page_top_%d",i];
            topPic.image = [UIImage imageNamed:picName];
            [topView addSubview:topPic];
        }
        [backView addSubview:topView];
        self.topView = topView;

        self.pageControl = pageControl;
        [self addSubview:paiView];
        [self addSubview:picView];
        [self addSubview:ado_guideView];
        self.guideView = ado_guideView;
        self.picView = picView;
        self.paiView = paiView;
    }
    return self;
}


- (void)show {

    //初始化一个Window， 做到对业务视图无干扰。
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = [UIViewController new];
    window.rootViewController.view.backgroundColor = [UIColor clearColor];
    window.rootViewController.view.userInteractionEnabled = NO;

    //设置为最顶层，防止 AlertView 等弹窗的覆盖
    window.windowLevel = UIWindowLevelStatusBar + 1;

    //默认为YES，当你设置为NO时，这个Window就会显示了
    window.hidden = NO;
    window.alpha = 1;

    ///防止释放，显示完后  要手动设置为 nil
    self.window = window;

    [window addSubview:self];
}


/**
 *  模态到下个页面
 *
 */
- (void)go2MainVC:(UIButton *)btn {

    //来个渐显动画
    //来个渐显动画
    [UIView animateWithDuration:0.3 animations:^{
        self.window.alpha = 0;
    } completion:^(BOOL finished) {
        [self.window.subviews.copy enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        self.window.hidden = YES;
        self.window = nil;
    }];
}

/**
 *  scrollView代理方法
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float offSetX = scrollView.contentOffset.x;
    self.picView.layer.transform = CATransform3DMakeRotation(-offSetX*(M_PI)/self.frame.size.width / 3, 0, 0, 1);
    self.paiView.layer.transform = CATransform3DMakeRotation(-offSetX*(M_PI)/self.frame.size.width / 3, 0, 0, 1);
    self.pageControl.currentPage = scrollView.contentOffset.x / self.frame.size.width;


    if (self.pageControl.currentPage == 4) {
        UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 2  + offSetX - btnW / 2, self.frame.size.height - 121, btnW, btnH)];
        [nextBtn addTarget:self action:@selector(go2MainVC:) forControlEvents:UIControlEventTouchUpInside];
        nextBtn.backgroundColor = [UIColor clearColor];
        [scrollView addSubview:nextBtn];
    }


    self.topView.contentOffset = CGPointMake(offSetX, 0);
}

@end
