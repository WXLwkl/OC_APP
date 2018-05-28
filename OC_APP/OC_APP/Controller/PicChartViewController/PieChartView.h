//
//  PieChartView.h
//  OC_APP
//
//  Created by xingl on 2018/5/25.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodPieModel.h"

@interface PieChartView : UIView

/** 数据 */
@property (nonatomic, strong) NSArray *dataArray;
/** 标题 */
@property (nonatomic, copy) NSString *title;

/** 绘制 */
- (void)draw;
@end
