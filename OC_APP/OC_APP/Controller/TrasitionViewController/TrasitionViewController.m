//
//  TrasitionViewController.m
//  OC_APP
//
//  Created by xingl on 2019/3/1.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "TrasitionViewController.h"

@interface TrasitionViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, copy) NSArray *viewControllers;

@end

@implementation TrasitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"转场动画";
    [self.view addSubview:self.tableView];
}

- (NSArray *)data {
    if (!_data) {
        _data = [@[@"弹性pop",@"翻页效果",@"小圆点扩散",@"图片转场", @"Pushpop转场",@"Nav的开门动画", @"Present开关门动画"] copy];
    }
    return _data;
}
- (NSArray *)viewControllers{
    if (!_viewControllers) {
        _viewControllers = [@[@"Pop11ViewController", @"PageFromViewController", @"CircleSpreadController", @"ImageTransitionViewController", @"PushPopTransitionViewController", @"NavOpenDoorViewController",@"PerOpenDoorViewController"] copy];
    }
    return _viewControllers;
}

#pragma mark - <UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.imageView.image = [UIImage imageNamed:@"piao"];
    cell.textLabel.text = _data[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    UIViewController *vc = [[NSClassFromString(self.viewControllers[indexPath.row]) alloc] init];
    
    if (indexPath.row == 3) {
        self.currentIndexPath = indexPath;
        [self presentViewController:vc animated:true completion:nil];
    } else if (indexPath.row == 4) {
        self.currentIndexPath = indexPath;
        self.navigationController.delegate = vc;
        [self.navigationController pushViewController:vc animated:true];
    }  else if (indexPath.row == 5) {
        self.currentIndexPath = indexPath;
        self.navigationController.delegate = vc;
        [self.navigationController pushViewController:vc animated:true];
    } else {
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - ============ sssss ===============
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style: UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        if (@available(iOS 11.0, *)) {
//            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        } else {
//            self.automaticallyAdjustsScrollViewInsets = NO;
//        }
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}

@end
