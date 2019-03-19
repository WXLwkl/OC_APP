//
//  ProxyManagerViewController.m
//  OC_APP
//
//  Created by xingl on 2019/2/20.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "ProxyManagerViewController.h"
#import "XLProxyManager.h"
#import "TableViewDelegateConfig.h"
#import "TableViewDatasourceConfig.h"

@interface ProxyManagerViewController ()

@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) XLProxyManager *proxyManager;

@property (nonatomic, strong) TableViewDelegateConfig *delegateConfig;
@property (nonatomic, strong) TableViewDatasourceConfig *datasourceConfig;

@end

@implementation ProxyManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"方法转发";
    [self.view addSubview:self.myTableView];
}

- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        if (@available(iOS 11.0, *)) {
            self.myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _myTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _proxyManager = [[XLProxyManager alloc] init];
        _delegateConfig = [[TableViewDelegateConfig alloc] init];
        _datasourceConfig = [TableViewDatasourceConfig new];
        
        [_proxyManager addTarget:_delegateConfig];
        [_proxyManager addTarget:_datasourceConfig];
        
        _myTableView.delegate = (id<UITableViewDelegate>)_proxyManager;
        _myTableView.dataSource = (id<UITableViewDataSource>)_proxyManager;
        
        _myTableView.tableFooterView = [UIView new];
    }
    return _myTableView;
}

@end
