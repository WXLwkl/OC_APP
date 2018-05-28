//
//  WYViewController.m
//  OC_APP


#import "WYViewController.h"

#import "ChildViewController.h"

@implementation WYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"网易新闻";
    
    // 添加所有子控制器
    [self setUpAllViewController];
    
    [self setupTitleEffect:^(UIColor *__autoreleasing *titleScrollViewColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIFont *__autoreleasing *titleFont, CGFloat *titleHeight, CGFloat *titleWidth) {
        *norColor = [UIColor lightGrayColor];
        *selColor = [UIColor blackColor];
        *titleWidth = [UIScreen mainScreen].bounds.size.width / 4;
    }];
    
    // 标题渐变
    // *推荐方式(设置标题渐变)
    [self setupTitleGradient:^(TitleColorGradientStyle *titleColorGradientStyle, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor) {
        
    }];
    
    [self setupUnderLineEffect:^(BOOL *isUnderLineDelayScroll, CGFloat *underLineH, UIColor *__autoreleasing *underLineColor,BOOL *isUnderLineEqualTitleWidth) {
//        *isUnderLineDelayScroll = YES;
        *isUnderLineEqualTitleWidth = YES;
    }];
        
    // 字体缩放
    // 推荐方式 (设置字体缩放)
//    [self setUpTitleScale:^(CGFloat *titleScale) {
//        // 字体缩放比例
//        *titleScale = 1.3;
//    }];
}

// 添加所有子控制器
- (void)setUpAllViewController
{
    
    // 段子
    ChildViewController *wordVc1 = [[ChildViewController alloc] init];
    wordVc1.title = @"iOS";
    [self addChildViewController:wordVc1];
    
    // 段子
    ChildViewController *wordVc2 = [[ChildViewController alloc] init];
    wordVc2.title = @"mac";
    [self addChildViewController:wordVc2];
    
    // 段子
    ChildViewController *wordVc3 = [[ChildViewController alloc] init];
    wordVc3.title = @"pro";
    [self addChildViewController:wordVc3];
    
    ChildViewController *wordVc4 = [[ChildViewController alloc] init];
    wordVc4.title = @"iPhone X";
    [self addChildViewController:wordVc4];
    
//    // 全部
//    ChildViewController *allVc = [[ChildViewController alloc] init];
//    allVc.title = @"全部";
//    [self addChildViewController:allVc];
//    
//    // 视频
//    ChildViewController *videoVc = [[ChildViewController alloc] init];
//    videoVc.title = @"视频";
//    [self addChildViewController:videoVc];
//    
//    // 声音
//    ChildViewController *voiceVc = [[ChildViewController alloc] init];
//    voiceVc.title = @"声音";
//    [self addChildViewController:voiceVc];
//    
//    // 图片
//    ChildViewController *pictureVc = [[ChildViewController alloc] init];
//    pictureVc.title = @"图片";
//    [self addChildViewController:pictureVc];
//    
//    // 段子
//    ChildViewController *wordVc = [[ChildViewController alloc] init];
//    wordVc.title = @"段子";
//    [self addChildViewController:wordVc];
    
    
    
}


@end
