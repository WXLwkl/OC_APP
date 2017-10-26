//
//  LeftViewController.m
//  ViewControllerTransition
//
//  Created by 陈旺 on 2017/7/10.
//  Copyright © 2017年 chavez. All rights reserved.
//

#define kSCREENWIDTH [UIScreen mainScreen].bounds.size.width

#import "LeftViewController.h"

#import "UIViewController+LateralSlide.h"

#import "NextTableViewCell.h"

#import "NextViewController.h"

@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic,strong) NSArray *titleArray;

@end

@implementation LeftViewController


//#define ICONS  @[@"calendar",@"saoyisao",@"delete",@"pay",@"delete",@"delete"]
- (NSArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = @[@"calendar",@"saoyisao",@"delete",@"saoyisao",@"calendar",@"calendar"];
    }
    return _imageArray;
}

- (NSArray *)titleArray{
    if (_titleArray == nil) {
        _titleArray = @[@"了解会员特权",@"钱包",@"个性装扮",@"我的收藏",@"我的相册",@"我的文件"];
    }
    return _titleArray;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupHeader];
    
    [self setupTableView];
    
//    [self test];
}

- (void)test {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    view.frame = CGRectMake(kSCREENWIDTH * 0.75 - 10, 0, 8, 200);
    [self.view addSubview:view];
    [self.view bringSubviewToFront:view];
}

- (void)setupTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 300, kSCREENWIDTH * 0.75, CGRectGetHeight(self.view.bounds)-300) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    //    tableView.backgroundColor = [UIColor clearColor];
    _tableView = tableView;
    
    [tableView registerNib:[UINib nibWithNibName:@"NextTableViewCell" bundle:nil] forCellReuseIdentifier:@"NextCell"];
}

- (void)setupHeader {
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH * 0.75, 300)];
    imageV.backgroundColor = [UIColor clearColor];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.image = [UIImage imageNamed:@"1.jpg"];
    [self.view addSubview:imageV];
}


- (void)dealloc {
    NSLog(@"%s",__func__);
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NextCell"];
    cell.imageName = self.imageArray[indexPath.row];
    cell.title = self.titleArray[indexPath.row];
    //    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NextViewController *vc = [NextViewController new];
    
    [self xl_pushViewController:vc];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}



@end
