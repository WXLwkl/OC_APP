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

#import <Toast/UIView+Toast.h>
#import "SAMKeychain.h"

#import "UIImage+Common.h"
#import "UIImage+QR.h"


#import "UITextView+Placeholder.h"



#import "WriteViewController.h"

#import "ClickTextView.h"
#import "StarRateView.h"
@interface ViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate, StarRateViewDelegate> {

        UILabel*label;
}

@property (nonatomic, copy) NSArray<NSString *> *weathers;

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (nonatomic, strong) AVCaptureSession *session;
@end

@implementation ViewController


#pragma mark - life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
    
    
    
    
    //倒计时
//    [self countdown];
//    //更换Icon图标
//    [self changeIcon];
//    [self regularExpressionClass];
//    
//    [self getAppMessage];

//    if (IOS_Foundation_Before_8) {
//        
//        NSLog(@"-------");
//    }
    
    
    
    

    

    
    
    [self starView];
    
    
 
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
    textView.placeholder = @"向厂家反馈同业相关活动、产品信息、用于市场分析。向厂家反馈同业相关活动、产品信息、用于市场分析。向厂家反馈同业相关活动、产品信息、用于市场分析。向厂家反馈同业相关活动、产品信息、用于市场分析。向厂家反馈同业相关活动、产品信息、用于市场分析。";
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
    ClickTextView *clickTextView = [[ClickTextView alloc] initWithFrame:CGRectMake(50, 50, 300, 300)];
    [self.view addSubview:clickTextView];
    
    // 方便测试，设置textView的边框已经背景
    //    clickTextView.backgroundColor = [UIColor cyanColor];
    clickTextView.layer.borderWidth = 1;
    clickTextView.layer.borderColor = [UIColor redColor].CGColor;
    clickTextView.font = [UIFont systemFontOfSize:30];
    //    clickTextView.textColor = [UIColor redColor];
    
    
    NSString *content = @"1234567890承诺书都差不多岁尺布斗粟CBD死UC收不到催上半场低俗";
    // 设置文字
    clickTextView.text = content;
    
    // 设置期中的一段文字有下划线，下划线的颜色为蓝色，点击下划线文字有相关的点击效果
    
    [clickTextView setUnderlineTextWithUnderlineText:@"承诺书都差不多" withUnderlineColor:[UIColor blueColor] withClickCoverColor:[UIColor greenColor] withBlock:^(NSString *clickText) {
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

#pragma mark - 读取UUID
- (void)retrieveUUUID {
    
    //从钥匙串读取UUID：
    NSString *retrieveuuid = [SAMKeychain passwordForService:@"com.yourapp.yourcompany"account:@"user"];
    NSLog(@"----->%@", retrieveuuid);
    if (XL_IsEmptyString(retrieveuuid)) {
        //在钥匙串中写入UUID
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        assert(uuid != NULL);
        CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
        
        NSLog(@"%@",[NSString stringWithFormat:@"%@", uuidStr]);
        
        [SAMKeychain setPassword: [NSString stringWithFormat:@"%@", uuidStr]
                      forService:@"com.yourapp.yourcompany"account:@"user"];
    }
    
    
    
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
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(50, 70, self.view.frame.size.width-100, 50)];
    label.backgroundColor=[UIColor greenColor];
    label.font=[UIFont systemFontOfSize:20];
    label.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}
- (void)timerFireMethod:(NSTimer *)timer
{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit;
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
    
    unsigned int unitFlags1 = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *d = [calendar1 components:unitFlags1 fromDate:today1 toDate:fireDate options:0];//计算时间差
    label.text = [NSString stringWithFormat:@"%zi天%zi小时%zi分%zi秒", [d day], [d hour], [d minute], [d second]];//倒计时显示
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

#pragma mark - 根据环境判断是否开启闪光灯
- (IBAction)sss:(id)sender {
    
    
    [self getTorch];
    
    
    DISPATCH_ONCE_BLOCK(^(){
        
        NSLog(@"----");
        //        UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:@[[[NSBundle mainBundle] URLForResource:@"Steve" withExtension:@"pdf"]] applicationActivities:nil/*@[[[ZSCustomActivity alloc] init]]*/];
        //
        //        // hide AirDrop
        //        //    excludedActivityTypes 这里是要隐藏的类型
        //        //     activity.excludedActivityTypes = @[UIActivityTypeAirDrop];
        //        //
        //        // incorrect usage
        //        // [self.navigationController pushViewController:activity animated:YES];
        //
        //        UIPopoverPresentationController *popover = activity.popoverPresentationController;
        //        if (popover) {
        //            popover.sourceView = sender;
        //            popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
        //        }
        //        
        //        [self presentViewController:activity animated:YES completion:NULL];
    });
}
- (void)getTorch {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc]initWithDevice:device error:nil];
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [output setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }
    if ([self.session canAddOutput:output]) {
        [self.session addOutput:output];
    }
    [self.session startRunning];
    
}

- (void)captureOutput:(AVCaptureOutput*)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection*)connection {
    CFDictionaryRef metadataDict =CMCopyDictionaryOfAttachments(NULL,sampleBuffer,
                                                                kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:
                              (__bridge NSDictionary*)metadataDict];
    
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString*)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString*)kCGImagePropertyExifBrightnessValue] floatValue];
    NSLog(@"%f",brightnessValue);
    // 根据brightnessValue的值来打开和关闭闪光灯
    AVCaptureDevice*device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    BOOL result = [device hasTorch];// 判断设备是否有闪光灯
    if((brightnessValue <0) && result) {
        // 打开闪光灯
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOn];//开
        [device unlockForConfiguration];
    }else if((brightnessValue >0) && result) {
        // 关闭闪光灯
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOff];//关
        [device unlockForConfiguration];    
    }
}
#pragma mark - UIToorbar
- (void)createToorbar {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kScreenHeight   -44, kScreenWidth, 44)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    toolbar.barTintColor = [UIColor redColor];
    
    UIBarButtonItem *addItem=[[ UIBarButtonItem alloc ] initWithBarButtonSystemItem : UIBarButtonSystemItemAdd target : self action : @selector(add) ];
    
    UIBarButtonItem *saveItem=[[ UIBarButtonItem alloc ] initWithBarButtonSystemItem : UIBarButtonSystemItemSave target : self action : @selector(add)];
    
    UIBarButtonItem *editItem=[[ UIBarButtonItem alloc ] initWithBarButtonSystemItem : UIBarButtonSystemItemEdit target : self action : @selector(add) ];
    
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




@end
