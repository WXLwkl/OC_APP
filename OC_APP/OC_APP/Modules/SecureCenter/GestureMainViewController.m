//
//  GestureMainViewController.m
//  shoushi
//
//  Created by xingl on 2017/7/18.
//  Copyright © 2017年 xingl. All rights reserved.
//

#import "GestureMainViewController.h"
#import "SecureManager.h"
#import "SwitchCell.h"

#import "GestureViewController.h"

@interface GestureMainViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation GestureMainViewController
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SwitchCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SwitchCell class])];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"手势设置";
    
    [self.view addSubview:self.tableView];
    
    [self reloadGestureData];
}
// 刷新手势密码开启状态，对应的显示内容
- (void)reloadGestureData {
    
    BOOL isOpen = [SecureManager gestureOpenStatus];
    NSLog(@"isOpen====状态是%@==",(isOpen ? @"开启" : @"关闭"));
    if (isOpen) {
        self.dataArray = @[@[@"手势密码", @"显示手势密码轨迹"], @[@"修改手势密码"]];
        return;
    }
    self.dataArray = @[@[@"手势密码"]];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *arr = self.dataArray[section];
    return arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        SwitchCell *switchCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SwitchCell class]) forIndexPath:indexPath];

        NSString *title = self.dataArray[indexPath.section][indexPath.row];
        
        BOOL isOn = indexPath.row == 0 ? [SecureManager gestureOpenStatus] : [SecureManager gestureShowStatus];
        WeakSelf(self);
        [switchCell setupSwitchOn:isOn switchBlock:^(UISwitch *switchButton) {
            StrongSelf(self);
            if (indexPath.row == 0) {
                [self gestureOpenSwitchAction:switchButton];
                return ;
            }
            [self gestureShowSwitchAction:switchButton];
        }];
        switchCell.title = title;
        cell = switchCell;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 1) {
        UITableViewCell *normalCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
        normalCell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
        cell = normalCell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        // 修改手势密码的处理
        GestureViewController *controller = [[GestureViewController alloc] init];
        controller.gestureSetType = GestureSetTypeChange;
//        校验密码的时候可以选择是否显示手势轨迹
//        controller.gestureSetType = GestureSetTypeVerify;
//        [SecureManager openGestureShow:NO];
        [controller gestureSetComplete:^(BOOL success) {
            
            
            if (success) {
                NSLog(@"修改手势密码成功");
            }
        }];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
//缩短header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

// 开启/关闭手势密码
- (void)gestureOpenSwitchAction:(UISwitch *)sender {
    
    BOOL isOpen = [SecureManager gestureOpenStatus];
    // isOpen是YES代表之前是开启的，现在要关闭，setType为GestureSetTypeVerify;
    // isOpen是NO代表之前是关闭的，现在要开启，setType为GestureSetTypeSetting;
    GestureSetType  setType = isOpen ? GestureSetTypeVerify : GestureSetTypeSetting;
    
    GestureViewController *controller = [[GestureViewController alloc] init];
    controller.gestureSetType = setType;
    WeakSelf(self);
    [controller gestureSetComplete:^(BOOL success) {
        StrongSelf(self);
        [self showSwitchOnStatus:sender handleSuccess:success];
    }];
    [self.navigationController pushViewController:controller animated:YES];
}
/// handleResult 手势操作结果 success是操作结果yes成功，no 失败
- (void)showSwitchOnStatus:(UISwitch *)sender handleSuccess:(BOOL)success {
    
    BOOL isOpen = [SecureManager gestureOpenStatus];
    
    
    if (!success) {
        // 不成功，依旧为当前的值
        [sender setOn:isOpen animated:YES];
        return;
    }
    
    // isOpen是YES代表之前是开启的，现在关闭，nowOpenStatus为NO; isOpen是NO代表之前是关闭的，现在开启，nowOpenStatus为YES;
    BOOL nowOpenStatus = isOpen ? NO : YES;
    [SecureManager openGesture:nowOpenStatus];
    [sender setOn:nowOpenStatus animated:YES];
    
    
    [self reloadGestureData];
    
    if (!isOpen) {
        NSLog(@"手势密码已设置");
    }

    [self.tableView reloadData];
}

// 显示/隐藏手势密码轨迹
- (void)gestureShowSwitchAction:(UISwitch *)sender {
    BOOL  show = [SecureManager gestureShowStatus];
    // 直接取反就行
    [SecureManager openGestureShow:!show];
    [sender setOn:!show animated:YES];
}

@end
