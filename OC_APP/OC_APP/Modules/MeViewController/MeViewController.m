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

#define kScaleLength(length) (length) * [UIScreen mainScreen].bounds.size.width / 320.0f

#define NAVBAR_COLORCHANGE_POINT (-IMAGE_HEIGHT + NAV_HEIGHT*2)
#define NAV_HEIGHT 64
#define IMAGE_HEIGHT 260
#define SCROLL_DOWN_LIMIT 100
#define LIMIT_OFFSET_Y -(IMAGE_HEIGHT + SCROLL_DOWN_LIMIT)

@interface MeViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *imgView;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIButton *button;

@end

@implementation MeViewController


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
    
    //    _window = [[UIWindow alloc]initWithFrame:CGRectMake(kSize_width - 70, kSize_height - 150, 50, 50)];
    
    //    _window.windowLevel = UIWindowLevelAlert+1;
    
    //    _window.backgroundColor = [UIColor greenColor];
    
    //    _window.layer.cornerRadius = 25;
    
    //    _window.layer.masksToBounds = YES;
    
    [_window addSubview:_button];
    
    //    [_window makeKeyAndVisible];//显示window
    
    //放一个拖动手势，用来改变控件的位置
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changePostion:)];
    
    [_button addGestureRecognizer:pan];
    
    
    
    BOOL isOK = NO;
    LogBool(isOK);
    
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
    self.navigationItem.title = @"个人中心";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:(UIBarButtonItemStylePlain) target:self action:@selector(settingBtnClick:)];
    
    self.edgesForExtendedLayout = UIRectEdgeLeft|UIRectEdgeRight|UIRectEdgeTop;
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.tableView.contentInset = UIEdgeInsetsMake(IMAGE_HEIGHT, 0, 0, 0);
    [self.tableView addSubview:self.imgView];
    
    [self.view addSubview:self.tableView];
    
    [self createButton];
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
    NSLog(@"---- setting ----");
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
    
    
//    [self navigationBarGradualChangeWithScrollView:scrollView offset:kScaleLength(190.5) color:[UIColor xl_colorWithHexNumber:0x1FB5EC]];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self viewWillLayoutSubviews];
    
//    return;
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY > NAVBAR_COLORCHANGE_POINT) {
        CGFloat alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / NAV_HEIGHT;
//        [self.navigationController.navigationBar lt_setNavigationBarBackgroundAlpha:alpha];
//        self.navigationController.navigationBar.alpha = alpha;
        
//        [self xl_setNavigationBarColorAlpha:alpha];
        
        [self.navigationController.navigationBar xl_setBackgroundColor:[THEME_CLOLR colorWithAlphaComponent:alpha > 0.99 ? 0.99 : alpha]];
//        [self.navigationController.navigationBar ya_setElementsAlpha:alpha > 0.99 ? 0.99 : alpha];
        
        
    } else {
//        [self.navigationController.navigationBar lt_setNavigationBarBackgroundAlpha:0];
//        [self xl_setNavigationBarColorAlpha:0];
        [self.navigationController.navigationBar xl_setBackgroundColor:[THEME_CLOLR colorWithAlphaComponent:0]];
    }
    
    //限制下拉的距离
    if(offsetY < LIMIT_OFFSET_Y) {
//        [scrollView setContentOffset:CGPointMake(0, LIMIT_OFFSET_Y)];
    }
    
    // 改变图片框的大小 (上滑的时候不改变)
    // 这里不能使用offsetY，因为当（offsetY < LIMIT_OFFSET_Y）的时候，y = LIMIT_OFFSET_Y 不等于 offsetY
    CGFloat newOffsetY = scrollView.contentOffset.y;
    if (newOffsetY < -IMAGE_HEIGHT)
    {
        self.imgView.frame = CGRectMake(0, newOffsetY, kScreenWidth, -newOffsetY);
    }
}


//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
////    GradientView *waveView = [[GradientView alloc]init];
////    return waveView;
//    
//    UIView *v = [[UIView alloc] init];
//    v.backgroundColor = [UIColor grayColor];
//    
//    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"C-AvatarIcon"]];
//    imgV.frame = CGRectMake(15, 20, 50, 50);
//    [v addSubview:imgV];
//    
//    return v;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 100;
//}
#pragma mark - get
- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -IMAGE_HEIGHT, kScreenWidth, IMAGE_HEIGHT)];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
        _imgView.image = [self imageWithImageSimple:[UIImage imageNamed:@"center_bg.jpg"] scaledToSize:CGSizeMake(kScreenWidth, IMAGE_HEIGHT+SCROLL_DOWN_LIMIT)];
    }
    return _imgView;
}

- (UIImage *)imageWithImageSimple:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(CGSizeMake(newSize.width*2, newSize.height*2));
    [image drawInRect:CGRectMake (0, 0, newSize.width*2, newSize.height*2)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
