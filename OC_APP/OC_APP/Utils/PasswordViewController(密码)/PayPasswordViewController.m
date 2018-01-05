//
//  PayPasswordViewController.m
//  OC_APP
//
//  Created by xingl on 2017/12/12.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "PayPasswordViewController.h"
#import "PayPasswordView.h"
@interface PayPasswordViewController ()<PayPasswordViewDelegate>

@end

@implementation PayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"交易密码";
    [self xl_setNavBackItem];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 50);
    [btn setTitle:@"发起支付" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)clicked:(UIButton *)sender {
    PayPasswordView *v = [[PayPasswordView alloc] init];
    v.delegate = self;
    [v show];
}

- (NSString *)finish:(NSString *)pwd {
    NSLog(@"%@",pwd);
    return pwd;
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
