//
//  ShowSlideViewController.m
//  OC_APP
//
//  Created by xingl on 2017/12/26.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "ShowSlideViewController.h"

#import "SliderViewController.h"
#import "ViewController.h"

@interface ShowSlideViewController ()<SliderViewControllerDelegate, SliderViewControllerDataSource>

@property (nonatomic, strong) SliderViewController *sliderVC;

@end

@implementation ShowSlideViewController

#pragma mark - - lazy load
- (SliderViewController *)sliderVC{
    if (!_sliderVC) {
        _sliderVC = [SliderViewController new];
        _sliderVC.dataSource = self;
        _sliderVC.delegate = self;
        [self addChildViewController:_sliderVC];
        [self.view addSubview:_sliderVC.view];
    }
    return _sliderVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.title = @"左右滑动视图";

    [self sliderVC];
}

#pragma mark - - BLSliderViewControllerDataSource
- (NSArray <NSString *> *)titlesArrayInSliderViewController{
    return @[@"打开",@"温柔",@"权威",@"藕片",@"风格",@"链接",@"电视",@"快乐",@"漂亮",@"配合",@"瓯海",@"提升"];
}

- (UIViewController *)sliderViewController:(SliderViewController *)sliderVC subViewControllerAtIndxe:(NSInteger)index{


    return [ViewController new];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)optionalViewStartYInSliderViewController {
    return 0;
}

- (CGFloat)viewOfChildViewControllerHeightInSliderViewController {
    return self.view.frame.size.height - 40 - 40;
}



@end
