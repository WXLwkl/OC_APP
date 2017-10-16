//
//  RootViewController.m
//  OC_APP
//
//  Created by xingl on 2017/6/27.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

#pragma mark - UIStatusBarStyle
- (UIStatusBarStyle)preferredStatusBarStyle {
    return _statusBarStyle;
}
//动态更新状态栏颜色
-(void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    _statusBarStyle = statusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}





#pragma mark - life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    self.statusBarStyle = UIStatusBarStyleLightContent;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void) dealloc {
    
    XLLog(@"[🔥%@🔥 will dealloc 💥💥💥]",NSStringFromClass([self class]));
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
