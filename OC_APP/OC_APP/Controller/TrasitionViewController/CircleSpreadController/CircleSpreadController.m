//
//  CircleSpreadController.m
//  OC_APP
//
//  Created by xingl on 2019/3/1.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "CircleSpreadController.h"
#import "CircleSpreadPresentedController.h"

#import "UIViewController+XLTransmition.h"
#import "CircleSpreadAnimation.h"

//#import "UIViewController+GLTransition.h"
//#import "GLCircleSpreadAnimation.h"

@interface CircleSpreadController ()

@property (nonatomic, weak) UIButton *button;

@end

@implementation CircleSpreadController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"圆形缩放";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button = button;
    [button setTitle:@"点击或\n拖动我" forState:UIControlStateNormal];
    button.titleLabel.numberOfLines = 0;
    button.titleLabel.textAlignment = 1;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:11];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(present) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor grayColor];
    button.layer.cornerRadius = 20;
    button.layer.masksToBounds = YES;
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointMake(0, 0)).priorityLow();
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.greaterThanOrEqualTo(self.view);
        make.top.greaterThanOrEqualTo(self.view).offset(64);
        make.bottom.right.lessThanOrEqualTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.delegate = nil;
}

- (void)present {
    CircleSpreadPresentedController *presentVC = [[CircleSpreadPresentedController alloc] init];
    CircleSpreadAnimation *circleSpreadAnimation = [[CircleSpreadAnimation alloc] initWithStartPoint:CGPointMake(100, 700) radius:30];
    
//    [self xl_pushViewController:presentVC withAnimation:circleSpreadAnimation];
    [self xl_pushViewController:presentVC withAnimation:circleSpreadAnimation];
//    [self xl_presentViewControler:presentVC withAnimation:circleSpreadAnimation];
}

@end
