//
//  CalendaDaysCell.h
//  OC_APP
//
//  Created by xingl on 2017/7/25.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DayModel;
@interface CalendaDaysCell : UICollectionViewCell

@property (nonatomic ,strong)DayModel *dayModel;

@property (nonatomic ,assign)BOOL showChinaCalendar;


- (void)signCurrentDay:(DayModel *)dayModel;

@end
