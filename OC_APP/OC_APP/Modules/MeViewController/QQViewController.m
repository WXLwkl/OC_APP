//
//  QQViewController.m
//  OC_APP
//
//  Created by xingl on 2017/8/2.
//  Copyright © 2017年 兴林. All rights reserved.
//

#define kScaleLength(length) (length) * [UIScreen mainScreen].bounds.size.width / 320.0f

#define NAVBAR_COLORCHANGE_POINT (-IMAGE_HEIGHT + NAV_HEIGHT*2)
#define NAV_HEIGHT 64
#define IMAGE_HEIGHT 260
#define SCROLL_DOWN_LIMIT 100
#define LIMIT_OFFSET_Y -(IMAGE_HEIGHT + SCROLL_DOWN_LIMIT)

#import "QQViewController.h"

@interface QQViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation QQViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style: UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor orangeColor];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _tableView;
}
- (void)loadView {
    [super loadView];
    [self.navigationController.navigationBar setShadowImage:[UIImage xl_imageWithColor:[UIColor clearColor]]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"空间";
    
    self.edgesForExtendedLayout = UIRectEdgeLeft|UIRectEdgeRight|UIRectEdgeTop;
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.tableView.contentInset = UIEdgeInsetsMake(IMAGE_HEIGHT, 0, 0, 0);
    [self.tableView addSubview:self.imgView];
    
    [self.view addSubview:self.tableView];

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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        
        [self.navigationController.navigationBar xl_setBackgroundColor:[THEME_color colorWithAlphaComponent:alpha > 0.99 ? 0.99 : alpha]];
        //        [self.navigationController.navigationBar ya_setElementsAlpha:alpha > 0.99 ? 0.99 : alpha];
        
        
    } else {
        //        [self.navigationController.navigationBar lt_setNavigationBarBackgroundAlpha:0];
        //        [self xl_setNavigationBarColorAlpha:0];
        [self.navigationController.navigationBar xl_setBackgroundColor:[THEME_color colorWithAlphaComponent:0]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
