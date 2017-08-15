//
//  SubscriptionViewController.m
//  OC_APP
//
//  Created by xingl on 2017/6/7.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "SubscriptionViewController.h"
#import "QQTableViewController.h"

@interface SubscriptionViewController ()

@end

@implementation SubscriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关注";
    
    
//    kApplication
    
    NSLog(@"%@",AppVersion);
    
    
    
    NSDate *date = [NSDate date];
    NSLog(@"date时间 = %@", date);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    NSString *dateStr = [formatter stringFromDate:date];
    NSLog(@"字符串时间 = %@", dateStr);
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    formatter1.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];//东八区时间
    NSString *dateStrS = [formatter stringFromDate:date];
    NSLog(@"字符串东八区时间 = %@", dateStrS);
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    formatter2.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    NSDate *newDate = [formatter2 dateFromString:@"2017-07-06 15:21:03"];
    NSLog(@"newDate = %@", newDate);
    
//    NSArray *zones = [NSTimeZone knownTimeZoneNames];
//    for (NSString *zone in zones) {
//        NSLog(@"时区名 = %@", zone);
//    }
    
    
    NSDate *datex = [NSDate date];
    NSTimeZone *zonex = [NSTimeZone systemTimeZone];
    NSInteger interval = [zonex secondsFromGMTForDate:datex];
    NSDate *localDate = [date  dateByAddingTimeInterval:interval];
    NSLog(@"localDate = %@",localDate);
    
    
    XLLog(@"-------------------------------------------");
//    [self timeIn];
//    [self timeIn2];
    XLLog(@"-------------------------------------------");
//    NSDate *date = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *dateComps = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekOfYear|NSCalendarUnitTimeZone fromDate:date];
    NSLog(@"时间 = %@", date);
    NSLog(@"年=%ld,月=%ld,日=%ld,时=%ld,分=%ld,秒=%ld,周=%ld,本月第%ld周,本年第%ld周,时区=%@", (long)dateComps.year, (long)dateComps.month, (long)dateComps.day, (long)dateComps.hour, (long)dateComps.minute, (long)dateComps.second, (long)dateComps.weekday, (long)dateComps.weekOfMonth, (long)dateComps.weekOfYear, dateComps.timeZone.name);
    
    
    
    
    
    
    
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 200, 100, 50);
    btn.backgroundColor = [UIColor grayColor];
    [btn setTitle:@"开始" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    
    
    
    
}


- (void)btnClick {
    
    
    QQTableViewController *vc = [[QQTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
    return;
    
    
//    [self xl_alertWithTitle:@"AA" message:@"xxx" andOthers:@[@"取消", @"确定"] animated:YES action:^(NSInteger index) {
//        NSLog(@"%ld", index);
//    }];
    
    [self xl_alertWithTitle:@"AA" message:@"xxx" buttons:@[@"NO", @"OK"] textFieldNumber:2 configuration:^(UITextField *textField, NSInteger index) {
        if (index == 0) {
            textField.placeholder = @"name";
        } else {
            textField.placeholder = @"age";
        }
    } animated:YES action:^(NSArray<UITextField *> *fields, NSInteger index) {
//        NSLog(@"%@---%ld",fields, index);
        NSLog(@"%@",fields[1].text);
    }];
    
    
//    MBProgressHUD *hud = [MBProgressHUD showProgressToView:nil ProgressModel:MBProgressHUDModeDeterminate Text:@"loading"];
//    [hud hide:YES];
    
    
    
    
//    [MBProgressHUD showAutoMessage:@"纯文字自动消失"];
//    [MBProgressHUD showMessage:@"文字+菊花,不自动消失" ToView:self.view];
//    [MBProgressHUD showMessage:@"纯文字，X秒后自动消失" ToView:self.view RemainTime:1.5];
//    [MBProgressHUD showCustomIcon:@"C-AvatarIcon" Title:@"自定义图片" ToView:self.view];
//    [MBProgressHUD showIconMessage:@"默认图,X秒后自动消失" ToView:self.view RemainTime:1.5];
    
//    [self performSelector:@selector(sss) withObject:self afterDelay:5];
}
- (void)sss {
    
    [MBProgressHUD hideHUDForView:self.view];
}

- (void)timeIn {
    
    NSDate *date = [NSDate date];
    NSTimeInterval timeIn = [date timeIntervalSince1970];
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:timeIn];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    NSString *newTime = [dateFormatter stringFromDate:newDate];
    XLLog(@"\n初始化时间 = %@，\n时间戳=%.0f，\n时间戳转为NSDate时间 = %@，\n转为字符串时间 = %@", date, timeIn, newDate, newTime);

}

- (void)timeIn2 {
    NSDate *date = [NSDate date];
    XLLog(@"系统零时区NSDate时间 = %@", date);
    NSTimeInterval timeIn = [date timeIntervalSince1970];
    XLLog(@"系统零时区NSDate时间转化为时间戳 = %.0f", timeIn);
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localDate = [date  dateByAddingTimeInterval:interval];
    XLLog(@"转化为本地NSDate时间 = %@", localDate);
    NSTimeInterval timeIn2 = [localDate timeIntervalSince1970];
    XLLog(@"本地NSDate时间转化为时间戳 = %.0f", timeIn2);
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:timeIn];
    NSDate *detaildate2 = [NSDate dateWithTimeIntervalSince1970:timeIn2];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    NSString *newTime = [dateFormatter stringFromDate:detaildate];
    NSString *newTime2 = [dateFormatter stringFromDate:detaildate2];
    XLLog(@"最终转为字符串时间1 = %@， 时间2 = %@", newTime, newTime2);
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
