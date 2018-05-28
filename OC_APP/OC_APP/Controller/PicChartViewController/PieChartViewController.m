//
//  PicChartViewController.m
//  OC_APP
//
//  Created by xingl on 2018/5/25.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "PieChartViewController.h"

#import "PieChartView.h"


@interface PieChartViewController ()

@end

@implementation PieChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"图形";
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    PieChartView *chart = [[PieChartView alloc] initWithFrame:CGRectMake(0, 30, width, 320)];
    
    [self.view addSubview:chart];
    
    
    FoodPieModel *model1 = [[FoodPieModel alloc] init];
    
    model1.rate = 0.7261;
    model1.name = @"哈哈哈哈哈哈";
    model1.value = 423651.23;
    
    
    FoodPieModel *model2 = [[FoodPieModel alloc] init];
    
    model2.rate = 0.068;
    model2.name = @"哈哈哈哈哈哈";
    model2.value = 423651.23;
    
    
    FoodPieModel *model3 = [[FoodPieModel alloc] init];
    
    model3.rate = 0.068;
    model3.name = @"哈哈";
    model3.value = 423651.23;
    
    
    FoodPieModel *model4 = [[FoodPieModel alloc] init];
    
    model4.rate = 0.0594;
    model4.name = @"哈哈哈哈哈哈";
    model4.value = 423651.23;
    
    
    FoodPieModel *model5 = [[FoodPieModel alloc] init];
    
    model5.rate = 0.0393;
    model5.name = @"哈哈";
    model5.value = 423651.23;
    
    
    FoodPieModel *model6 = [[FoodPieModel alloc] init];
    
    model6.rate = 0.0391;
    model6.name = @"哈哈哈哈哈哈哈哈哈哈哈哈";
    model6.value = 423651.23;
    
    
    NSArray *dataArray = @[model1, model2, model3, model4, model5, model6];
    
    chart.dataArray = dataArray;
    
    chart.title = @"金额";
    
    [chart draw];
    
}



@end
