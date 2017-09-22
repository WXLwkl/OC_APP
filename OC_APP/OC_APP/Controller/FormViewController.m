//
//  FormViewController.m
//  OC_APP
//
//  Created by xingl on 2017/8/21.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "FormViewController.h"
#import "TitleAndPromptCell.h"
#import "MultitextCell.h"

#import "UUInputAccessoryView.h"

#import "AddressPickerView.h"

@interface FormViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic,copy)NSString *myUserName,*mySex,*myBirthday,*myHometown,*myAddress;

@end

@implementation FormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
    }

    
    self.navigationItem.title = @"常见表单行类型";
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
    
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:@"tabBar_publish_icon"];
        cell.textLabel.text = @"系统设置";
        return cell;
    } else if (indexPath.row == 1){
        TitleAndPromptCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TitleAndPromptCell class]) forIndexPath:indexPath];
        [cell setCellDataKey:@"姓名" curValue:self.myUserName blankValue:@"请输入姓名" isShowLine:NO cellType:TitleAndPromptCellTypeInput];
        return cell;
    } else if (indexPath.row == 2){
        TitleAndPromptCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TitleAndPromptCell class]) forIndexPath:indexPath];
        [cell setCellDataKey:@"性别" curValue:self.mySex blankValue:@"请选择性别" isShowLine:NO cellType:TitleAndPromptCellTypeSelect];
        return cell;
    } else if (indexPath.row == 3){
        TitleAndPromptCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TitleAndPromptCell class]) forIndexPath:indexPath];
        [cell setCellDataKey:@"生日" curValue:self.myBirthday blankValue:@"请选择出生日期" isShowLine:NO cellType:TitleAndPromptCellTypeSelect];
        return cell;
    } else if (indexPath.row == 4){
        TitleAndPromptCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TitleAndPromptCell class]) forIndexPath:indexPath];
        [cell setCellDataKey:@"出生地" curValue:self.myHometown blankValue:@"请选择出生地" isShowLine:NO cellType:TitleAndPromptCellTypeSelect];
        return cell;
    } else {
        WeakSelf(self);
        MultitextCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MultitextCell class]) forIndexPath:indexPath];
        [cell setCellDataKey:@"家庭地址" textValue:self.myAddress blankValue:@"请出入家庭地址" showLine:NO];
        cell.textValueChangedBlock = ^(NSString *text) {
            
            StrongSelf(self);
            self.myAddress = text;
        };
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    __weak typeof(self)weakSelf = self;
    if (indexPath.row == 0) {
        [MBProgressHUD showError:@"跳转失败" ToView:self.view];
    } else if (indexPath.row == 1) {
        UIKeyboardType type = UIKeyboardTypeDefault;
        NSString *content = self.myUserName;
        [UUInputAccessoryView showKeyboardType:type
                                       content:content
                                         Block:^(NSString *contentStr) {
             if (contentStr.length == 0) return ;
             weakSelf.myUserName = contentStr;
             [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
         }];
    } else if (indexPath.row == 2) {
        
    } else if (indexPath.row == 3) {
        
    } else if (indexPath.row == 4) {
        AddressPickerView *_myAddressPickerView = [AddressPickerView shareInstance];
        [_myAddressPickerView showAddressPickView];
        [self.view addSubview:_myAddressPickerView];
        
        _myAddressPickerView.block = ^(NSString *province,NSString *city,NSString *district) {
            
            self.myHometown = [NSString stringWithFormat:@"%@ %@ %@",province,city,district];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 5 ? [MultitextCell cellHeight] : 44;
}
//然后在重写willDisplayCell方法
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
}
#pragma mark - getter && setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        //        _tableView.showsVerticalScrollIndicator   = NO;
        //        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.dataSource                     = self;
        _tableView.delegate                       = self;
        _tableView.tableFooterView=[UIView new];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        [_tableView registerClass:[TitleAndPromptCell class] forCellReuseIdentifier:NSStringFromClass([TitleAndPromptCell class])];
        [_tableView registerClass:[MultitextCell class] forCellReuseIdentifier:NSStringFromClass([MultitextCell class])];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _tableView;
}

@end
