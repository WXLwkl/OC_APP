//
//  TXViewController.m
//  OC_APP


#import "TXViewController.h"

#import "ChildViewController.h"

@implementation TXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"腾讯视频";
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    // 设置搜索框
    CGFloat searchH = 44;
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, screenW, searchH)];
    [self.view addSubview:searchBar];

    // 添加所有子控制器
    [self setUpAllViewController];
     
    // 设置整体内容尺寸（包含标题滚动视图和底部内容滚动视图）
    [self setupContentViewFrame:^(UIView *contentView) {
       
        CGFloat contentX = 0;
        
        CGFloat contentY = CGRectGetMaxY(searchBar.frame);
        
        CGFloat contentH = screenH - contentY - kNavHeight;

        contentView.frame = CGRectMake(contentX, contentY, screenW, contentH);
        
    }];
    
    /****** 标题渐变 ******/
    // 推荐方式(设置标题颜色渐变) // 默认RGB样式
    [self setupTitleGradient:^(TitleColorGradientStyle *titleColorGradientStyle, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor) {
        *norColor = [UIColor blackColor];
        *selColor = [UIColor redColor];
    }];

    /****** 设置遮盖 ******/
    // *推荐方式(设置遮盖)
    [self setupCoverEffect:^(UIColor **coverColor, CGFloat *coverCornerRadius) {
        
        // 设置蒙版颜色
        *coverColor = [UIColor colorWithWhite:0.7 alpha:0.4];
        
        // 设置蒙版圆角半径
        *coverCornerRadius = 13;
    }];
}

// 添加所有子控制器
- (void)setUpAllViewController
{
    
    // 段子
    ChildViewController *wordVc1 = [[ChildViewController alloc] init];
    wordVc1.title = @"巨星呀巨星 我们都爱你";
    [self addChildViewController:wordVc1];
    
    // 段子
    ChildViewController *wordVc2 = [[ChildViewController alloc] init];
    wordVc2.title = @"iOS";
    [self addChildViewController:wordVc2];
    
    // 段子
    ChildViewController *wordVc3 = [[ChildViewController alloc] init];
    wordVc3.title = @"男神";
    [self addChildViewController:wordVc3];
    
    ChildViewController *wordVc4 = [[ChildViewController alloc] init];
    wordVc4.title = @"快乐";
    [self addChildViewController:wordVc4];
    
    // 全部
    ChildViewController *allVc = [[ChildViewController alloc] init];
    allVc.title = @"全部";
    [self addChildViewController:allVc];
    
    // 视频
    ChildViewController *videoVc = [[ChildViewController alloc] init];
    videoVc.title = @"视频";
    [self addChildViewController:videoVc];
    
    // 声音
    ChildViewController *voiceVc = [[ChildViewController alloc] init];
    voiceVc.title = @"声音";
    [self addChildViewController:voiceVc];
    
    // 图片
    ChildViewController *pictureVc = [[ChildViewController alloc] init];
    pictureVc.title = @"图片";
    [self addChildViewController:pictureVc];
    
    // 段子
    ChildViewController *wordVc = [[ChildViewController alloc] init];
    wordVc.title = @"段子";
    [self addChildViewController:wordVc];
    
    
    
}


@end
