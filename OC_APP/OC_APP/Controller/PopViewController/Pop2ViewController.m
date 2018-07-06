//
//  Pop2ViewController.m
//  OC_APP
//
//  Created by xingl on 2018/6/5.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "Pop2ViewController.h"

@interface Pop2ViewController ()

@end

@implementation Pop2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    self.title = @"弹出视图";
    
    NSString *str = NSStringFromCGRect(self.view.bounds);
    
    NSLog(@"%@", str);
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, self.view.bounds.size.height - 250, self.view.bounds.size.width, 50);
    btn.backgroundColor = [UIColor orangeColor];
    //    [btn addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
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
