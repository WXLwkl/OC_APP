//
//  ProgressViewController.m
//  OC_APP
//
//  Created by xingl on 2018/1/29.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "ProgressViewController.h"
#import "LineProgressView.h"

#import "CircleProgressView.h"
#import "AmountLabel.h"
#import "StepProgressView.h"

@interface ProgressViewController ()

@property (nonatomic, strong) CircleProgressView *progressView;
@property (nonatomic, strong) AmountLabel *label;

@property (nonatomic, strong) LineProgressView *lineProgressView;

@end

@implementation ProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"进度条";
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 50);
    [btn setTitle:@"条形进度" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:@selector(xxx:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    self.lineProgressView = [[LineProgressView alloc] initWithFrame:CGRectMake(10, 160, kScreenWidth - 20, 30)];
    self.lineProgressView.borderTintColor = [UIColor colorWithRed:0.27 green:0.74 blue:0.99 alpha:1.00];
    self.lineProgressView.progressTintColor = [UIColor colorWithRed:0.27 green:0.74 blue:0.99 alpha:1.00];
    self.lineProgressView.trackTintColor = [UIColor colorWithRed:0.70 green:0.89 blue:0.96 alpha:1.00];
    [self.view addSubview:self.lineProgressView];
    
    
    
    
    
    [self circleProgressView];
    [self StepProgressView];
}
- (void)xxx:(UIButton *)sender  {
    CGFloat progress = arc4random() % 100;
    [self.lineProgressView setProgress:progress/100 animated:YES];
}

- (void)circle:(id)sender {
    
    float value = arc4random()%100/100.0;
    _label.amount = value*100*100;
    [_progressView setProgress:value animated:YES];
}

#pragma mark - 环形进度条和label
- (void)circleProgressView {
    
    UIButton *btnx = [UIButton buttonWithType:UIButtonTypeCustom];
    btnx.frame = CGRectMake(50, 200, 100, 50);
    [btnx setTitle:@"环形进度" forState:UIControlStateNormal];
    btnx.backgroundColor = [UIColor orangeColor];
    [btnx addTarget:self action:@selector(circle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnx];
    
    
    _progressView = [[CircleProgressView alloc] initWithFrame:CGRectMake(50, 260, 100, 100)];
    //    progressView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_progressView];
    _progressView.progress = 0.7;
    
    _label = [[AmountLabel alloc] initWithFrame:CGRectMake(160, 260, 100, 50)];
    [self.view addSubview:_label];
    _label.amount = 204;
}

#pragma mark - 步骤进度条
- (void)StepProgressView {
    NSArray *stepArr=@[@"区宝时尚",@"区宝时尚",@"时尚",@"区宝时尚",@"时尚"];
    StepProgressView *stepView=[StepProgressView progressViewFrame:CGRectMake(0, self.view.bounds.size.height - 200, self.view.bounds.size.width, 60) withTitleArray:stepArr];
    stepView.stepIndex=2;
    [self.view addSubview:stepView];
}


@end
