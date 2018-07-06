//
//  GCDViewController.m
//  OC_APP
//
//  Created by xingl on 2018/6/11.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "GCDViewController.h"

@interface GCDViewController ()

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"GCD";
    [self xl_setNavBackItem];
    
    
    [self test1];
}

- (void)test1 {
    
//    NSLog(@"1");
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        NSLog(@"2");
//    });
//    NSLog(@"3");
    
//    NSLog(@"1");
//    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//
//        NSLog(@"2");
//    });
//    NSLog(@"3");
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//        NSLog(@"1"); // 任务1
//
//        dispatch_sync(dispatch_get_main_queue(), ^{
//
//            NSLog(@"2"); // 任务2
//
//        });
//
//        NSLog(@"3"); // 任务3
//
//    });
//
//    NSLog(@"4"); // 任务4
//
//    while (1) {
//
//    }
//
//    NSLog(@"5"); // 任务5
    
    
    
}


@end
