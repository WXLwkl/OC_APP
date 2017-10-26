//
//  CustomViewController.m
//  OC_APP
//
//  Created by xingl on 2017/10/18.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "CustomViewController.h"

#import "MyView.h"
#import "IDCard.h"
#import "CusView.h"

@interface CustomViewController ()

@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"自定义视图";
    [self xl_setNavBackItem];
    
    [self initSubViews];
}

- (void)initSubViews {
//    MyView *v = [[MyView alloc] init];
//    v.frame = CGRectMake(0, 0, 67, 100);
//    v.image = [UIImage imageNamed:@"01"];
//    v.title = @"男神!";
//    [self.view addSubview:v];
//    v.backgroundColor = [UIColor yellowColor];
    
    
//    CusView *view = [CusView showView];
//    view.frame = CGRectMake(0, 300, 375, 200);
//    [self.view addSubview:view];
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
