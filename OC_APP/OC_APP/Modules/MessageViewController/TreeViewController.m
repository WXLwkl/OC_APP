//
//  TreeViewController.m
//  OC_APP
//
//  Created by xingl on 2017/8/15.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "TreeViewController.h"
#import "TreeCellModel.h"

#import "TestViewController.h"

@interface TreeViewController ()

@property(nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation TreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self xl_setNavBackItem];
    
    self.navigationItem.title = @"多级cell表";
    
    [self initSubviews];
    [self loadData];
}

- (void)initSubviews {
    
    self.tableView.tableFooterView = [UIView new];
    
}
- (void)loadData {
    NSArray *netData = @[
                         @{
                             @"text":@"河北省",
                             @"level":@"0",
                             @"submodels":@[
                                     @{
                                         @"text":@"衡水市",
                                         @"level":@"1",
                                         @"submodels":@[
                                                 @{
                                                     @"text":@"阜城县",
                                                     @"level":@"2",
                                                     @"submodels":@[
                                                             @{
                                                                 @"text":@"大白乡",
                                                                 @"level":@"3",
                                                                 },
                                                             @{
                                                                 @"text":@"建桥乡",
                                                                 @"level":@"3",
                                                                 },
                                                             @{
                                                                 @"text":@"古城镇",
                                                                 @"level":@"3",
                                                                 }
                                                             ]
                                                     },
                                                 @{
                                                     @"text":@"武邑县",
                                                     @"level":@"2",
                                                     },
                                                 @{
                                                     @"text":@"景县",
                                                     @"level":@"2",
                                                     }
                                                 ]
                                         },
                                     @{
                                         @"text":@"廊坊市",
                                         @"level":@"1",
                                         @"submodels":@[
                                                 @{
                                                     @"text":@"固安县",
                                                     @"level":@"2",
                                                     },
                                                 @{
                                                     @"text":@"三河市",
                                                     @"level":@"2",
                                                     },
                                                 @{
                                                     @"text":@"霸州市",
                                                     @"level":@"2",
                                                     }
                                                 ]
                                         }
                                     ]
                             },
                         @{
                             @"text":@"山东省",
                             @"level":@"0",
                             @"submodels":@[
                                     @{
                                         @"text":@"德州市",
                                         @"level":@"1",
                                         @"submodels":@[
                                                 @{
                                                     @"text":@"临邑县",
                                                     @"level":@"2",
                                                     },
                                                 @{
                                                     @"text":@"齐河县",
                                                     @"level":@"2",
                                                     },
                                                 @{
                                                     @"text":@"平原县",
                                                     @"level":@"2",
                                                     }
                                                 ]
                                         },
                                     @{
                                         @"text":@"烟台市",
                                         @"level":@"1",
                                         @"submodels":@[
                                                 @{
                                                     @"text":@"蓬莱市",
                                                     @"level":@"2",
                                                     },
                                                 @{
                                                     @"text":@"招远市",
                                                     @"level":@"2",
                                                     },
                                                 @{
                                                     @"text":@"海阳市",
                                                     @"level":@"2",
                                                     }
                                                 ]
                                         }
                                     ]
                             },
                         ];
    
    self.dataArr = [NSMutableArray new];
    
    for (int i = 0; i < netData.count; i++) {
        TreeCellModel *model = [TreeCellModel modelWithDic:(NSDictionary *)netData[i]];
        [self.dataArr addObject:model];
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"id";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    // cell ...
    TreeCellModel *model = self.dataArr[indexPath.row];
    cell.textLabel.text = model.text;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TreeCellModel *model = self.dataArr[indexPath.row];
    
    [tableView beginUpdates];
    if (model.belowCount == 0) {
        //Data
        NSArray *submodels = [model open];
        NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:((NSRange){indexPath.row + 1, submodels.count})];
        [self.dataArr insertObjects:submodels atIndexes:indexes];
        
        if (XL_isEmptyArray(submodels)){
            
            [tableView endUpdates];
//最后一级的cell的点击事件
            
            TestViewController *vc = [TestViewController new];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
            
            return;
        }
        
        //Rows
        NSMutableArray *indexPaths = [NSMutableArray new];
        for (int i = 0; i < submodels.count; i++) {
            NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1 + i) inSection:indexPath.section];
            [indexPaths addObject:insertIndexPath];
        }
        [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:(UITableViewRowAnimationFade)];
    } else {
        //Data
        NSArray *submodels = [self.dataArr subarrayWithRange:((NSRange){indexPath.row + 1, model.belowCount})];
        [model closeWithSubModels:submodels];
        [self.dataArr removeObjectsInArray:submodels];
        //Rows
        NSMutableArray *indexPaths = [NSMutableArray new];
        for (int i = 0; i < submodels.count; i++) {
            NSIndexPath *removeIndexpath = [NSIndexPath indexPathForRow:(indexPath.row + 1 + i) inSection:indexPath.section];
            [indexPaths addObject:removeIndexpath];
        }
        [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:(UITableViewRowAnimationFade)];
    }
    [tableView endUpdates];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    TreeCellModel *foldCellModel = self.dataArr[indexPath.row];
    return foldCellModel.level.intValue;
}

@end
