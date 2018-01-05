//
//  SliderViewController.m
//  OC_APP
//
//  Created by xingl on 2017/12/26.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "SliderViewController.h"
#import "OptionalVeiw.h"

@interface SliderViewController () <UIScrollViewDelegate> {
    /** 缓存VC index */
    NSMutableArray <NSNumber *> *_cacheVCIndex;
}

@property (nonatomic, strong) OptionalVeiw *optionalView;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSArray <NSString *> *titleArray;

@end

static const CGFloat optionalViewHeight = 40.0;

@implementation SliderViewController

- (void)dealloc{
    [self removeObserver:_optionalView forKeyPath:@"_optionalView.sliderView.frame"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initSubviews];
    [self dealButtonCallBackBlcok];
}
/** 添加子视图 */
- (void)initSubviews{
    
    _cacheVCIndex = [NSMutableArray arrayWithCapacity:0];
    self.view.frame = CGRectMake(self.view.frame.origin.x, [self getOptionalStartY], self.view.frame.size.width, optionalViewHeight + [self getScrollViewHeight]);

    [self.view addSubview:self.optionalView];
    [self.view addSubview:self.mainScrollView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initializeSubViewControllerAtIndex:0];

    self.mainScrollView.contentSize = CGSizeMake(_titleArray.count *self.view.frame.size.width, self.mainScrollView.frame.size.height);
}
/** 处理事件回调 */
- (void)dealButtonCallBackBlcok {
    __weak SliderViewController *weakSelf = self;
    _optionalView.titleItemClickedCallBackBlock = ^(NSInteger index){

        weakSelf.mainScrollView.contentOffset = CGPointMake((index - 100) * self.view.frame.size.width , 0);
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - - lazy load
- (OptionalVeiw *)optionalView{
    if (!_optionalView) {
        _optionalView = [[OptionalVeiw alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, optionalViewHeight)];
        _optionalView.titleArray = self.titleArray;
    }
    return _optionalView;
}

- (UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.optionalView.frame), self.view.frame.size.width, [self getScrollViewHeight])];
        _mainScrollView.delegate = self;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.bounces = NO;
    }
    return _mainScrollView;
}

- (NSArray *)titleArray{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(titlesArrayInSliderViewController)]) {
        _titleArray = [self.dataSource titlesArrayInSliderViewController];
    }
    return _titleArray;
}

#pragma mark - - scrollView
/** 偏移量控制显示状态 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    NSInteger index = scrollView.contentOffset.x / (scrollView.frame.size.width + 1);
    [self initializeSubViewControllerAtIndex:index + 1];
    self.optionalView.contentOffsetX = scrollView.contentOffset.x;
}

#pragma mark - - private
- (CGFloat)getOptionalStartY {
    if (self.delegate && [self.delegate respondsToSelector:@selector(optionalViewStartYInSliderViewController)]) {
        return [self.delegate optionalViewStartYInSliderViewController];
    } else {
        return 0;
    }
}

- (CGFloat)getScrollViewHeight {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewOfChildViewControllerHeightInSliderViewController)]) {
        return [self.delegate viewOfChildViewControllerHeightInSliderViewController];
    } else {
        return kScreenHeight - optionalViewHeight - 20;
    }
}

- (void)initializeSubViewControllerAtIndex:(NSInteger)index {
    // 添加子控制器
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(sliderViewController:subViewControllerAtIndxe:)]) {
        UIViewController *vc = [self.dataSource sliderViewController:self subViewControllerAtIndxe:index];
        if (![_cacheVCIndex containsObject:[NSNumber numberWithInteger:index]]) {
            [_cacheVCIndex addObject:[NSNumber numberWithInteger:index]];
            vc.view.frame = CGRectMake(index * vc.view.frame.size.width, 0, vc.view.frame.size.width, self.mainScrollView.frame.size.height);
            [self addChildViewController:vc];
            [self.mainScrollView addSubview:vc.view];
        }
    }
}

@end
