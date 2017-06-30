//
//  LaunchViewController.m
//  OC_APP
//
//  Created by xingl on 2017/6/15.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "LaunchViewController.h"
#import "TestWebVC.h"

typedef NS_ENUM(NSUInteger, ADScreenType) {
    ADScreenTypeFull, //全屏广告
    ADScreenTypeLogo, //logo广告
};

#define SDMainScreenBounds [UIScreen mainScreen].bounds

#define mainHeight      [[UIScreen mainScreen] bounds].size.height
#define mainWidth       [[UIScreen mainScreen] bounds].size.width

NSString * const adImageName   = @"adImageName";
NSString * const adDownloadUrl = @"adDownloadUrl";
NSString * const pushToADUrl   = @"pushToADUrl";
NSString * const adType        = @"adTypeKey";
//倒计时总时长,默认4秒
NSInteger  const adTime = 4;


@interface LaunchViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIViewController *mainVC;

@property (nonatomic,strong) UIImageView * adImageView; //广告图片
@property (nonatomic,strong) UIButton * skipBtn;  //跳过按钮
@property (nonatomic,strong) NSTimer  * countTimer;
@property (nonatomic,assign) NSInteger  count;  //记录当前的秒数
@property (assign, nonatomic) BOOL isAD;  //点击的是不是广告图
@property (nonatomic,copy) NSString *filePath;//广告图的文件地址

/**
 新手导引的页面标记
 */
@property(nonatomic,strong)UIPageControl *pageControl;

/**
 新手导引的图片数组
 */
@property (nonatomic, strong) NSArray *imageNameArray;


@end

@implementation LaunchViewController

- (instancetype)initWithMainViewController:(UIViewController *)mainVC guideImages:(NSArray *)guideImagesArray {
    if (self = [super init]) {
        self.mainVC = mainVC;
        self.imageNameArray = guideImagesArray;
    }
    return self;
}

#pragma mark ---全局方法---

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *currentVersion = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *LastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastVersion"];
    BOOL isEqueal = YES;
    if (![currentVersion isEqualToString:LastVersion]) {
        
        isEqueal = NO;
        [[NSUserDefaults standardUserDefaults] setValue:currentVersion forKey:@"LastVersion"];
    }
    
    if (!isEqueal) {
        NSLog(@"加载新手引导");
        [self loadImageScollView];
    } else {
        //1.判断沙盒中是否存在广告的图片名字和图片数据，如果有则显示
        NSString * imageName = [[NSUserDefaults standardUserDefaults] objectForKey:adImageName];
        if (imageName != nil) {
            
            NSString * filePath = [self getFilePathWithImageName:imageName];
            
            BOOL isExist = [self isFileExistWithFilePath:filePath];
            
            if (isExist) {
                
                [self loadADPageView];
                self.filePath = filePath;
                
            } else {
                
                [self performSelector:@selector(gotoMainViewController) withObject:self afterDelay:0.0f];
            }
        } else {
            
            [self performSelector:@selector(gotoMainViewController) withObject:self afterDelay:0.0f];
        }
    }
    //更新本地广告数据
    [self UpdateAdvertisementDataFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//异常情况-直接转移到mainVC中
- (void)gotoMainViewController {
    
    self.view.window.rootViewController = self.mainVC;
}

#pragma mark - ---------ADPageView---------
- (void)loadADPageView {
    
    //获取启动图片
    CGSize viewSize = [[UIScreen mainScreen] bounds].size;
    //横屏请设置成 @"Landscape"
    NSString *viewOrientation = @"Portrait";
    NSString *launchImageName = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict)
        
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImageName = dict[@"UILaunchImageName"];
        }
        
    }
    
    UIImage * launchImage = [UIImage imageNamed:launchImageName];
    self.view.backgroundColor = [UIColor colorWithPatternImage:launchImage];
    self.view.frame = CGRectMake(0, 0, mainWidth, mainHeight);
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:adType] isEqualToString:@"Fullx"] ) {
        self.adImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mainWidth, mainHeight)];
    }else{
        self.adImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mainWidth, mainHeight - mainWidth/3)];
    }
    _adImageView.userInteractionEnabled = YES;
    _adImageView.backgroundColor =  [UIColor clearColor];
    _adImageView.contentMode = UIViewContentModeScaleAspectFill;
    _adImageView.clipsToBounds = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesHandle:)];
    [_adImageView addGestureRecognizer:tap];
    
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = 1.2;
    opacityAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.8];
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.adImageView.layer addAnimation:opacityAnimation forKey:@"animateOpacity"];
    
    
    
    //2.跳过按钮
    self.skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.skipBtn.frame = CGRectMake(mainWidth - 70, 20, 60, 30);
    self.skipBtn.backgroundColor = [UIColor brownColor];
    self.skipBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.skipBtn addTarget:self action:@selector(skipBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_adImageView addSubview:_skipBtn];
    [self.view addSubview:_adImageView];
    
    [self startTimer];
    
}
- (void)setFilePath:(NSString *)filePath
{
    _filePath = filePath;
    
    _adImageView.image = [UIImage imageWithContentsOfFile:filePath];
}

- (void) startTimer
{
    _count = adTime;
    [[NSRunLoop mainRunLoop] addTimer:self.countTimer forMode:NSRunLoopCommonModes];
}
#pragma mark - 点击广告
- (void)tapGesHandle:(UITapGestureRecognizer*)recognizer {
    
    _isAD = YES;


    TestWebVC *vc = [TestWebVC new];
    vc.url = [[NSUserDefaults standardUserDefaults] objectForKey:pushToADUrl];
    vc.mainViewController = self.mainVC;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
  
    [self.view.window.layer addAnimation:animation forKey:nil];
    
    [self presentViewController:nav animated:NO completion:nil];
    


}
#pragma mark - 点击跳过
- (void)skipBtnClick{
    _isAD = NO;
    [self startcloseAnimation];
}

#pragma mark - 懒加载
- (NSTimer *)countTimer
{
    if (_countTimer == nil) {
        
        _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownEventHandle) userInfo:nil repeats:YES];
    }
    return _countTimer;
}
- (void)countDownEventHandle {
    if (_count == 0) {
        [_countTimer invalidate];
        _countTimer = nil;
        [self startcloseAnimation];
    }else{
        [self.skipBtn setTitle:[NSString stringWithFormat:@"%@ | 跳过",@(_count--)] forState:UIControlStateNormal];
    }
}

#pragma mark - 关闭动画
- (void)startcloseAnimation{
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = 0.5;
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.fillMode = kCAFillModeForwards;
    [self.adImageView.layer addAnimation:opacityAnimation forKey:@"animateOpacity"];
    
    NSTimeInterval timeInterval;
    
    if (_isAD) {
        timeInterval = 0;
    } else {
        timeInterval = opacityAnimation.duration;
    }
    
    [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                     target:self
                                   selector:@selector(closeAdImgAnimation)
                                   userInfo:nil
                                    repeats:NO];
    
}
#pragma mark - 关闭动画完成时处理事件
-(void)closeAdImgAnimation
{
    [_countTimer invalidate];
    _countTimer = nil;
    self.view.window.rootViewController = self.mainVC;
    self.view.hidden = YES;
    self.adImageView.hidden = YES;
    [self.view removeFromSuperview];
    
}


#pragma mark - *******************************************
#pragma mark - 要完善的方法   加上网络请求

- (void)UpdateAdvertisementDataFromServer
{
    //TODO 在这里请求广告的数据，包含图片的图片路径和点击图片要跳转的URL
    
    
    //我们这里假设 图片的下载URl和跳转URl 广告图片大小 如下所示
    
    NSString *imageurl = @"http://pic.paopaoche.net/up/2012-2/20122220201612322865.png";
    NSString *pushtoURl = @"http://cn.bing.com/";
    NSString *adTypeStr = @"Full";
    
    
    //获取图片名
    NSString * imageName = [[imageurl componentsSeparatedByString:@"/"] lastObject];
    
    //将图片名与沙盒中的数据比较
    NSString * oldImageName =[[NSUserDefaults standardUserDefaults] objectForKey:adImageName];
    if ((oldImageName == nil) || (![oldImageName isEqualToString:imageName]) ) {
        //异步下载广告数据
        [self downloadADImageWithUrl:imageurl imageName:imageName];
        //保存跳转路径到沙盒中
        [[NSUserDefaults standardUserDefaults] setObject:pushtoURl forKey:pushToADUrl];
        [[NSUserDefaults standardUserDefaults] setObject:adTypeStr forKey:adType];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


#pragma mark - 帮助方法

- (NSString *)getFilePathWithImageName:(NSString *)imageName
{
    if (imageName) {
        
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        //图片默认存储在Cache目录下
        return [paths[0] stringByAppendingPathComponent:imageName];
    }
    return nil;
    
}

//判断该路径是否存在文件
- (BOOL)isFileExistWithFilePath:(NSString *) filePath
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    BOOL isDirectory = NO;
    
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
    
}

- (void) deleteOldImage
{
    NSString * imageName = [[NSUserDefaults standardUserDefaults] objectForKey:adImageName];
    if (imageName) {
        
        NSString * filePath = [self getFilePathWithImageName:imageName];
        NSFileManager * fileManager = [NSFileManager defaultManager];
        if ([self isFileExistWithFilePath:filePath]) {
            
            [fileManager removeItemAtPath:filePath error:nil];
        }
    }
}


//异步下载广告图片
- (void) downloadADImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName
{
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //TODO 异步操作
        //1、下载数据
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage * image = [UIImage imageWithData:data];
        //2、获取保存文件的路径
        NSString * filePath = [self getFilePathWithImageName:imageName];
        //3、写入文件到沙盒中
        BOOL ret = [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
        if (ret) {
            NSLog(@"广告图片保存成功");
            
            [self deleteOldImage];
            
            //保存图片名和下载路径
            [[NSUserDefaults standardUserDefaults] setObject:imageName forKey:adImageName];
            [[NSUserDefaults standardUserDefaults] setObject:imageUrl forKey:adDownloadUrl];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        } else {
            NSLog(@"广告图片保存失败");
        }
        
    });
}



#pragma mark -----------轮播图新手导引控制器相关方法-------------
-(void)loadImageScollView {
    
    UIScrollView *imageScollView = [[UIScrollView alloc]initWithFrame:SDMainScreenBounds];
    
    imageScollView.delegate = self;
    
    //加载本地图片
    if (_imageNameArray.count != 0) {
        
        imageScollView.contentSize = CGSizeMake(SDMainScreenBounds.size.width*_imageNameArray.count, SDMainScreenBounds.size.height);
        
        imageScollView.pagingEnabled = YES;
        
        imageScollView.showsHorizontalScrollIndicator = NO;
        
        imageScollView.showsVerticalScrollIndicator =NO;
        
//        imageScollView.bounces = NO;
        
        //添加图片
        for (int i = 0; i<_imageNameArray.count; i++) {
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SDMainScreenBounds.size.width*i, 0, SDMainScreenBounds.size.width, SDMainScreenBounds.size.height)];
            
            imageView.image = [UIImage imageNamed:_imageNameArray[i]];
            
            [imageScollView addSubview:imageView];
            
            if (i == _imageNameArray.count-1) {
                
                UIButton *endButton = [UIButton buttonWithType:UIButtonTypeSystem];
                endButton.frame = CGRectMake(SDMainScreenBounds.size.width/2-60, SDMainScreenBounds.size.height-120, 120, 40);
                endButton.tintColor = [UIColor lightGrayColor];
                [endButton setImage:[UIImage imageNamed:@"进入应用"] forState:UIControlStateNormal];
                [endButton addTarget:self action:@selector(skipAD) forControlEvents:UIControlEventTouchUpInside];
                //最后一张图片加上进入按钮
                [imageView addSubview:endButton];
                imageView.userInteractionEnabled = YES;
                
            }
        }
    }
    
    [self.view addSubview:imageScollView];
    [self.view addSubview:self.pageControl];
}


//跳转到主控制器
-(void)skipAD {
    
    [UIView animateWithDuration:1.0 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.5, 1.5);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.view.window.rootViewController = self.mainVC;
        [self.view removeFromSuperview];
    }];
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, SDMainScreenBounds.size.height-40, SDMainScreenBounds.size.width, 40)];
        
        _pageControl.currentPage =0;
        _pageControl.numberOfPages = _imageNameArray.count;
        //设置当前页指示器的颜色
        _pageControl.currentPageIndicatorTintColor =[UIColor blueColor];
        //设置指示器的颜色
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    }
    return _pageControl;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //获取偏移量
    NSInteger currentPage = scrollView.contentOffset.x/SDMainScreenBounds.size.width;
    //改变PageControl的显示
    _pageControl.currentPage = currentPage;
    
    if (scrollView.contentOffset.x < scrollView.bounds.size.width) {
        scrollView.bounces = NO;
    } else {
        scrollView.bounces = YES;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.x > (_imageNameArray.count-1) * scrollView.bounds.size.width) {
        
        [self skipAD];
    }
}
-(void)dealloc{
    
    if (self.countTimer !=nil) {
        
        [self.countTimer invalidate];
        self.countTimer = nil;
    }
    
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}


@end
