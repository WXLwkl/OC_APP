//
//  WriteViewController.m
//  OC_APP
//
//  Created by xingl on 2017/6/7.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "WriteViewController.h"

@interface WriteViewController ()

@end

@implementation WriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.title = @"写文章";
    
    // 设置导航条的按钮
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftBatButton)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.statusBarStyle = UIStatusBarStyleDefault;
    
}

- (void)clickLeftBatButton{
    [self dismissViewControllerAnimated:YES completion:nil];
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
