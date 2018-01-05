//
//  ReduceTimeViewController.m
//  OC_APP
//
//  Created by xingl on 2017/8/21.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "ReduceTimeViewController.h"
#import "ReduceTimeModel.h"
#import "ReduceTimeCell.h"

@interface ReduceTimeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataMutableArray;
//所有剩余时间数组
@property (nonatomic, strong) NSMutableArray *totalLastTime;

//服务器的当前时间，正式项目请求服务端获取，此实例以本地为例
@property(nonatomic)NSDate *server_DateTime;

@property(nonatomic)NSTimer *timer;

@end

@implementation ReduceTimeViewController



#pragma mark - LifeCycle Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"列表倒计时";
    [self xl_setNavBackItem];
    
    if (!self.totalLastTime) {
        self.totalLastTime=[[NSMutableArray alloc]init];
    }
    self.server_DateTime = [NSDate new];
    
    [self initSubviews];
    [self loadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSubviews {
    [self.view addSubview:self.tableView];
    
}
- (void)loadData {
    
    
//    加载列表数据 真实请求服务端接口获取 **注意：时间也是服务端的时间
    
    for (int i = 0; i < 20; i ++) {
        ReduceTimeModel *model = [[ReduceTimeModel alloc] init];
        model.name = [NSString stringWithFormat:@"产品名称：%d",i];
        model.imageName = @"userHead";
        model.date = [self dateWithMinutesFromNow:i];
        
        //此处时间要从服务端获取，倒计时都要以服务端时间为准
        NSDate *start_date = model.date;
        //NSDate *server_date = ;

        
        NSDictionary *dic = @{@"indexPath":[NSString stringWithFormat:@"%i",i],
                              @"lastTime": [NSNumber numberWithInteger:[self getCurrentSecondsWithServerDate:self.server_DateTime start_date:start_date]]};
        
        
        [self.totalLastTime addObject:dic];
        
        [self.dataMutableArray addObject:model];
    }
    [self startTimer];
    [self.tableView reloadData];
}
//倒计时事件
- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshLessTime) userInfo:@"" repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:UITrackingRunLoopMode];
}
- (void)refreshLessTime {
    NSInteger time;
    for (int i = 0; i < self.totalLastTime.count; i++) {
        
        
        
        time = [[[self.totalLastTime objectAtIndex:i] objectForKey:@"lastTime"] integerValue];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[[[self.totalLastTime objectAtIndex:i] objectForKey:@"indexPath"] integerValue] inSection:0];
        
        
        ReduceTimeCell *cell = (ReduceTimeCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if (time == 0) {
            --time;
            [cell configCellState:ReduceTimeStateEnd currentTime:@""];
        } else if(time > 0) {
            [cell configCellState:ReduceTimeStateIng currentTime:[self lessSecondToDay:--time]];
        }
        NSDictionary *dic = @{@"indexPath": [NSString stringWithFormat:@"%ld",(long)indexPath.row],@"lastTime": [NSString stringWithFormat:@"%li",(long)time]};
        [self.totalLastTime replaceObjectAtIndex:i withObject:dic];
    }
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataMutableArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReduceTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ReduceTimeCell class]) forIndexPath:indexPath];
    ReduceTimeModel *model = self.dataMutableArray[indexPath.row];
    [cell configCellWithImage:model.imageName name:model.name];
    
    NSInteger seconders = [[[self.totalLastTime objectAtIndex:indexPath.row] objectForKey:@"lastTime"] integerValue];
    
    
    [cell configCellState:seconders > 0 ? ReduceTimeStateIng:ReduceTimeStateEnd currentTime:[self lessSecondToDay:seconders]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark - event response
//所有button gestureRecongnizer的响应事件


#pragma mark - Private Menthods
//正常情况下viewcontroller里面一般是不会存在private menthods的，
//这个private menthods一般用于日期换算，图片裁剪的这种小功能

- (NSDate *)dateWithMinutesFromNow:(NSInteger)dMinutes {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + 60 * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
//两时间比较 获取总秒数 用于倒计时
-(NSInteger)getCurrentSecondsWithServerDate:(NSDate *)server_date start_date:(NSDate *)start_date {
    
    NSInteger seconds=-1;
    seconds = [start_date timeIntervalSinceDate:server_date];
    
    return seconds;
}
- (NSString *)lessSecondToDay:(NSUInteger)seconds {
    NSUInteger hour = (NSUInteger)(seconds%(24*3600))/3600;
    NSUInteger min  = (NSUInteger)(seconds%(3600))/60;
    NSUInteger second = (NSUInteger)(seconds%60);
    
    NSString *time = [NSString stringWithFormat:@" %02lu:%02lu:%02lu",(unsigned long)hour,(unsigned long)min,(unsigned long)second];
    return time;
}


#pragma mark - getter && setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//        _tableView.showsVerticalScrollIndicator   = NO;
//        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.dataSource                     = self;
        _tableView.delegate                       = self;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
            [_tableView registerClass:[ReduceTimeCell class] forCellReuseIdentifier:NSStringFromClass([ReduceTimeCell class])];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _tableView;
}
- (NSMutableArray *)dataMutableArray {
    if (!_dataMutableArray) {
        _dataMutableArray = [NSMutableArray array];
    }
    return _dataMutableArray;
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
