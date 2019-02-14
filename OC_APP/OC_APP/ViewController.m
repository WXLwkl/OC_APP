//
//  ViewController.m
//  Demo
//
//  Created by 兴林 on 2016/10/12.
//  Copyright © 2016年 兴林. All rights reserved.
//

#import "ViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>


#import "UserInfo.h"
#import <MBProgressHUD.h>


#import "SAMKeychain.h"


#import "WriteViewController.h"

#import "ClickTextView.h"
#import "StarRateView.h"



#import "CSViewController.h"


#import "ClipImageView.h"
#import "GradientView.h"

#import "XLAutoRunLabel.h"
#import "TextFlowView.h"

#import "MyscrollView.h"
#import "BannerScrollView.h"

#import "XLAuthcodeView.h"

#import "SlideView.h"


#import "MainNavigationController.h"

#import "AppManager.h"

#import "UIViewController+KeyboardPop.h"

#import "WaterWaveView.h"
#import "PraiseEmitterBtn.h"

#import "LFUIView+Badge.h"


#import "ShowSignatureView.h"


#import "MarqueeView.h"

@interface ViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate, StarRateViewDelegate, XLAutoRunLabelDelegate, UITextFieldDelegate, SlideViewDelegate,UIScrollViewDelegate, ShowSignatureViewDelegate, MarqueeViewDelegate, BannerScrollViewDelegate> {
    
    UILabel*label_;
    
    XLAuthcodeView *autoCodeView;
    
    UIView *_holeShapeView;
    UILabel *_qiShuLabel;
    
    NSArray *adListArray;
}


@property (nonatomic, copy) NSArray<NSString *> *weathers;

@property (weak, nonatomic) IBOutlet UIImageView *imageV;



@property(nonatomic,strong)UIImage *rollImage;//滚动图片
@property(nonatomic,strong)UIImageView *rollImageView;//滚动图片View
@property(nonatomic,strong)NSTimer *rollTimer;//滚动视图计时器


@property (nonatomic, strong) NSDictionary *dic;

@end

@implementation ViewController


#pragma mark - life

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    self.dic = self.navigationController.navigationBar.titleTextAttributes;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage xl_imageWithColor:[THEME_color colorWithAlphaComponent:0.99]] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName: [UIFont systemFontOfSize:18]}];
    
    
    NSLog(@"%@", [AppManager appUUUID]);

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self xl_setNavBackItem];
    
    self.navigationItem.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];

    
    [self clickTextView];
    
//    return;
    
//    objc_msgSend()
    
    
    //倒计时
    //    [self countdown];
    //    //更换Icon图标
    //    [self changeIcon];
    //    [self regularExpressionClass];
    //
//        [self getAppMessage];
    
    //    if (IOS_Foundation_Before_8) {
    //
    //        NSLog(@"-------");
    //    }
    
//    [self loadRollImageView];
    //    [self circleProgressView];
    
    NSURL *url = [NSURL URLWithString:@"hhtps://www.xingl.com?taoken=111222&PayerID=666888"];
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:url.absoluteString];
    
    [components.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@=%@", obj.name,obj.value);
    }];
    
    
    
    NSArray *arr = @[@1,@2,@4,@3,@5];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"对象==%@",obj);
        NSLog(@"下标==%ld",(unsigned long)idx);
        if ([obj integerValue] == 4) {
            // 遍历到3时结束
            NSLog(@"结束");
            *stop = YES;
        }
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 400, 150, 50);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"开始" forState:UIControlStateNormal];
    btn.xl_hitTestEdgeInsets = UIEdgeInsetsMake(-20, -3, -50, -20);
    btn.xl_badgeValue = @"3";
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    WeakSelf(btn);
    
    [btn xl_addActionHandler:^{
        StrongSelf(btn);
        
        btn.xl_badgeValue = @"1223";
    }];
    [self.view addSubview:btn];
    return;
    [self changeAttributedPlaceholder];
    //    [self starView];
    
    //图片撕裂
    //    [ClipImageView addToCurrentView:self.view clipImage:[UIImage imageNamed:@"01"] backgroundImage:@"Default_image" animationComplete:^{
    //
    //    }];
    
    
    
    GradientView *waveView = [[GradientView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 225)];
    
    [self.view addSubview:waveView];
    
    
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"C-AvatarIcon"]];
    imgV.frame = CGRectMake(15, 20, 50, 50);
    [waveView addSubview:imgV];
    
    
    
//    [self.view xl_addTapActionWithBlock:^(UITapGestureRecognizer *gestureRecoginzer) {
//        NSLog(@"---");
//    }];
//    
//    
//    
//    [self.view xl_addLongPressActionWithBlock:^(UILongPressGestureRecognizer *gestureRecoginzer) {
//        
//        NSLog(@"---111");
//    }];
    
    
    
    
    
    
    
    UIImage *image = [UIImage imageNamed:@"image0"];
//    image = [image xl_imageWithTitle:@"你好啊！" fontSize:25 color:[UIColor orangeColor]];
    image = [image xl_mosaicImageWithLevel:5];
    
    UIImageView *imgVv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 80, 300, 100)];
    imgVv.image = image;
    
    [self.view addSubview:imgVv];
    
    
    
    
//    [self textViewPlaceholder];

    //    [self gradientLayerView];
    //    [self createAutoRunLabel];
    [self.view xl_removeAllSubviews];
    adListArray = @[@"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=118add3c6fd0f703f9b293dc38fb5148/faf2b2119313b07e5119db2301d7912397dd8c71.jpg",
                    @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1536321964171&di=22cd15162e6220948e0c222f9b522ddf&imgtype=0&src=http%3A%2F%2Fd.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2Fc8177f3e6709c93d038405d2923df8dcd10054a4.jpg",
                    @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1536321963416&di=a7e0f059d82f949fbec1a98527fa53b0&imgtype=0&src=http%3A%2F%2Fd.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F7e3e6709c93d70cfb8b9b028f5dcd100baa12b57.jpg",
                    @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1536321963416&di=a7e0f059d82f949fbec1a98527fa53b0&imgtype=0&src=http%3A%2F%2Fd.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F7e3e6709c93d70cfb8b9b028f5dcd100baa12b57.jpg",
                    @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1536321963416&di=a7e0f059d82f949fbec1a98527fa53b0&imgtype=0&src=http%3A%2F%2Fd.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F7e3e6709c93d70cfb8b9b028f5dcd100baa12b57.jpg"];
    
        [self loadBanner];
    
    //    [self loadAuthcodeView];
    //    [self slideView];
//    [self getDeviceMessage];
    
    
    
    
//    [self xl_alertWithTitle:@"xx" message:@"abcdefg" andOthers:@[@"cancel", @"ok"] animated:YES action:^(NSInteger index) {
//        if (index == 1) {
//            NSLog(@"ok");
//        }
//    }];
    
    
//    UIViewController *topmostVC = [UIViewController xl_currentViewController];

//    [self useNSDecimalNumber];
    
    
//    WaterWaveView *waterWave = [[WaterWaveView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    waterWave.backgroundColor = [UIColor blackColor];
//    waterWave.waveColor = [UIColor colorWithRed:20 / 255 green:255 / 255 blue:255 / 255 alpha:0.5];
////    self.waterWave.waveHeight = self.view.frame.size.height - 20;
////    waterWave.waveSpeed = 1;
////    waterWave.waveAmplitude = 15;
//    [self.view addSubview:waterWave];
    
    
//    [self testMoney];
//    [self.view xl_removeAllSubviews];
//
//    [self testNSMutableAttributedString];
//    
//    
//    [self testPraiseEmitterBtn];

//    [self labelScrollView];
    
    
//    UIButton *btnx = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnx.frame = CGRectMake(100, 100, 100, 50);
//    btnx.backgroundColor = [UIColor orangeColor];
//    [btnx addTarget:self action:@selector(showPopSignatureView:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btnx];
    
//    [self.view xl_removeAllSubviews];
    
//    CSViewController *vc = [CSViewController new];
//    vc.view.frame = self.view.bounds;
//    [self addChildViewController:vc];
//    [self.view addSubview:vc.view];
//    [self presentViewController:vc animated:YES completion:nil];

}
#pragma mark - 手写签名
- (void)showPopSignatureView:(UIButton *)sender {
    ShowSignatureView *socialSingnatureView = [[ShowSignatureView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    socialSingnatureView.delegate = self;
    [socialSingnatureView show];
}

#pragma mark - SocialSignatureViewDelegate

- (void)onSubmitBtn:(UIImage *)signatureImg {
    
    // signatureImg 签名的图片
    
//    self.showImageView.image = signatureImg;
}






- (void)testPraiseEmitterBtn {
    PraiseEmitterBtn *btn = [PraiseEmitterBtn buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 20, 20);
//    btn.backgroundColor = [UIColor orangeColor];
    [btn setImage:[UIImage imageNamed:@"praise_default"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"praise_select"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)clicked:(UIButton *)sender {
    [sender setSelected:!sender.selected];
    
    
}
#pragma mark - 测试 NSMutableAttributedString
- (void)testNSMutableAttributedString {
    NSString *stringx = @"你好呀，我默认颜色是label的textColor,但是我现在要通过NSForegroundColorAttributeName属性变成一个蓝色了，看好喽！";
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth-100, 300)];
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor grayColor];
    //背景颜色
    NSMutableAttributedString *attrStr = [stringx xl_setStringBackgroundColor:[UIColor redColor] range:NSMakeRange(1, 2)];
    [attrStr xl_setColor:[UIColor redColor] range:NSMakeRange(4, 4)];
//    [attrStr xl_setStrokeWidth:@(5) range:NSMakeRange(9, 3)];
    [attrStr xl_setStrikethroughStyle:(NSUnderlineStyleSingle) color:[UIColor redColor] range:NSMakeRange(8, 5)];
    [attrStr xl_setUnderlineStyle:(NSUnderlineStyleSingle) color:[UIColor redColor] range:NSMakeRange(13, 5)];
    
//    [attrStr xl_setExpansion:@(0.8) range:NSMakeRange(18, 5)];
//    [attrStr xl_setObliqueness:@(-0.5) range:NSMakeRange(18, 5)];
    [attrStr xl_setBaselineOffset:@(-5) range:NSMakeRange(18, 5)];
//    [attrStr xl_setKern:@(10) range:NSMakeRange(23, 6)];
    
    
    
    label.attributedText = attrStr;
    
//    label.attributedText = [stringx xl_setStringFont:[UIFont systemFontOfSize:30] range:NSMakeRange(4, 1)];
//    label.attributedText = [stringx xl_setStringColor:[UIColor redColor] range:NSMakeRange(6, 2)];
//    label.attributedText = [stringx xl_setStringStrokeColor:[UIColor redColor] width:10 range:NSMakeRange(6, 2)];
//    label.attributedText = [stringx xl_setStringSpace:5 range:NSMakeRange(6, 5)];
//    label.attributedText = [stringx xl_setStringGradient:0.2 range:NSMakeRange(6, 5)];
//    label.attributedText = [stringx xl_setStringExpansion:1 range:NSMakeRange(6, 5)];
//    label.attributedText = [stringx xl_setstringBaselineOffset:5 range:NSMakeRange(6, 5)];
//    label.attributedText = [stringx xl_setStringShadowOffset:CGSizeMake(0,0.5) shadowRadius:1 color:[UIColor purpleColor] range:NSMakeRange(0, 5)];
//    label.attributedText = [stringx xl_setStringUnderLine:NSUnderlineStyleDouble color:[UIColor redColor] range:NSMakeRange(6, 5)];
//    label.attributedText = [stringx xl_setStringDeleteLine:NSUnderlineStyleDouble color:[UIColor redColor] range:NSMakeRange(6, 5)];
//    label.attributedText = [stringx xl_setStringWithImage:@"01" bounds:CGRectMake(0, 20, 50, 50) index:5];
    [self.view addSubview:label];
    [label lf_showNumberBadge:5 sizeType:(LFBadgeSizeTypeNormal)];
}
#pragma mark - 测试金额格式化
- (void)testMoney {
    // 测试数据:
    NSString *str = @"12394862.57";
    
    
    NSLog(@"stringChangeMoneyWithDouble== %@", [NSString xl_stringChangeMoneyWithDouble:12394862.57]);
    NSLog(@"NSNumberFormatterNoStyle== %@", [NSString xl_stringChangeMoneyWithStr:str numberStyle:NSNumberFormatterNoStyle]);
    NSLog(@"NSNumberFormatterDecimalStyle== %@", [NSString xl_stringChangeMoneyWithStr:str numberStyle:NSNumberFormatterDecimalStyle]);
    NSLog(@"NSNumberFormatterCurrencyStyle== %@", [NSString xl_stringChangeMoneyWithStr:str numberStyle:NSNumberFormatterCurrencyStyle]);
    NSLog(@"NSNumberFormatterPercentStyle== %@", [NSString xl_stringChangeMoneyWithStr:str numberStyle:NSNumberFormatterPercentStyle]);
    NSLog(@"NSNumberFormatterScientificStyle== %@", [NSString xl_stringChangeMoneyWithStr:str numberStyle:NSNumberFormatterScientificStyle]);
    NSLog(@"NSNumberFormatterSpellOutStyle== %@", [NSString xl_stringChangeMoneyWithStr:str numberStyle:NSNumberFormatterSpellOutStyle]);
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:self.dic];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];

    [self.view makeToast:@"xxxxxxx" duration:2.0 position:nil title:@"YYY" image:[UIImage imageNamed:@"s"]];
//
//
//    return;

//    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 50, 50)];
//    lab.text = @"xxx";
//    lab.backgroundColor = [UIColor redColor];
//    lab.textAlignment = NSTextAlignmentCenter;
//
//    [self.view showToast:lab duration:3 position:ToastPositionCenter tapCallback:^{
//        NSLog(@"------");
//    }];


}
//金融产品，对数字是要非常敏感，提高精确度。
- (void)useNSDecimalNumber {
    float a = 0.01;
    int b = 99999999;
    double c = 0.0;
    c = a * b;
    NSLog(@"%f",c);
    NSLog(@"%.2f",c);
    
    c = a*(double)b;
    NSLog(@"%f",c);
    NSLog(@"%.2f",c);
    
    NSString *aString = [NSString stringWithFormat:@"%.2f", a];
    NSString *bString = [NSString stringWithFormat:@"%.2f", (double)b];
    c = [aString doubleValue] * [bString doubleValue];
    NSLog(@"%.2f",c);
    
    
    NSDecimalNumber *decimalNumber1 = [NSDecimalNumber decimalNumberWithString:aString];
    NSDecimalNumber *decimalNumber2 = [NSDecimalNumber decimalNumberWithString:bString];
    NSDecimalNumber *result = [decimalNumber1 decimalNumberByMultiplyingBy:decimalNumber2];
    NSLog(@"%@",result);
}

#pragma mark - 多按钮节点
- (void)slideView {
    SlideView *shapeView = [[SlideView alloc] initWithFrame:CGRectMake(10, 60, self.view.frame.size.width -20, 30) withLayerColor:[UIColor colorWithRed:0/255.0 green:210/255.0 blue:87/255.0 alpha:1]];
    
    // 2.
    shapeView.delegate = self;
    
    //3.
    [self.view addSubview:shapeView];
    
    
    _qiShuLabel = [[UILabel alloc]init];
    
    _qiShuLabel.center = CGPointMake(self.view.frame.size.width/2-30, 160);
    
    _qiShuLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    
    _qiShuLabel.font = [UIFont systemFontOfSize:14];
    
    _qiShuLabel.text = @"1期" ;
    [_qiShuLabel sizeToFit];
    
    [self.view addSubview:_qiShuLabel];
}
- (void)selectedSlideViewWithString:(NSString *)string {
    _qiShuLabel.text = string;
    [_qiShuLabel sizeToFit];
    
}

#pragma mark - 本地验证码
- (void)loadAuthcodeView {
    autoCodeView = [[XLAuthcodeView alloc] init];
    autoCodeView.frame = CGRectMake(0, 300, 100, 30);
    [self.view addSubview:autoCodeView];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(50, 230, [UIScreen mainScreen].bounds.size.width-100, 50)];
    textField.layer.borderWidth = 2.0;
    textField.layer.cornerRadius = 5.0;
    textField.font = [UIFont systemFontOfSize:21];
    textField.placeholder = @"请输入验证码!";
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.backgroundColor = [UIColor clearColor];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate = self;
    [self.view addSubview:textField];
    
    NSLog(@"%@",autoCodeView.authCodeStr);
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
#pragma mark 输入框代理，点击return 按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //判断输入的是否为验证图片中显示的验证码
    if ([textField.text isEqualToString:autoCodeView.authCodeStr])
    {
        //正确弹出警告款提示正确
        UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"恭喜您 ^o^" message:@"验证成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alview show];
    }
    else
    {
        //验证不匹配，验证码和输入框抖动
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        anim.repeatCount = 1;
        anim.values = @[@-20,@20,@-20];
        //        [authCodeView.layer addAnimation:anim forKey:nil];
        [textField.layer addAnimation:anim forKey:nil];
    }
    
    return YES;
}

#pragma mark - 轮播图
- (void)loadBanner {
    BannerScrollView *banner = [[BannerScrollView alloc] initWithFrame:CGRectMake(0, 100, [[UIScreen mainScreen] bounds].size.width, 150)];
    banner.delegate = self;
    banner.pullStyle = YES;

    banner.scrollDuration = 5.0;
    banner.autoScroll = YES;
    
    
    banner.pageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    banner.pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    banner.backgroundColor = [UIColor redColor];
    [self.view addSubview:banner];
}

- (NSInteger)bannerScrollViewNumbersOfContents:(BannerScrollView *)imageScrollView {
    return adListArray.count;
}

- (void)bannerScrollView:(BannerScrollView *)imageScrollView
            imageAtIndex:(NSInteger)index
               imageView:(UIImageView *)imageView {
    
    if (index >= adListArray.count) return;
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:adListArray[index]]
                 placeholderImage:nil
                          options:SDWebImageProgressiveDownload];
}

- (void)bannerScrollView:(BannerScrollView *)imageScrollView
     clickContentAtIndex:(NSInteger)index {
    
    NSLog(@"-点击---%ld", index);
}

- (void)bannerScrollView:(BannerScrollView *)imageScrollView
            currentIndex:(NSInteger)currentIndex {
    NSLog(@"----%ld", currentIndex);
}

#pragma mark - 文字轮播
- (void)labelScrollView {
//    MyscrollView *ccpView = [[MyscrollView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 50)];
//
//    ccpView.titleArray = [NSArray arrayWithObjects:@"iPhone6s上线32G内存手机你怎么看？",@"亲爱的朋友们2016年还有100天就要过去了,2017年您准备好了吗?",@"今年双11您预算了几个月的工资？",@"高德与百度互掐，你更看好哪方？", nil];
//
//    ccpView.titleFont = 18;
//
//    ccpView.titleColor = [UIColor blackColor];
//
//    ccpView.BGColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1];
//
//    [ccpView clickTitleLabel:^(NSInteger index,NSString *titleString) {
//
//        NSLog(@"%ld-----%@",(long)index,titleString);
//
//    }];
//
//    [self.view addSubview:ccpView];
    
    MarqueeView *marqueeView = [[MarqueeView alloc] init];
    marqueeView.delegate = self;
    marqueeView.frame = CGRectMake(0,10, self.view.frame.size.width, 40);
    marqueeView.backgroundColor = [UIColor brownColor];
    [self.view addSubview:marqueeView];
    
}

- (void)marqueeViewDidSelectAtIndex:(NSInteger)index {
    
    NSLog(@"%ld", index);
}

#pragma mark - 跑马灯
- (void)createAutoRunLabel {
    XLAutoRunLabel *runLabel = [[XLAutoRunLabel alloc] initWithFrame:CGRectMake(0, 100, 400, 50)];
    runLabel.tag = 100;
    runLabel.backgroundColor = [UIColor redColor];
    runLabel.delegate = self;
    runLabel.directionType = RightType;
    [self.view addSubview:runLabel];
    [runLabel addContentView:[self createLabelWithText:@"繁华声 遁入空门 折煞了梦偏冷等" textColor:[self randomColor] labelFont:[UIFont systemFontOfSize:14]]];
    [runLabel startAnimation];
    
    
    TextFlowView *AA = [[TextFlowView alloc] initWithFrame:CGRectMake(0, 200, 460, 50) Text:@"繁华声 遁入空门 折煞了梦偏冷 辗转一生 情债又几 如你默认 生死枯等 枯等一圈 又一圈的 浮图塔 断了几层 断了谁的痛直奔 一盏残灯 倾塌的山门 容我再等 历史转身 等酒香醇 等你弹 一曲古筝"];
    
    [self.view addSubview:AA];
    
    
}
- (void)operateLabel: (XLAutoRunLabel *)autoLabel animationDidStopFinished: (BOOL)finished {
    
//    XLAutoRunLabel *runLabel = [self.view viewWithTag:100];
//    [runLabel stopAnimation];
    NSLog(@"-----");
}
- (UILabel *)createLabelWithText: (NSString *)text textColor:(UIColor *)textColor labelFont:(UIFont *)font {
    NSString *string = [NSString stringWithFormat:@"%@", text];
    CGFloat width = [self getWidthByTitle:string font:font];
    UILabel *labelx = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 50)];
    labelx.font = font;
    labelx.text = string;
    labelx.textColor = textColor;
    return labelx;
}
- (CGFloat)getWidthByTitle:(NSString *)string font:(UIFont *)font {
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, 500) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font} context:nil];
    return rect.size.width;
    
}

- (UIColor *)randomColor {
    return [UIColor colorWithRed:[self randomValue] green:[self randomValue] blue:[self randomValue] alpha:1];
}

- (CGFloat)randomValue {
    return arc4random()%255 / 255.0f;
}

#pragma mark - 渐变
- (void)gradientLayerView {
    UIView *theView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:theView];
    [self.view xl_setGradientLayer:RGBColor(0, 226, 154) endColor:RGBColor(0, 137, 108)];
}



#pragma mark - 改变输入框占位符
- (void)changeAttributedPlaceholder {
    UITextField *textF = [[UITextField alloc] initWithFrame:CGRectMake(200, 300, 130, 50)];
//    textF.font = [UIFont systemFontOfSize:25];
    textF.borderStyle = UITextBorderStyleRoundedRect;
    textF.placeholder = @"账号";
    textF.xl_placeholderColor = [UIColor redColor];
    
//    NSAttributedString *attributeText = [[NSAttributedString alloc] initWithString:@"name" attributes:@{NSForegroundColorAttributeName:[UIColor redColor], NSFontAttributeName:textF.font}];
//
//    textF.attributedPlaceholder = attributeText;
    [self.view addSubview:textF];
}

#pragma mark - 计算label的行数
- (void)numberOfline {
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(290, 290, 80, 100)];
    
    label2.text = @"33431dfadfdafadsfasfsdf";
    label2.numberOfLines = 0;
    label2.font = [UIFont systemFontOfSize:13];
    label2.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:label2];
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:13]};
    // 总高度
    CGFloat totalHeight = [label2.text  boundingRectWithSize:label2.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.height;
    // 每行文字的高度
    CGFloat lineHeight = label2.font.lineHeight;
    // 行数 = 总高度除以每行高度
    NSInteger lineCount = totalHeight / lineHeight;
    NSLog(@"lineCount:%ld",(long)lineCount);
}

#pragma mark - 图片滚动
- (void)loadRollImageView {
    
    _rollImage = [UIImage imageNamed:@"滚动图片.jpeg"];
    [self addRollImageAndTimer];
    
}
- (void)addRollImageAndTimer {
    if (_rollImage != nil && _rollImage.size.height > _rollImage.size.width) {
        NSLog(@"Error:滚动图片的高度比宽度高,不能进行横向滚动!");
    } else {
        _rollImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.height * _rollImage.size.width / _rollImage.size.height, self.view.bounds.size.height)];
        _rollImageView.image = _rollImage;
        
        self.rollTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(rollImageAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:self.rollTimer forMode:NSRunLoopCommonModes];
        [self.view addSubview:_rollImageView];
        
        [self.rollTimer fire];
    }
}

int rollX = 0;
bool isReverse = NO;//是否反向翻转

- (void)rollImageAction {
    if (rollX-1 > (self.view.bounds.size.width-self.view.bounds.size.height*_rollImage.size.width/_rollImage.size.height) && !isReverse) {
        rollX -= 1;
        _rollImageView.frame = CGRectMake(rollX, 0, self.view.bounds.size.height * _rollImage.size.width / _rollImage.size.height, self.view.bounds.size.height);
    } else {
        isReverse = YES;
    }
    if (rollX+1 < 0 && isReverse) {
        rollX += 1;
        _rollImageView.frame = CGRectMake(rollX, 0, self.view.bounds.size.height * _rollImage.size.width / _rollImage.size.height, self.view.bounds.size.height);
    } else {
        isReverse = NO;
    }
}

#pragma mark - 星级评分
- (void)starView {
    StarRateView *starRateView = [[StarRateView alloc] initWithFrame:CGRectMake(20, 60, 200, 30)];
    starRateView.isAnimation = YES;
    starRateView.rateStyle = RateStyleIncomple;
    starRateView.tag = 1;
    starRateView.delegate = self;
    [self.view addSubview:starRateView];
    
    StarRateView *starRateView2 = [[StarRateView alloc] initWithFrame:CGRectMake(20, 100, 200, 30) numberOfStars:5 rateStyle:RateStyleHalf isAnimation:YES delegate:self];
    starRateView2.tag = 2;
    [self.view addSubview:starRateView2];
    
    StarRateView *starRateView3 = [[StarRateView alloc] initWithFrame:CGRectMake(20, 140, 200, 30) finishBlock:^(CGFloat currentScore) {
        NSLog(@"3----  %f",currentScore);
    }];
    [self.view addSubview:starRateView3];
    
    StarRateView *starRateView4 = [[StarRateView alloc] initWithFrame:CGRectMake(20, 180, 200, 30) numberOfStars:5 rateStyle:RateStyleHalf isAnimation:YES finishBlock:^(CGFloat currentScore) {
        NSLog(@"4----  %f",currentScore);
    }];
    [self.view addSubview:starRateView4];
}
-(void)starRateView:(StarRateView *)starRateView currentScore:(CGFloat)currentScore{
    NSLog(@"%ld----  %f",(long)starRateView.tag,currentScore);
}
#pragma mark - textViewPlaceholder
- (void)textViewPlaceholder {
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 120)];
    textView.font = [UIFont systemFontOfSize:16];
    textView.layer.borderWidth = 1;
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textView.xl_placeholder = @"向厂家反馈同业相关活动、产品信息、用于市场分析。向厂家反馈同业相关活动、产品信息、用于市场分析。向厂家反馈同业相关活动、产品信息、用于市场分析。向厂家反馈同业相关活动、产品信息、用于市场分析。向厂家反馈同业相关活动、产品信息、用于市场分析。";
    [self.view addSubview:textView];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 230, [UIScreen mainScreen].bounds.size.width, 50)];
    textField.font = [UIFont systemFontOfSize:16];
    textField.layer.borderWidth = 1;
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.placeholder = @"向厂家反馈同业相关活动、产品信息、用于市场分析。向厂家反馈同业相关活动、产品信息、用于市场分析。向厂家反馈同业相关活动、产品信息、用于市场分析。向厂家反馈同业相关活动、产品信息、用于市场分析。向厂家反馈同业相关活动、产品信息、用于市场分析。";
    [self.view addSubview:textField];
}

#pragma mark - 部分文字可点击的TextView
- (void)clickTextView {
    ClickTextView *clickTextView = [[ClickTextView alloc] initWithFrame:CGRectMake(50, 50, 300, 30)];
    [self.view addSubview:clickTextView];
    
    // 方便测试，设置textView的边框已经背景
    //    clickTextView.backgroundColor = [UIColor cyanColor];
    clickTextView.layer.borderWidth = 1;
    clickTextView.layer.borderColor = [UIColor redColor].CGColor;
    clickTextView.font = [UIFont systemFontOfSize:13];
    clickTextView.textAlignment = NSTextAlignmentRight;
    //    clickTextView.textColor = [UIColor redColor];
    
    
    NSString *content = @"承诺书都差不多";
    // 设置文字
    clickTextView.text = content;
    
    // 设置期中的一段文字有下划线，下划线的颜色为蓝色，点击下划线文字有相关的点击效果
    
    [clickTextView setUnderlineTextWithUnderlineText:@"承诺书" withUnderlineColor:[UIColor blueColor] withClickCoverColor:[UIColor greenColor] withBlock:^(NSString *clickText) {
        NSLog(@"clickText = %@",clickText);
    }];
    
    // 设置期中的一段文字有下划线，下划线的颜色没有设置，点击下划线文字没有点击效果
    [clickTextView setUnderlineTextWithUnderlineText:@"不到催上半场低俗" withUnderlineColor:nil withClickCoverColor:nil withBlock:^(NSString *clickText) {
        NSLog(@"clickText = %@",clickText);
    }];
}
- (void)btnClick1 {
    WriteViewController *vc = [[WriteViewController alloc] init];
    
    kAppDelegate.window.rootViewController = vc;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 正则表达式专用类
- (void)regularExpressionClass {
    
    NSString *searchText = @"115823456743";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"1[358][0-9]{9}" options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) return;
    NSTextCheckingResult *result = [regex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
    
    
    if (result) {
        NSLog(@"%@", [searchText substringWithRange:result.range]);
    }
    
    //    NSString *searchText = @"15823456743";
    //    NSString *regexStr = @"1[358][0-9]{9}";
    //    NSError *error;
    //    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    //    if (error) return;
    //    NSInteger count = [regular numberOfMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length)];
    //
    //    NSLog(@"%ld", count);
    
}

#pragma mark - 异步下载图片
- (void)asyncDownload {
    //    异步下载图片
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *imageurl = @"http://pic.paopaoche.net/up/2012-2/20122220201612322865.png";
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageurl]];
        UIImage *imagex = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageV.image = imagex;
        });
    });
}

#pragma mark - 字符串中获取金额
- (void)amountMoney {
    NSString *string = @"售价为：¥299.4元";
    NSString *result = [string stringByReplacingOccurrencesOfString:@"[^0-9.]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, string.length)];
    
    NSLog(@"---->result: %@", result);
}
#pragma mark - 测试数组和字典的中文输出
- (void)testLog {
    
    NSArray *arr = @[@"王", @"兴", @"林"];
    NSLog(@"%@", arr);
    NSDictionary *dic = @{@"name": @"王兴林", @"age": @26, @"job": @"iOS开发工程师"};
    NSLog(@"%@", dic);
}
#pragma mark - 倒计时
- (void)countdown {
    
    label_=[[UILabel alloc]initWithFrame:CGRectMake(50, 70, self.view.frame.size.width-100, 50)];
    label_.backgroundColor=[UIColor greenColor];
    label_.font=[UIFont systemFontOfSize:20];
    label_.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:label_];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}
- (void)timerFireMethod:(NSTimer *)timer {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    now = [NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    
    
    NSInteger currentYear = [comps year];
    NSInteger currentMonth = [comps month];
    NSInteger currentDay = [comps day];
    
    NSCalendar *calendar1 = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:currentYear];
    [components setMonth:currentMonth];
    [components setDay:currentDay];
    [components setHour:18];
    [components setMinute:30];
    [components setSecond:0];
    NSDate *fireDate = [calendar dateFromComponents:components];//目标时间
    NSDate *today1 = [NSDate date];//当前时间
    
    unsigned int unitFlags1 = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *d = [calendar1 components:unitFlags1 fromDate:today1 toDate:fireDate options:0];//计算时间差
    label_.text = [NSString stringWithFormat:@"%zi天%zi小时%zi分%zi秒", [d day], [d hour], [d minute], [d second]];//倒计时显示
}
#pragma mark - 更换icon图标
- (void)changeIcon {
    
    self.weathers = @[@"cloudy", @"heavyRain", @"lightRain", @"snow", @"sunny"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 200, 50, 20);
    btn.backgroundColor = [UIColor grayColor];
    [btn setTitle:@"开始" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(changeIconButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)changeIconButtonClick {
    NSString *weather = self.weathers[arc4random() % self.weathers.count];
    
    XLLog(@"%@", weather);
    
    [self setAppIconWithName:weather];
    
    // 测试推送上是否使用了20尺寸的图标
    UILocalNotification *noti = [[UILocalNotification alloc] init];
    noti.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    noti.alertBody = @"我们看看推送上面的App图标";
    [[UIApplication sharedApplication] scheduleLocalNotification:noti];
}

- (void)setAppIconWithName:(NSString *)iconName {
    
    //    想更换icon图片，必须在info.plist中添加 Icon files (iOS 5) --> CFBundleAlternateIcons ...
    if (![[UIApplication sharedApplication] supportsAlternateIcons]) {
        XLLog(@"不支持更换Icon");
        return;
    }
    if (XL_IsEmptyString(iconName)) {
        return;
    }
    [[UIApplication sharedApplication] setAlternateIconName:iconName completionHandler:^(NSError * _Nullable error) {
        if (error) {
            XLLog(@"更换app图标发生错误：%@", error);
        } else {
            XLLog(@"成功！");
        }
    }];
}
#pragma mark - AlertController不同颜色
- (void)btnClick {
    
    NSMutableAttributedString *attTitle = [[NSMutableAttributedString alloc]initWithString:@"标题1" attributes:@{NSForegroundColorAttributeName:[UIColor blueColor],NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    NSMutableAttributedString *attMessage = [[NSMutableAttributedString alloc]initWithString:@"message" attributes:@{NSForegroundColorAttributeName:[UIColor purpleColor],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    
    UIAlertController *action = [UIAlertController alertControllerWithTitle:@"标题1" message:@"message" preferredStyle:UIAlertControllerStyleActionSheet];
    [action setValue:attTitle forKey:@"attributedTitle"];
    [action setValue:attMessage forKey:@"attributedMessage"];
    
    UIAlertAction *alert1 = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //        [self loadCameraMovie];
        
    }];
    [alert1 setValue:[UIColor greenColor] forKey:@"titleTextColor"];
    [action addAction:alert1];
    
    UIAlertAction *alert2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert2 setValue:[UIColor cyanColor] forKey:@"titleTextColor"];
    [action addAction:alert2];
    
    UIAlertAction *alert3 = [UIAlertAction actionWithTitle:@"从相册选择视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert3 setValue:[UIColor orangeColor] forKey:@"titleTextColor"];
    [action addAction:alert3];
    
    UIAlertAction *alert4 = [UIAlertAction actionWithTitle:@"从相册选择照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert4 setValue:[UIColor brownColor] forKey:@"titleTextColor"];
    [action addAction:alert4];
    
    UIAlertAction *alert5 = [UIAlertAction actionWithTitle:@"从相册选择多张照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert5 setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    [action addAction:alert5];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [cancel setValue:[UIColor redColor] forKey:@"titleTextColor"];
    [action addAction:cancel];
    [self presentViewController:action animated:YES completion:nil];
}

#pragma mark - UIToorbar
- (void)createToorbar {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kScreenHeight   -44, kScreenWidth, 44)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    toolbar.barTintColor = [UIColor redColor];
    
    UIBarButtonItem *addItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    
    UIBarButtonItem *saveItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(add)];
    
    UIBarButtonItem *editItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(add)];
    
    toolbar.items = @[addItem,saveItem,editItem];
    
    [self.view addSubview:toolbar];
}

- (void)add {
    NSLog(@"------");
}
#pragma mark - 测试单例类
- (void)singletonClass {
    
    UserInfo *info1 = [UserInfo sharedInstance];
    info1.userName = @"小明";
    info1.userAge = @"22";
    NSLog(@"%@", info1);
    
    UserInfo *info2 = [[UserInfo alloc] init];
    NSLog(@"%@", info2);
    
    UserInfo *info3 = [info2 copy];
    NSLog(@"%@", info3);
}


#pragma mark - 获取手机信息
- (void)getAppMessage {
    //手机序列号
    //    NSString* identifierNumber = [[UIDevice currentDevice] uniqueIdentifier];
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    NSLog(@"手机序列号: %@",identifierForVendor);
    
    //手机别名： 用户定义的名称
    NSString* userPhoneName = [[UIDevice currentDevice] name];
    NSLog(@"手机别名: %@", userPhoneName);
    //设备名称
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    NSLog(@"设备名称: %@",deviceName );
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"手机系统版本: %@", phoneVersion);
    //手机型号
    NSString* phoneModel = [[UIDevice currentDevice] model];
    NSLog(@"手机型号: %@",phoneModel );
    //地方型号  （国际化区域名称）
    NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
    NSLog(@"国际化区域名称: %@",localPhoneModel );
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用名称
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSLog(@"当前应用名称：%@",appCurName);
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前应用软件版本:%@",appCurVersion);
    // 当前应用版本号码   int类型
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"当前应用版本号码：%@",appCurVersionNum);
}

#pragma mark - 获取设备信息
- (void)getDeviceMessage {
    CGFloat all = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *attributes = [fileManager attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    NSNumber *num = attributes[NSFileSystemSize];
    
    all = [num doubleValue] / (powf(1024, 3));
    NSLog(@"容量%.2fG",all);
    
    NSLog(@"mac地址：%@", [UIDevice xl_macAddress]);
    NSLog(@"cpu个数：%lu",(unsigned long)[UIDevice xl_cpuNumber]);
    NSLog(@"系统版本：%@",[UIDevice xl_systemVersion]);
    NSLog(@"摄像头：%d",[UIDevice xl_hasCamera]);
    
    NSLog(@"硬盘总空间----%lu  ---->：%.2f",(unsigned long)[UIDevice xl_totalDiskSpaceMBytes],(unsigned long)[UIDevice xl_totalDiskSpaceMBytes] / (powf(1024, 1)));
    NSLog(@"可硬盘空间----%lu  ---->：%.2f",(unsigned long)[UIDevice xl_freeDiskSpaceMBytes],(unsigned long)[UIDevice xl_freeDiskSpaceMBytes] / (powf(1024, 1)));
    
    
    NSLog(@"设备为：%@",[UIDevice xl_getDeviceName]);
    NSLog(@"是否越狱：%d", [UIDevice xl_isJailbroken]);
    
    
    NSLog(@"总内存----%lu   ---->：%f",(unsigned long)[UIDevice xl_totalMemoryBytes],(unsigned long)[UIDevice xl_totalMemoryBytes] / (powf(1024, 2)));
    NSLog(@"可用内存----%lu  ---->：%f",(unsigned long)[UIDevice xl_freeMemoryBytes] ,(unsigned long)[UIDevice xl_freeMemoryBytes] / (powf(1024, 2)));
    
    NSLog(@"活跃内存：%f",[UIDevice xl_getActiveMemory] / (powf(1024, 2)));
    NSLog(@"不活跃内存：%f",[UIDevice xl_getInActiveMemory] / (powf(1024, 2)));
    
    NSLog(@"其他：%f",[UIDevice xl_getWiredMemory] / (powf(1024, 2)));
}

@end
