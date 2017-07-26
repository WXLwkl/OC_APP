//
//  CalendarViewController.m
//  OC_APP
//
//  Created by xingl on 2017/7/25.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "CalendarViewController.h"
#import "XLCalendar.h"
@interface CalendarViewController ()

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"日历";
    
    
    
    
    XLCalendar *calendar = [[XLCalendar alloc]initWithFrame:CGRectMake(20, 100, CGRectGetWidth(self.view.bounds)-40, 300)];
    [self.view addSubview:calendar];
    
    calendar.showChineseCalendar = YES;
    [calendar selectDateOfMonth:^(NSInteger year, NSInteger month, NSInteger day) {
        NSLog(@"%ld年/%ld月/%ld日",(long)year,(long)month,(long)day);
        
        [MBProgressHUD showAutoMessage:[NSString stringWithFormat:@"%ld年/%ld月/%ld日", (long)year, (long)month, (long)day]];
        
    }];
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
