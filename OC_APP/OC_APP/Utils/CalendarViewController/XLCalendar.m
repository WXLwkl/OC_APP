//
//  XLCalendar.m
//  OC_APP
//
//  Created by xingl on 2017/7/25.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "XLCalendar.h"
#import "WeeksView.h"
#import "XLMonthCollectionView.h"
#import "CalendarModel.h"

#define CalendarColor [UIColor colorWithRed:240.0/255.0 green:156.0/255.0 blue:40.0/255.0 alpha:1.0]

@interface XLCalendar ()

@property (nonatomic, strong) WeeksView *weeks;
@property (nonatomic, strong) XLMonthCollectionView *dayView;

@end

@implementation XLCalendar

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.showChineseCalendar = YES;
        
        [self initSubViews];
        
    }
    return self;
}
- (void)setShowChineseCalendar:(BOOL)showChineseCalendar{
    _showChineseCalendar = showChineseCalendar;
    self.dayView.showChineseCalendar = _showChineseCalendar;
}


- (void)selectDateOfMonth:(void (^)(NSInteger, NSInteger, NSInteger))selectBlock {
    [self.dayView setSelectDateBlock:selectBlock];
}
- (void)initSubViews {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 1.5;
    self.layer.borderColor = CalendarColor.CGColor;
    
    [self addSubview:self.weeks];
    [self addSubview:self.dayView];
    
    __weak typeof(self) weakSelf = self;
    [self.dayView calendarContainerWhereMonth:0 month:^(MonthModel *month) {
        weakSelf.weeks.year = [NSString stringWithFormat:@"%ld",month.year];
    }];
    
    [self.weeks selectMonth:^(BOOL increase) {
        static NSInteger selectNumber = 0;
        static UIViewAnimationOptions animationOption = UIViewAnimationOptionTransitionCurlUp;
        if (increase) {
            selectNumber = selectNumber + 1;
            animationOption = UIViewAnimationOptionTransitionCurlUp;
        }
        else{
            selectNumber = selectNumber - 1;
            animationOption = UIViewAnimationOptionTransitionCurlDown;
            
        }
        [UIView transitionWithView:weakSelf.dayView duration:0.8 options:animationOption animations:^{
            [weakSelf.dayView calendarContainerWhereMonth:selectNumber month:^(MonthModel *month) {
                weakSelf.weeks.year = [NSString stringWithFormat:@"%ld",(long)month.year];
            }];
        } completion:nil];
    }];
}



- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat h = CGRectGetHeight(self.frame);
    CGFloat w = CGRectGetWidth(self.frame);
    self.weeks.frame = CGRectMake(0, 0, w, 45);
    CGFloat dayView_w = CGRectGetWidth(self.weeks.frame);
    CGFloat dayView_h = h - CGRectGetHeight(self.weeks.frame);
    self.dayView.frame = CGRectMake(0, CGRectGetMaxY(self.weeks.frame), dayView_w, dayView_h);
}


- (WeeksView *)weeks {
    if (!_weeks) {
        _weeks = [[WeeksView alloc]initWithFrame:CGRectZero];
        _weeks.backgroundColor = CalendarColor;
    }
    return _weeks;
}
- (XLMonthCollectionView *)dayView{
    if (!_dayView) {
        _dayView = [[XLMonthCollectionView alloc]initWithFrame:CGRectZero];
        _dayView.backgroundColor = [UIColor whiteColor];
    }
    return _dayView;
}
@end
