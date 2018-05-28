//
//  XiMaViewController.h
//  OC_APP


#import "XiMaViewController.h"

#import "ChildViewController.h"

#import "FullChildViewController.h"

@implementation XiMaViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"喜马拉雅";
    
    // 添加所有子控制器
    [self setUpAllViewController];
    
    // 设置标题字体
    // 推荐方式
    [self setupTitleEffect:^(UIColor *__autoreleasing *titleScrollViewColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIFont *__autoreleasing *titleFont, CGFloat *titleHeight,CGFloat *titleWidth) {
        
            // 设置标题字体
            *titleFont = [UIFont systemFontOfSize:20];
        
    }];
 
    // 推荐方式（设置下标）
    [self setupUnderLineEffect:^(BOOL *isUnderLineDelayScroll, CGFloat *underLineH, UIColor *__autoreleasing *underLineColor,BOOL *isUnderLineEqualTitleWidth) {
        // 标题填充模式
        *underLineColor = [UIColor redColor];
    }];
    
    // 设置全屏显示
    // 如果有导航控制器或者tabBarController,需要设置tableView额外滚动区域,详情请看FullChildViewController
    self.isFullScreen = NO;
}

// 添加所有子控制器
- (void)setUpAllViewController
{
    
    // 段子
    FullChildViewController *wordVc1 = [[FullChildViewController alloc] init];
    wordVc1.title = @"帅气";
    [self addChildViewController:wordVc1];
    
    // 段子
    FullChildViewController *wordVc2 = [[FullChildViewController alloc] init];
    wordVc2.title = @"潇洒";
    [self addChildViewController:wordVc2];
    
    // 段子
    FullChildViewController *wordVc3 = [[FullChildViewController alloc] init];
    wordVc3.title = @"英俊";
    [self addChildViewController:wordVc3];
    
    FullChildViewController *wordVc4 = [[FullChildViewController alloc] init];
    wordVc4.title = @"守信";
    [self addChildViewController:wordVc4];
    
    // 全部
    FullChildViewController *allVc = [[FullChildViewController alloc] init];
    allVc.title = @"全部";
    [self addChildViewController:allVc];
    
    // 视频
    FullChildViewController *videoVc = [[FullChildViewController alloc] init];
    videoVc.title = @"视频";
    [self addChildViewController:videoVc];
    
    // 声音
    FullChildViewController *voiceVc = [[FullChildViewController alloc] init];
    voiceVc.title = @"声音";
    [self addChildViewController:voiceVc];
    
    // 图片
    FullChildViewController *pictureVc = [[FullChildViewController alloc] init];
    pictureVc.title = @"图片";
    [self addChildViewController:pictureVc];
    
    // 段子
    FullChildViewController *wordVc = [[FullChildViewController alloc] init];
    wordVc.title = @"段子";
    [self addChildViewController:wordVc];
    
    
    
}


@end
