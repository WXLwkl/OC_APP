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

//#import "SpeechViewController.h"
//#import "AlertControllerViewController.h"
//#import "MasonryViewController.h"
//#import "ReduceTimeViewController.h"
//#import "FormViewController.h"
//#import "SDWebImageTableViewController.h"
//#import "ChatViewController.h"
//#import "CustomViewController.h"
//#import "BlankPageViewController.h"
//#import "DragTableViewController.h"
//#import "LightSensitiveViewController.h"
//#import "CardViewController.h"
//#import "CellSelectViewController.h"
//#import "TurntableViewController.h"
//#import "LoveHeartViewController.h"
//#import "FireworksViewController.h"
//#import "LinkageViewController.h"
//#import "ScrollNumLabelViewController.h"
//#import "PayPasswordViewController.h"
//#import "InfiniteTabelViewController.h"
//#import "ShowSlideViewController.h"
//#import "WebJSBridgeViewController.h"
//#import "ScriptMessageHandlerViewController.h"
//#import "DataSourceViewController.h"
//#import "BezierPathViewController.h"
//#import "UploadImagesViewController.h"
//#import "ProgressViewController.h"
//#import "CollectionListViewController.h"
//#import "AudioAndVideoViewController.h"
//#import "TanTanCardViewController.h"
//#import "PieChartViewController.h"
//#import "PopViewController.h"
//#import "SpotlightViewController.h"
//#import "UITableView+Common.h"

#import "NSString+Common.h"

#define NAVBAR_COLORCHANGE_POINT (IMAGE_HEIGHT - NAV_HEIGHT*2)
#define NAV_HEIGHT 60
#define IMAGE_HEIGHT 260


#import <WRNavigationBar.h>

//#import "FPSLabel.h"
#import "DebugTool.h"

#import "XLRouter.h"

@interface MeViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *topView;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIButton *button;

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation MeViewController


//- (void)loadView {
//    [super loadView];
//    [self.navigationController.navigationBar setShadowImage:[UIImage xl_imageWithColor:[UIColor clearColor]]];
//}

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
    
    self.tableView.xl_header = [InfunRefreshHeader headerWithRefreshingBlock:^{
        
        [self requestCommentsData];
        
    }];
    
    BOOL isOK = NO;
    LogBool(isOK);

    
    if (!self.dataArray) {
        self.dataArray = [NSMutableArray arrayWithArray:@[
  @{@"title" : @"原生语音识别-iOS10后(OK)", @"url" : @"kRouterSchemePush://SpeechViewController?name=xingl&age=28"},
  @{@"title" : @"Masonry布局实例(OK)",     @"url" : @"kRouterSchemePush://MasonryViewController?name=xingl&age=28"},
  @{@"title" : @"照片上传(OK)",            @"url" : @"kRouterSchemePush://UploadImagesViewController"},
  @{@"title" : @"AlertController(OK)",    @"url" : @"kRouterSchemePush://AlertControllerViewController?name=xingl&age=28"},
  @{@"title" : @"列表倒计时(OK)",           @"url" : @"kRouterSchemePush://ReduceTimeViewController?name=xingl&age=28"},
  @{@"title" : @"H5交互WebViewJavascriptBridge", @"url" : @"kRouterSchemePush://WebJSBridgeViewController"},
  @{@"title" : @"H5交互ScriptMessageHandler(OK)", @"url" : @"kRouterSchemePush://ScriptMessageHandlerViewController?name=xingl&age=28"},
  @{@"title" : @"列表空白页展现(OK)",              @"url" : @"kRouterSchemePush://BlankPageViewController"},
  @{@"title" : @"BezierPath练习(OK)",              @"url" : @"kRouterSchemePush://BezierPathViewController?name=xingl&age=28"},
  @{@"title" : @"常见表单行类型(OK)(包含省市区三级联动)", @"url" : @"kRouterSchemePush://FormViewController"},
  @{@"title" : @"TableViewDataSource提取(OK)", @"url" : @"kRouterSchemePush://DataSourceViewController"},
  @{@"title" : @"无限滚动的tableView(OK)", @"url" : @"kRouterSchemePush://InfiniteTabelViewController"},
  @{@"title" : @"只加载显示Cell的Image图(OK)", @"url" : @"kRouterSchemePush://SDWebImageTableViewController"},
  @{@"title" : @"列表滑动不加载图片", @"url" : @"kRouterSchemePush://xxx"},
  @{@"title" : @"长按列表行拖动效果(OK)", @"url" : @"kRouterSchemePush://DragTableViewController"},
  @{@"title" : @"自定义视图(OK)", @"url" : @"kRouterSchemePush://CustomViewController"},
  @{@"title" : @"获取环境光感(OK)", @"url" : @"kRouterSchemePush://LightSensitiveViewController"},
  @{@"title" : @"卡片效果(OK)", @"url" : @"kRouterSchemePush://CardViewController"},
  @{@"title" : @"Cell的多选(OK)", @"url" : @"kRouterSchemePush://CellSelectViewController"},
  @{@"title" : @"抽奖(OK)", @"url" : @"kRouterSchemePush://TurntableViewController"},
  @{@"title" : @"直播❤️形点赞(OK)", @"url" : @"kRouterSchemePush://LoveHeartViewController"},
  @{@"title" : @"烟花(OK)", @"url" : @"kRouterSchemePush://FireworksViewController"},
  @{@"title" : @"联动(OK)", @"url" : @"kRouterSchemePush://LinkageViewController"},
  @{@"title" : @"滚动的数字(OK)", @"url" : @"kRouterSchemePush://ScrollNumLabelViewController"},
  @{@"title" : @"交易密码(OK)", @"url" : @"kRouterSchemePush://PayPasswordViewController"},
  @{@"title" : @"左右滑动视图(OK)", @"url" : @"kRouterSchemePush://ShowSlideViewController"},
  @{@"title" : @"进度条(OK)", @"url" : @"kRouterSchemePush://ProgressViewController"},
  @{@"title" : @"CollectionView相关(OK)", @"url" : @"kRouterSchemePush://CollectionListViewController"},
  @{@"title" : @"音视频功能集合(OK)", @"url" : @"kRouterSchemePush://AudioAndVideoViewController"},
  @{@"title" : @"仿探探card(OK)", @"url" : @"kRouterSchemePush://TanTanCardViewController"},
  @{@"title" : @"饼图(OK)", @"url" : @"kRouterSchemePush://PieChartViewController"},
  @{@"title" : @"PopViewController(OK)", @"url" : @"kRouterSchemePush://PopViewController"},
  @{@"title" : @"类似spotlight菜单(OK)", @"url" : @"kRouterSchemePush://SpotlightViewController"}]];
    }
//    self.dataArray = [[NSMutableArray alloc]init];
    
    //创建对象时，使用内联符合表达式
//    FPSLabel *fpsLabel = ({
//        FPSLabel *label = [FPSLabel new];
//        label.frame=CGRectMake(20, 80, 30, 30);
//        [label sizeToFit];
//        label.alpha = 0.6;
//        label;
//    });
    
    
    
//    [self.view addSubview:fpsLabel];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:fpsLabel];
//    [[DebugTool sharedDebugTool] autoTypes:DebugToolTypeFPS |  DebugToolTypeCPU | DebugToolTypeMemory];
    
//    kScreenWidth
    
    //弹出提示
    [self showNewStatusesCount:self.dataArray.count];

    [self wr_setNavBarBackgroundAlpha:0];
}

- (void)refresh {
    //模拟刷新 偶数调用有数据 奇数无数据
    [self.tableView.xl_header beginRefreshing];
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
            [self.tableView.xl_header endRefreshing];
        });
    });
}


- (void)requestCommentsData {
    [self performSelector:@selector(aa) withObject:self afterDelay:3];
}
- (void)aa {
    NSLog(@"刷新！！！！！");
    [self.tableView.xl_header endRefreshing];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:YES];
//    
//    [self scrollViewDidScroll:self.tableView];
//    [self.tableView reloadData];
//}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//
//    [self scrollViewDidScroll:self.tableView];
//    [self.tableView reloadData];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//
//    [super viewWillDisappear:animated];
//    //还原导航栏
//    [self.navigationController.navigationBar xl_reset];
//
//}

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
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = self.dataArray[indexPath.row];
    [XLRouter openUrl:dic[@"url"]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_COLORCHANGE_POINT) {
        CGFloat alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / NAV_HEIGHT;
//        [self.navigationController.navigationBar xl_setBackgroundColor:[THEME_color colorWithAlphaComponent:alpha > 0.99 ? 0.99 : alpha]];
//        [self wr_setNavBarTintColor:[[UIColor blackColor] colorWithAlphaComponent:alpha]];
//        [self wr_setNavBarTitleColor:[[UIColor blackColor] colorWithAlphaComponent:alpha]];
//        [self wr_setStatusBarStyle:UIStatusBarStyleDefault];
        
        [self wr_setNavBarBackgroundAlpha:alpha];
        
        self.navigationItem.title = @"个人中心";
        self.statusBarStyle = UIStatusBarStyleLightContent;
    } else {
//        [self.navigationController.navigationBar xl_setBackgroundColor:[THEME_color colorWithAlphaComponent:0]];
//        [self wr_setNavBarTintColor:[UIColor whiteColor]];
//        [self wr_setNavBarTitleColor:[UIColor whiteColor]];
//        [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];
        [self wr_setNavBarBackgroundAlpha:0];
        self.navigationItem.title = @"";
        self.statusBarStyle = UIStatusBarStyleDefault;
    }
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style: UITableViewStylePlain];
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
- (UIView *)topView {
    if (_topView == nil) {
//        _topView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wbBG"]];
//        _topView.frame = CGRectMake(0, 0, self.view.frame.size.width, IMAGE_HEIGHT);
        _topView = [[GradientView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 225)];
    }
    return _topView;
}

- (void)showNewStatusesCount:(NSInteger)count {
    // 1.创建一个UILabel
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:12];

    // 2.显示文字
    if (count) {
        label.text = [NSString stringWithFormat:@"共有%ld条实例数据", (long)count];
    } else {
        label.text = @"没有最新的数据";
    }

    // 3.设置背景
    label.backgroundColor = [UIColor colorWithRed:254/255.0  green:129/255.0 blue:0 alpha:1.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];

    // 4.设置frame
    label.xl_width = self.view.frame.size.width;
    label.xl_height = 35;
    label.xl_x = 0;
    label.xl_y = CGRectGetMaxY([self.navigationController navigationBar].frame) - label.frame.size.height;

    // 5.添加到导航控制器的view
    //[self.navigationController.view addSubview:label];
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];

    // 6.动画
    CGFloat duration = 0.75;
    //label.alpha = 0.0;
    [UIView animateWithDuration:duration animations:^{
        // 往下移动一个label的高度
        label.transform = CGAffineTransformMakeTranslation(0, label.frame.size.height);
        //label.alpha = 1.0;
    } completion:^(BOOL finished) { // 向下移动完毕

        // 延迟delay秒后，再执行动画
        CGFloat delay = 1.0;

        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{

            // 恢复到原来的位置
            label.transform = CGAffineTransformIdentity;
            //label.alpha = 0.0;

        } completion:^(BOOL finished) {

            // 删除控件
            [label removeFromSuperview];
        }];
    }];
}


@end
