//
//  SpotlightViewController.m
//  OC_APP
//
//  Created by xingl on 2018/6/12.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "SpotlightViewController.h"
#import "SpotlightView.h"

@interface SpotlightViewController ()<SpotlightViewDelegate>

@end

@implementation SpotlightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"类似spotlight菜单";
    [self xl_setNavBackItem];
    
    SpotlightView *view = [[SpotlightView alloc] initWithFrame:CGRectMake(0, 200, 50, 50)];
    view.delegate = self;
    view.centerImageName = @"f_static_007";
    view.sourceArray = @[@{@"title":@"",@"icon":@"f_static_000"},
                         @{@"title":@"",@"icon":@"f_static_001"},
                         @{@"title":@"",@"icon":@"f_static_002"},
                         @{@"title":@"",@"icon":@"f_static_003"},
                         @{@"title":@"",@"icon":@"f_static_004"},
                         @{@"title":@"",@"icon":@"f_static_005"},
                         @{@"title":@"",@"icon":@"f_static_006"}];
    view.startRadian = -M_PI / 2;
    view.endRadian = M_PI / 2;
    view.radius = 20;
    view.multiple = 5;
    [view setup];
    
    [self.view addSubview:view];
}

- (void)didClickItem:(SpotlightView *)spotlightView atIndex:(NSInteger)index {
    NSLog(@"you did click item at -> %ld",(long)index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
