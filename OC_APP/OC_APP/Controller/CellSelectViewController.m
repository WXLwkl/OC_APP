//
//  CellSelectViewController.m
//  OC_APP
//
//  Created by xingl on 2017/12/7.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "CellSelectViewController.h"

@interface CellSelectViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView       *tableView;
@property (strong, nonatomic) NSMutableArray    *listData;
@property (strong, nonatomic) UIView            *editingView;

@end

@implementation CellSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self Adds];
    [self initUI];
}
#pragma mark - UI
- (void)initUI{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarItemClick:)];
    self.navigationItem.rightBarButtonItem = item;
}
- (void)rightBarItemClick:(UIBarButtonItem *)item{

    if ([item.title isEqualToString:@"编辑"]) {
        if (self.listData.count == 0) {
            return;
        }
        item.title = @"取消";
        [self.tableView setEditing:YES animated:YES];
        [self showEitingView:YES];
    }else{
        item.title = @"编辑";
        [self.tableView setEditing:NO animated:YES];

        [self showEitingView:NO];
    }

}

- (void)showEitingView:(BOOL)isShow{
    
    [self.editingView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(isShow?0:45);
    }];

    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];

}




- (void)Adds {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.editingView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.editingView.mas_top);
    }];

    [self.editingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@45);
        make.bottom.equalTo(self.view).offset(45);
    }];
}
- (void)initData{
    self.listData = [NSMutableArray array];

    [self.listData addObjectsFromArray:@[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"]];
}
#pragma mark - lizyLoad
- (UIView *)editingView {
    if (!_editingView) {
        _editingView = [[UIView alloc] init];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor redColor];
        [button setTitle:@"删除" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_editingView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(_editingView);
            make.width.equalTo(_editingView).multipliedBy(0.5);
        }];

        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor darkGrayColor];
        [button setTitle:@"全选" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_editingView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(_editingView);
            make.width.equalTo(_editingView).multipliedBy(0.5);
        }];
    }
    return _editingView;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource      = self;
        _tableView.delegate        = self;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    }
    return _tableView;
}
- (void)buttonClick:(UIButton *)sender {

    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"删除"]) {
        NSMutableIndexSet *indexSets = [[NSMutableIndexSet alloc] init];
        [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [indexSets addIndex:obj.row];
        }];
        [self.listData removeObjectsAtIndexes:indexSets];
        [self.tableView deleteRowsAtIndexPaths:[self.tableView indexPathsForSelectedRows] withRowAnimation:UITableViewRowAnimationFade];
        /** 数据清空情况下取消编辑状态*/
        if (self.listData.count == 0) {
            self.navigationItem.rightBarButtonItem.title = @"编辑";
            [self.tableView setEditing:NO animated:YES];
            [self showEitingView:NO];
        }
    } else if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"全选"]) {

        [self.listData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }];
        [sender setTitle:@"全不选" forState:UIControlStateNormal];
    } else if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"全不选"]) {

        //        [self.tableView reloadData];

        [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.tableView deselectRowAtIndexPath:obj animated:NO];
        }];
        [sender setTitle:@"全选" forState:UIControlStateNormal];
    }
}



#pragma mark - UITabelViewDelegate And DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    cell.textLabel.text = self.listData[indexPath.row];

    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isEditing) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
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
