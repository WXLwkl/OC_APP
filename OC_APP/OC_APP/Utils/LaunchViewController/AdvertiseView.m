//
//  AdvertiseView.m
//  OC_APP
//
//  Created by xingl on 2018/1/16.
//  Copyright © 2018年 兴林. All rights reserved.
//

//倒计时总时长,默认4秒
NSInteger  const adTime = 4;

#import "AdvertiseView.h"

#import "TestWebVC.h"

@interface AdvertiseView ()

@property (nonatomic, strong) UIImageView *adImageView; //广告图片
@property (nonatomic, strong) UIButton *skipBtn;  //跳过按钮
@property (nonatomic, strong) NSTimer  *countTimer;
@property (nonatomic, assign) NSInteger count;  //记录当前的秒数
@property (nonatomic, assign) BOOL isAD;  //点击的是不是广告图

@property (nonatomic, strong) NSString  *urlString;

@property (nonatomic, strong) UIWindow *window;

@end



@implementation AdvertiseView


- (void)show {

    [self startTimer];
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    //初始化一个Window， 做到对业务视图无干扰。
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = [UIViewController new];
    window.rootViewController.view.backgroundColor = [UIColor clearColor];
    window.rootViewController.view.userInteractionEnabled = NO;

    //设置为最顶层，防止 AlertView 等弹窗的覆盖
    window.windowLevel = UIWindowLevelStatusBar + 1;

    //默认为YES，当你设置为NO时，这个Window就会显示了
    window.hidden = NO;
    window.alpha = 1;

    ///防止释放，显示完后  要手动设置为 nil
    self.window = window;

    [window addSubview:self];
}

- (instancetype)initWithFrame:(CGRect)frame withADScreenType:(ADScreenType)type pushURLString:(NSString *)url {
    self = [super initWithFrame:frame];
    if (self) {

        //横屏请设置成 @"Landscape"
        NSString *viewOrientation = @"Portrait";
        UIImage *launchImage = [self launchImageWithType:viewOrientation];

        self.backgroundColor = [UIColor colorWithPatternImage:launchImage];
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);

        if (type == ADScreenTypeFull) {
            self.adImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        } else {
            self.adImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kScreenWidth/3)];
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
        self.skipBtn.frame = CGRectMake(kScreenWidth - 70, 20, 60, 30);
        self.skipBtn.backgroundColor = [UIColor brownColor];
        self.skipBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.skipBtn addTarget:self action:@selector(skipBtnClick) forControlEvents:UIControlEventTouchUpInside];

        [_adImageView addSubview:_skipBtn];
        [self addSubview:_adImageView];

        self.urlString = url;
    }
    return self;
}

- (UIImage *)launchImageWithType:(NSString *)type {

    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = type;
    NSString *launchImageName = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);

        if([viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            if([dict[@"UILaunchImageOrientation"] isEqualToString:@"Landscape"]) {
                imageSize = CGSizeMake(imageSize.height, imageSize.width);
            }
            if(CGSizeEqualToSize(imageSize, viewSize)) {
                launchImageName = dict[@"UILaunchImageName"];
                UIImage *image = [UIImage imageNamed:launchImageName];
                return image;
            }
        }
    }
    return nil;
}


- (void)startTimer {
    _count = adTime;
    [[NSRunLoop mainRunLoop] addTimer:self.countTimer forMode:NSRunLoopCommonModes];
}

- (void)setFilePath:(NSString *)filePath {
    _filePath = filePath;
    _adImageView.image = [UIImage imageWithContentsOfFile:filePath];
}


#pragma mark - 点击广告
- (void)tapGesHandle:(UITapGestureRecognizer*)recognizer {
    _isAD = YES;

    UIViewController *rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    TestWebVC *vc = [TestWebVC new];
    
    vc.url = self.urlString;
    [[rootVC xl_navigationController] pushViewController:vc animated:YES];
    [self startcloseAnimation];
}
#pragma mark - 点击跳过
- (void)skipBtnClick {
    _isAD = NO;
    [self startcloseAnimation];
}


#pragma mark - 关闭动画
- (void)startcloseAnimation{

    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = 0.5;
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:opacityAnimation forKey:@"animateOpacity"];

    NSTimeInterval timeInterval;

    if (_isAD) {
        timeInterval = 0.3;
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
- (void)closeAdImgAnimation {

    [_countTimer invalidate];
    _countTimer = nil;

    [self removeFromSuperview];
    
    self.window.hidden = YES;
    self.window = nil;
}

- (void)countDownEventHandle {
    if (_count == 0) {
        [_countTimer invalidate];
        _countTimer = nil;
        [self startcloseAnimation];
    } else {
        [self.skipBtn setTitle:[NSString stringWithFormat:@"%@ | 跳过",@(_count--)] forState:UIControlStateNormal];
    }
}


#pragma mark - lazy
- (NSTimer *)countTimer {
    if (_countTimer == nil) {

        _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownEventHandle) userInfo:nil repeats:YES];
    }
    return _countTimer;
}
@end
