//
//  XLMonthCollectionView.m
//  OC_APP
//
//  Created by xingl on 2017/7/25.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "XLMonthCollectionView.h"
#import "CalendarModel.h"
#import "CalendaDaysCell.h"
#import "NSDate+Decomposer.h"
#import "MonthOpeartion.h"

@interface XLMonthCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic ,strong)UICollectionView *collection;
@property (nonatomic ,strong)NSMutableArray *showMonths;
@property (nonatomic ,strong)NSArray *days;
@property (nonatomic ,strong)NSArray *daysArray;


@property (nonatomic ,strong)UILabel *monthLabel;
@property (nonatomic ,assign)NSInteger maxContainer;

@property (nonatomic ,copy)NSString *yearLabel;

@end

@implementation XLMonthCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.collection];
    [self addSubview:self.monthLabel];
    self.collection.delegate = self;
    self.collection.dataSource = self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat w = CGRectGetWidth(self.frame);
    CGFloat h = CGRectGetHeight(self.frame);
    self.collection.frame = CGRectMake(0, 0, w, h);
    self.monthLabel.frame = self.bounds;
    
}
- (void)calendarContainerWhereMonth:(NSInteger)currentTag month:(void (^)(MonthModel *))currentMonth {
    WeakSelf(self);
    [[MonthOpeartion defaultMonthOpeartion] calendarContainerWithNearByMonths:currentTag daysOfMonth:^(NSArray *daysArray, MonthModel *month) {
        if (daysArray.count > 0) {
            weakself.daysArray = daysArray;
            
            weakself.monthLabel.text = [NSString stringWithFormat:@"%ld", (long)month.month];
            currentMonth(month);
            [weakself.collection reloadData];
        }
    }];
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return self.daysArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    CalendaDaysCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    DayModel *dayModel = self.daysArray[indexPath.row];
    cell.dayModel = dayModel;
    [cell signCurrentDay:dayModel];
    cell.showChinaCalendar = self.showChineseCalendar;
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectDateBlock) {
        MonthOpeartion *opeartion = [MonthOpeartion defaultMonthOpeartion];
        
        CalendaDaysCell *cell = (CalendaDaysCell *)[collectionView cellForItemAtIndexPath:indexPath];
        self.selectDateBlock(opeartion.currentYear, opeartion.currentMonth, cell.dayModel.day);
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger weeks = self.daysArray.count/7;
    CGFloat w = CGRectGetWidth(collectionView.bounds);
    CGFloat h = CGRectGetHeight(collectionView.bounds);
    return CGSizeMake(w/7.0, h/weeks);
    
}


#pragma mark - lazy
- (UICollectionView *)collection{
    if (!_collection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0.0;
        layout.minimumInteritemSpacing = 0.0;
        
        _collection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collection.backgroundColor = [UIColor clearColor];
        [_collection registerClass:NSClassFromString(@"CalendaDaysCell") forCellWithReuseIdentifier:@"cell"];
    }
    return _collection;
}

- (NSMutableArray *)showMonths{
    if (!_showMonths) {
        _showMonths = [NSMutableArray arrayWithCapacity:2];
    }
    return _showMonths;
}


- (UILabel *)monthLabel{
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _monthLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:200/2550.f];
        if ([[UIDevice xl_systemVersion] floatValue] < 8.2) {
            
            _monthLabel.font = [UIFont boldSystemFontOfSize:150.0f];
        } else {
            _monthLabel.font = [UIFont systemFontOfSize:150.0f weight:120.0f];
        }
        
        _monthLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _monthLabel;
}


@end
