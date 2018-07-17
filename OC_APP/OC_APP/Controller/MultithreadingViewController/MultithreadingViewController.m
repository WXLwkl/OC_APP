//
//  MultithreadingViewController.m
//  OC_APP
//
//  Created by xingl on 2018/6/11.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "MultithreadingViewController.h"
#import "ThreadViewController.h"
#import "GCDViewController.h"
#import "OperationViewController.h"

@interface MultithreadingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation MultithreadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubviews];
    [self loadData];
}

#pragma mark - notification

#pragma mark - action

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"id";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    // cell ...
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RootViewController *vc;
    switch (indexPath.row) {
        case 0:
            vc = [ThreadViewController new];
            break;
        case 1:
            vc = [GCDViewController new];
            break;
        case 2:
            vc = [OperationViewController new];
            break;
        default:
            break;
    }
    vc.navigationItem.title = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


#pragma mark - UI
- (void)initSubviews {
    self.navigationItem.title = @"多线程";
    [self xl_setNavBackItem];
    [self.view addSubview:self.tableView];
}

- (void)loadData {
    self.dataArray = @[
                       @"pthread、NSThread",
                       @"GCD",
                       @"NSOperation、NSOperationQueue"
                       ];
}

#pragma mark - setter & getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style: UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}
@end
