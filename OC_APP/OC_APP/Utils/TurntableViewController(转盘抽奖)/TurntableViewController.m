//
//  TurntableViewController.m
//  OC_APP
//
//  Created by xingl on 2017/12/7.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "TurntableViewController.h"
#import "TurntableViewController1.h"
#import "TurntableViewController2.h"
#import "TurntableViewController3.h"

@interface TurntableViewController ()

@end

@implementation TurntableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.title = @"抽奖";

    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 100, self.view.bounds.size.width, 50);
    btn1.tag = 100;
    [btn1 setTitle:@"抽奖1" forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor orangeColor];
    [btn1 addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];

    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(0, 180, self.view.bounds.size.width, 50);
    btn2.tag = 200;
    [btn2 setTitle:@"抽奖2" forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor orangeColor];
    [btn2 addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];

    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(0, 260, self.view.bounds.size.width, 50);
    btn3.tag = 300;
    [btn3 setTitle:@"抽奖3" forState:UIControlStateNormal];
    btn3.backgroundColor = [UIColor orangeColor];
    [btn3 addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
}
- (void)clicked:(UIButton *)sender {
    switch (sender.tag) {
        case 100:
        {
            TurntableViewController1 *vc = [TurntableViewController1 new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 200:
        {
            TurntableViewController2 *vc = [TurntableViewController2 new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 300:
        {
            TurntableViewController3 *vc = [TurntableViewController3 new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
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
