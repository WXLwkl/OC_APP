//
//  CardViewController.m
//  OC_APP
//
//  Created by xingl on 2017/12/7.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "CardViewController.h"
#import "CardView.h"
#import "LevalView.h"
@interface CardViewController ()

@end

@implementation CardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"卡片切换效果";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self xl_setNavBackItem];
    [self setupUI];
}

- (void)setupUI {
    CardView *v = [[CardView alloc] initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, 160)];
    [self.view addSubview:v];

    LevalView *view = [[LevalView alloc] initWithFrame:CGRectMake(0, 170, self.view.bounds.size.width, 300) withInfoArray:@[@{@"name":@"王",@"department":@"技术部",@"job":@"ios开发",@"bgColor":@"1.jpg"},@{@"name":@"张",@"department":@"技术部",@"job":@"Android开发",@"bgColor":@"2.jpg"},@{@"name":@"刘",@"department":@"技术部",@"job":@"测试开发",@"bgColor":@"3.jpg"},@{@"name":@"刘2",@"department":@"技术部",@"job":@"测试开发",@"bgColor":@"1"}]];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
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
