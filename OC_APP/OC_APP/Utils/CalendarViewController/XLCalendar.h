//
//  XLCalendar.h
//  OC_APP
//
//  Created by xingl on 2017/7/25.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLCalendar : UIView

/** 显示农历，默认为YES */
@property (nonatomic, assign) BOOL showChineseCalendar;

/**
 * 日期选择回调
 * year：年
 * month：月
 * day：日
 */
- (void)selectDateOfMonth:(void(^)(NSInteger year,NSInteger month,NSInteger day))selectBlock;

@end
