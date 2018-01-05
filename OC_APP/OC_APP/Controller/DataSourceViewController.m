//
//  DataSourceViewController.m
//  OC_APP
//
//  Created by xingl on 2018/1/4.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "DataSourceViewController.h"
#import "ArrayDataSource.h"

@interface DataSourceViewController ()<UITableViewDelegate>

@property (nonatomic,strong) NSArray             *dataArray;
@property (nonatomic,strong) UITableView         *myTableView;
@property (nonatomic,strong) ArrayDataSource     *photosArrayDataSource;

@end

@implementation DataSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"TableViewDataSource提取";

    if (!self.dataArray) {
        self.dataArray=@[@"照片一",@"照片二",@"照片三",@"照片四",@"照片五"];
    }

    //初始化表格
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _myTableView.showsVerticalScrollIndicator   = NO;
        _myTableView.showsHorizontalScrollIndicator = NO;
        _myTableView.delegate                       = self;

        _myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero]
        ;
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        [self.view addSubview:_myTableView];
    }

    [self setupTableDataSource];

}

- (void)setupTableDataSource {
    TableViewCellConfigureBlock config = ^(UITableViewCell *cell, NSString *name) {
        cell.textLabel.text = name;
    };
    self.photosArrayDataSource = [[ArrayDataSource alloc] initWithItems:self.dataArray cellIdentifier:NSStringFromClass([UITableViewCell class]) configureCellBlock:config];
    self.myTableView.dataSource = self.photosArrayDataSource;
}

#pragma mark UITableViewDelegate内容
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSLog(@"当前的名称：%@",self.dataArray[indexPath.row]);
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
