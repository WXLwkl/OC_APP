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


#import <MJRefresh.h>
#import "InfunRefreshHeader.h"

#import "ALinRefreshGifHeader.h"

#define NAVBAR_COLORCHANGE_POINT (IMAGE_HEIGHT - NAV_HEIGHT*2)
#define NAV_HEIGHT 64
#define IMAGE_HEIGHT 260


@interface MeViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *topView;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIButton *button;

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
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.topView;
    
    self.tableView.mj_header = [ALinRefreshGifHeader headerWithRefreshingBlock:^{
        
        [self requestCommentsData];
        
    }];
    
    BOOL isOK = NO;
    LogBool(isOK);
    
//    [self createButton];
}
- (void)requestCommentsData {
    [self performSelector:@selector(aa) withObject:self afterDelay:3];
}
- (void)aa {
    NSLog(@"刷新！！！！！");
    [self.tableView.mj_header endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
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
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"id";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    // cell ...
    cell.textLabel.text = [@(indexPath.row) stringValue];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ViewController *vc = [ViewController new];
    [self.navigationController pushViewController:vc animated:YES];
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
    } else {
        [self.navigationController.navigationBar xl_setBackgroundColor:[THEME_CLOLR colorWithAlphaComponent:0]];
//        [self wr_setNavBarTintColor:[UIColor whiteColor]];
//        [self wr_setNavBarTitleColor:[UIColor whiteColor]];
//        [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];
        self.title = @"";
    }
}

#pragma mark - get
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style: UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor orangeColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
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
