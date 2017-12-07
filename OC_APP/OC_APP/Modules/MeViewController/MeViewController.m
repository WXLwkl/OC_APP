//
//  MeViewController.m
//  OC_APP
//
//  Created by xingl on 2017/6/7.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "MeViewController.h"

#import "AppDelegate.h"

#import "GradientView.h"

#import "ViewController.h"

#import "SettingViewController.h"


#import "InfunRefreshHeader.h"

#import "ALinRefreshGifHeader.h"


#import "AddressPickViewController.h"
#import "MasonryViewController.h"
#import "ReduceTimeViewController.h"
#import "FormViewController.h"
#import "SDWebImageTableViewController.h"
#import "ChatViewController.h"
#import "CustomViewController.h"
#import "BlankPageViewController.h"
#import "DragTableViewController.h"
#import "LightSensitiveViewController.h"
#import "CardViewController.h"
#import "CellSelectViewController.h"
#import "TurntableViewController.h"
//#import "UITableView+Common.h"

#import "NSString+Common.h"

#define NAVBAR_COLORCHANGE_POINT (IMAGE_HEIGHT - NAV_HEIGHT*2)
#define NAV_HEIGHT 64
#define IMAGE_HEIGHT 260


#import "FPSLabel.h"

@interface MeViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *topView;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIButton *button;

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation MeViewController


- (void)createButton {
    
    _window = [UIApplication sharedApplication].windows[0];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setTitle:@"按钮" forState:UIControlStateNormal];
    _button.frame = CGRectMake(self.view.bounds.size.width - 70, self.view.bounds.size.height - 150, 60, 60);
    _button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [_button setBackgroundColor:[UIColor orangeColor]];
    _button.layer.cornerRadius = 30;
    _button.layer.masksToBounds = YES;
    [_button addTarget:self action:@selector(resignButton) forControlEvents:UIControlEventTouchUpInside];
    [_window addSubview:_button];
    
    //放一个拖动手势，用来改变控件的位置
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changePostion:)];
    [_button addGestureRecognizer:pan];
    
}

- (void)resignButton{
    NSLog(@"我是悬浮按钮");
}
//手势事件 －－ 改变位置
-(void)changePostion:(UIPanGestureRecognizer *)pan {
    
    CGPoint point = [pan translationInView:_button];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    CGRect originalFrame = _button.frame;
    
    if (originalFrame.origin.x >= 0 && originalFrame.origin.x+originalFrame.size.width <= width) {
        
        originalFrame.origin.x += point.x;
        
    }if (originalFrame.origin.y >= 0 && originalFrame.origin.y+originalFrame.size.height <= height) {
        
        originalFrame.origin.y += point.y;
        
    }
    
    _button.frame = originalFrame;
    
    [pan setTranslation:CGPointZero inView:_button];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        _button.enabled = NO;
        
    }else if (pan.state == UIGestureRecognizerStateChanged){
        
    } else {
        
        CGRect frame = _button.frame;
        
        //是否越界
        
        BOOL isOver = NO;
        
        if (frame.origin.x < 0) {
            
            frame.origin.x = 0;
            
            isOver = YES;
            
        } else if (frame.origin.x+frame.size.width > width) {
            
            frame.origin.x = width - frame.size.width;
            
            isOver = YES;
            
        }if (frame.origin.y < 0) {
            
            frame.origin.y = 0;
            
            isOver = YES;
            
        } else if (frame.origin.y+frame.size.height > height) {
            
            frame.origin.y = height - frame.size.height;
            
            isOver = YES;
            
        }if (isOver) {
            
            [UIView animateWithDuration:0.3 animations:^{
                
                _button.frame = frame;
                
            }];
            
        }
        
        _button.enabled = YES;
        
    }
    
}

- (void)loadView {
    [super loadView];
    [self.navigationController.navigationBar setShadowImage:[UIImage xl_imageWithColor:[UIColor clearColor]]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:(UIBarButtonItemStylePlain) target:self action:@selector(settingBtnClick:)];
    
    self.edgesForExtendedLayout = UIRectEdgeLeft|UIRectEdgeRight|UIRectEdgeTop;
    
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.topView;
    
    //模拟刷新操作
//    __weak typeof(self) weakSelf = self;
//    [self.tableView setReloadBlock:^{
//        [weakSelf refresh];
//    }];
    
    self.tableView.mj_header = [ALinRefreshGifHeader headerWithRefreshingBlock:^{
        
        [self requestCommentsData];
        
    }];
    
    BOOL isOK = NO;
    LogBool(isOK);
    
//    [self createButton];

    
    if (!self.dataArray) {
        self.dataArray = [NSMutableArray arrayWithArray:@[@"省市区三级联动(OK)",
                                                          @"Masonry布局实例(OK)",
                                                          @"照片上传",
                                                          @"照片上传附带进度",
                                                          @"列表倒计时(OK)",
                                                          @"H5交互WebViewJavascriptBridge",
                                                          @"列表空白页展现(OK)",
                                                          @"自定义弹出窗",
                                                          @"常见表单行类型(OK)",
                                                          @"JavaScriptCore运用",
                                                          @"聊天(待完善)",
                                                          @"只加载显示Cell的Image图(OK)",
                                                          @"列表滑动不加载图片",
                                                          @"长按列表行拖动效果(OK)",
                                                          @"音视频功能集合",
                                                          @"自定义视图(OK)",
                                                          @"获取环境光感(OK)",
                                                          @"卡片效果(OK)",
                                                          @"Cell的多选(OK)",
                                                          @"抽奖(OK)"]];
    }
//    self.dataArray = [[NSMutableArray alloc]init];
    
    
    FPSLabel *fpsLabel = [FPSLabel new];
    fpsLabel.frame=CGRectMake(20, 80, 30, 30);
    [fpsLabel sizeToFit];
    fpsLabel.alpha = 0.6;
//    [self.view addSubview:fpsLabel];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:fpsLabel];

}

- (void)refresh {
    //模拟刷新 偶数调用有数据 奇数无数据
    [self.tableView.mj_header beginRefreshing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        static NSUInteger i = 0;
        if (i %2 == 0) {
            for (NSInteger i = 0; i < arc4random()%10; i++) {
                [self.dataArray addObject:[NSString stringWithFormat:@"卖报的小画家随机测试数据%ld",(long)i]];
            }
        } else {
            [self.dataArray removeAllObjects];
        }
        i++;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        });
    });
}


- (void)requestCommentsData {
    [self performSelector:@selector(aa) withObject:self afterDelay:3];
}
- (void)aa {
    NSLog(@"刷新！！！！！");
    [self.tableView.mj_header endRefreshing];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:YES];
//    
//    [self scrollViewDidScroll:self.tableView];
//    [self.tableView reloadData];
//}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self scrollViewDidScroll:self.tableView];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    //还原导航栏
    [self.navigationController.navigationBar xl_reset];
    
}

- (void)settingBtnClick:(UIBarButtonItem *)item {
    
    SettingViewController *set = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:set animated:YES];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"id";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    // cell ...
//    cell.textLabel.text = [@(indexPath.row) stringValue];
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            AddressPickViewController *vc = [AddressPickViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            MasonryViewController *vc = [[MasonryViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            //上传照片
        }
            break;
        case 3:
        {
            //上传照片带进度
        }
            break;
        case 4:
        {
            //列表倒计时
            ReduceTimeViewController *vc = [[ReduceTimeViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {
            //H5交互WebViewJavascriptBridge
        }
            break;
        case 6:
        {
            //列表空白页展现
            BlankPageViewController *vc = [[BlankPageViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7:
        {
            //自定义弹出窗
        }
            break;
        case 8:
        {
            //常见表单行类型
            FormViewController *vc = [FormViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 9:
        {
            //JavaScriptCore运用
        }
            break;
        case 10:
        {
            // QQ/微信 聊天
            ChatViewController *vc = [ChatViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 11:
        {
            //只加载显示Cell的Image图(OK)
            SDWebImageTableViewController *vc = [SDWebImageTableViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 12:
        {
            //列表滑动不加载图片
        }
            break;
        case 13:
        {
            //长按列表行拖动效果
            DragTableViewController *vc = [DragTableViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 14:
        {
            //音视频功能集合
        }
            break;
        case 15:
        {
            //自定义视图
            CustomViewController *vc = [[CustomViewController alloc] initWithNibName:NSStringFromClass([CustomViewController class]) bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 16:
        {
            //iOS利用摄像头获取环境光感参数
            LightSensitiveViewController *vc = [[LightSensitiveViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 17:
        {
            //卡片切换
            CardViewController *vc = [CardViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 18:
        {
            CellSelectViewController *vc = [CellSelectViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 19:
        {
            TurntableViewController *vc = [TurntableViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_COLORCHANGE_POINT) {
        CGFloat alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / NAV_HEIGHT;
        [self.navigationController.navigationBar xl_setBackgroundColor:[THEME_CLOLR colorWithAlphaComponent:alpha > 0.99 ? 0.99 : alpha]];
//        [self wr_setNavBarTintColor:[[UIColor blackColor] colorWithAlphaComponent:alpha]];
//        [self wr_setNavBarTitleColor:[[UIColor blackColor] colorWithAlphaComponent:alpha]];
//        [self wr_setStatusBarStyle:UIStatusBarStyleDefault];
        self.title = @"个人中心";
        self.statusBarStyle = UIStatusBarStyleLightContent;
    } else {
        [self.navigationController.navigationBar xl_setBackgroundColor:[THEME_CLOLR colorWithAlphaComponent:0]];
//        [self wr_setNavBarTintColor:[UIColor whiteColor]];
//        [self wr_setNavBarTitleColor:[UIColor whiteColor]];
//        [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];
        self.title = @"";
        self.statusBarStyle = UIStatusBarStyleDefault;
    }
}

#pragma mark - get
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style: UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}
- (UIView *)topView {
    if (_topView == nil) {
//        _topView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wbBG"]];
//        _topView.frame = CGRectMake(0, 0, self.view.frame.size.width, IMAGE_HEIGHT);
        _topView = [[GradientView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 225)];
    }
    return _topView;
}


//
//
//UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"C-AvatarIcon"]];
//imgV.frame = CGRectMake(15, 20, 50, 50);
//[waveView addSubview:imgV];
@end
