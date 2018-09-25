//
//  DSLViewController.m
//  OC_APP
//
//  Created by xingl on 2018/9/4.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "DSLViewController.h"
#import "DSLView.h"

@interface DSLViewController ()

@end

@implementation DSLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"链式编程";
    
    DSLView *view = DSLView.make.xl_frame(CGRectMake(10, 10, 100, 50)).xl_backgroundColor([UIColor redColor]);
    
    [self.view addSubview:view];
}


@end
