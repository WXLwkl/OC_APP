//
//  XLMonthCollectionView.h
//  OC_APP
//
//  Created by xingl on 2017/7/25.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MonthModel;

@interface XLMonthCollectionView : UIView

/**
 * 日期选择回调
 */
@property (nonatomic ,copy)void(^selectDateBlock)(NSInteger,NSInteger,NSInteger);


/**
 * showChineseCalendar：显示农历， 默认为YES
 */
@property (nonatomic ,assign)BOOL showChineseCalendar;


- (void)calendarContainerWhereMonth:(NSInteger)currentTag month:(void(^)(MonthModel *month))currentMonth;

@end
