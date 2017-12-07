//
//  BlankPageViewController.m
//  OC_APP
//
//  Created by xingl on 2017/11/21.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "BlankPageViewController.h"

@interface BlankPageViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray             *dataArray;
@property (nonatomic, strong) UITableView         *myTableView;

@end

@implementation BlankPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"空白页展示";
    [self xl_setNavBackItem];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem xl_itemTitle:@"出错了" color:[UIColor whiteColor] target:self sel:@selector(rightAvtion:)];
    
    if (!self.dataArray) {
        self.dataArray = [[NSArray alloc] init];
    }
    
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0.5, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.showsHorizontalScrollIndicator = NO;
        _myTableView.tableFooterView = [UIView new];
        
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        [self.view addSubview:_myTableView];
        WeakSelf(self);
        _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 模拟加载服务端数据
            StrongSelf(self);
            [self loadMyTableData];
            
        }];
        
        [_myTableView.mj_header beginRefreshing];
    }
}

- (void)rightAvtion:(UIBarButtonItem *)sender {
    
    __weak typeof(self)weakSelf = self;
    [self.view configBlankPage:EaseBlankPageTypeProject hasData:(self.dataArray.count>0) hasError:YES reloadButtonBlock:^(id sender) {
        [MBProgressHUD showAutoMessage:@"重新加载的数据" ToView:self.view];
        [weakSelf.myTableView.mj_header beginRefreshing];
    }];
}


- (void)loadMyTableData {
    //请求服务端接口并返回数据
    WeakSelf(self);
    //成功时
    [self.myTableView reloadData];
    [self.myTableView.mj_header endRefreshing];
    
    //增加无数据展现
    
    [self.view configBlankPage:EaseBlankPageTypeView hasData:self.dataArray.count hasError:(self.dataArray.count>0) reloadButtonBlock:^(id sender) {
        [MBProgressHUD showAutoMessage:@"重新加载的数据" ToView:weakself.view];
        [weakself.myTableView.mj_header beginRefreshing];
    }];
}
#pragma mark UITableViewDataSource, UITableViewDelegate相关内容

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.accessoryType    = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text   = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
