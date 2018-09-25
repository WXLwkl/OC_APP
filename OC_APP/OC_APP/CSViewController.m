//
//  CSViewController.m
//  OC_APP
//
//  Created by xingl on 2018/9/17.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "CSViewController.h"

@interface CSViewController ()

@end

@implementation CSViewController

- (void)dealloc
{
    NSLog(@"---------- dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 50);
    btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
}

- (void)clicked {
    [self xl_closeToRootViewController];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CSViewController *vc = [CSViewController new];
    [self presentViewController:vc animated:YES completion:nil];
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
