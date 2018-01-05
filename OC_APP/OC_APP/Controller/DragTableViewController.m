//
//  DragTableViewController.m
//  OC_APP
//
//  Created by xingl on 2017/11/23.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "DragTableViewController.h"


@interface DragTableViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *myDataList;
@property (nonatomic, strong) NSMutableArray *touchPoints;
@end

@implementation DragTableViewController


- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
        [_tableView addGestureRecognizer:longPress];
    }
    return _tableView;
}
- (NSArray *)myDataList {
    
    if (!_myDataList) {
        _myDataList=[@[@"产品类型1",@"产品类型2",@"产品类型3",@"产品类型4",@"产品类型5",@"产品类型6",@"产品类型7",@"产品类型8",@"产品类型9",@"产品类型10",@"产品类型11"] mutableCopy];
    }
    return _myDataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"长按列表行拖动效果";
    [self xl_setNavBackItem];
    
    [self initSubviews];
    
}

- (void)initSubviews {
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.myDataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.accessoryType    = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.myDataList[indexPath.row];
    cell.backgroundColor = [UIColor xl_randomColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //code...
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}



- (void)longPressGestureRecognized:(UILongPressGestureRecognizer *)longPress {
    
    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    static UIView *snapshot = nil;
    static NSIndexPath *sourceIndexPath = nil;
    
    UIGestureRecognizerState state = longPress.state;
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            //判断是不是按在了cell上
            if (indexPath) {
                sourceIndexPath = indexPath;
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                //为拖动的cell添加一个快照
                snapshot = [self customSnapshoFromView:cell];
                //添加快照至tableview中
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableView addSubview:snapshot];
                //按下的瞬间执行动画
                [UIView animateWithDuration:0.25 animations:^{
                    center.y = location.y;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                } completion:^(BOOL finished) {
                    cell.hidden = YES;
                }];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            // 这里保持数组里面只有最新的两次触摸点的坐标
            [self.touchPoints addObject:[NSValue valueWithCGPoint:location]];
            if (self.touchPoints.count > 2) {
                [self.touchPoints removeObjectAtIndex:0];
            }
            CGPoint center = snapshot.center;
            //快照随触摸点y值移动(当然也可以根据触摸点的y轴移动量移动)
            center.y = location.y;
            // 快照随触摸点x值改变量移动
            CGPoint Ppoint = [[self.touchPoints firstObject] CGPointValue];
            CGPoint Npoint = [[self.touchPoints lastObject] CGPointValue];
            CGFloat moveX = Npoint.x - Ppoint.x;
            center.x += moveX;
            snapshot.center = center;
            NSLog(@"%@---%f----%@", self.touchPoints, moveX, NSStringFromCGPoint(center));
            NSLog(@"%@", NSStringFromCGRect(snapshot.frame));
            //是否移动了
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                //更新数组中的内容
                [self.myDataList exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                //把cell移动到指定行
                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                //存储改变后indexPath的值，以便下次比较
                sourceIndexPath = indexPath;
            }
            break;
        }
            //长按手势取消状态
        default: {
            //清除操作
            //清空数组，非常重要，不然会发生坐标突变
            [self.touchPoints removeAllObjects];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            // 将快照恢复到初始状态
            [UIView animateWithDuration:0.25 animations:^{
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
        }
            break;
    }
}

- (UIView *)customSnapshoFromView:(UIView *)inputView {
    //用cell的图层生成UIImage,方便一会显示
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //自定义这个快照的样子（下面的一些参数可以自己随意设置）
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    return snapshot;
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
