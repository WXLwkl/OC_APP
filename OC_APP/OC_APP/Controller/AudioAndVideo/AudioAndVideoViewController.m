//
//  AudioAndVideoViewController.m
//  OC_APP
//
//  Created by xingl on 2018/6/21.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "AudioAndVideoViewController.h"
#import "Video1ViewController.h"
#import "Video2ViewController.h"
#import "WeChatVideoViewController.h"
#import "WXVideoViewController.h"
#import "VideoPlayerViewController.h"

@interface AudioAndVideoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;


@end

@implementation AudioAndVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"音视频";
    [self xl_setNavBackItem];
    
    _dataArray = @[@[@"等待开发"],@[@"拍视频1",@"拍视频2",@"微信视频1",@"微信视频2"],@[@"视频播放"]];
    [self.view addSubview:self.tableView];
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
    static NSString *cellIdentifier = @"id";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    // cell ...
    //    cell.textLabel.text = [@(indexPath.row) stringValue];
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

/*设置标题头的名称*/
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0)
        return @"音频";
    else if (section == 1)
        return @"视频拍摄";
    else
        return @"视频播放";
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        //音频部分
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            Video1ViewController *vc = [Video1ViewController new];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
        } else if (indexPath.row == 1) {
            Video2ViewController *vc = [Video2ViewController new];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
        } else if (indexPath.row == 2) {
            WeChatVideoViewController *vc = [WeChatVideoViewController new];
            [self presentViewController:vc animated:YES completion:nil];
        } else if (indexPath.row == 3) {
            WXVideoViewController *vc = [WXVideoViewController new];
            [self presentViewController:vc animated:YES completion:nil];
        }
    } else {
        if (indexPath.row == 0) {
            VideoPlayerViewController *vc = [VideoPlayerViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
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

@end
