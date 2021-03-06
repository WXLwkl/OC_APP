//
//  QRMainViewController.m
//  OC_APP
//
//  Created by xingl on 2017/7/21.
//  Copyright © 2017年 兴林. All rights reserved.
//

#define QRCodeWidth  260.0   //正方形二维码的边长
//#define SCREENWidth  [UIScreen mainScreen].bounds.size.width   //设备屏幕的宽度
//#define SCREENHeight [UIScreen mainScreen].bounds.size.height //设备屏幕的高度

#import "QRMainViewController.h"
#import "MyQRViewController.h"

#import <AVFoundation/AVFoundation.h>//原生二维码扫描必须导入这个框架
#import "UIView+Common.h"


#define kScanningButtonPadding 36


#import "ScanningView.h"
#import "CaptureHelper.h"

@interface QRMainViewController ()
///<AVCaptureMetadataOutputObjectsDelegate>
//@property (nonatomic,strong)AVCaptureSession *session;
//@property (nonatomic, strong) UIImageView *scanNetImageView;

@property (nonatomic, strong) ScanningView *scanningView;
@property (nonatomic, strong) CaptureHelper *captureHelper;

@property (nonatomic, strong) UIView *preview;
@property (nonatomic, strong) UIView *buttonContainerView;
@property (nonatomic, strong) UIButton *scanQRCodeButton;
@property (nonatomic, strong) UIButton *scanBookButton;
@property (nonatomic, strong) UIButton *scanStreetButton;
@property (nonatomic, strong) UIButton *scanWordButton;

@end

@implementation QRMainViewController


- (UIButton *)createButton {
    UIButton *button = [[UIButton alloc] init];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button addTarget:self action:@selector(scanButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
#pragma mark - Action
- (void)scanButtonClicked:(UIButton *)sender {
    self.scanQRCodeButton.selected = (sender == self.scanQRCodeButton);
    self.scanBookButton.selected = (sender == self.scanBookButton);
    self.scanStreetButton.selected = (sender == self.scanStreetButton);
    self.scanWordButton.selected = (sender == self.scanWordButton);
    
    [self.scanningView transformScanningTypeWithStyle:sender.tag];
}

#pragma mark - Propertys
- (UIView *)preview {
    if (!_preview) {
        _preview = [[UIView alloc] initWithFrame:self.view.bounds];
    }
    return _preview;
}
- (UIView *)buttonContainerView {
    if (!_buttonContainerView) {
        _buttonContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - 64 - 62, CGRectGetWidth(self.view.bounds), 62)];
        _buttonContainerView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
        
        [_buttonContainerView addSubview:self.scanQRCodeButton];
        [_buttonContainerView addSubview:self.scanBookButton];
        [_buttonContainerView addSubview:self.scanStreetButton];
        [_buttonContainerView addSubview:self.scanWordButton];
    }
    return _buttonContainerView;
}
- (UIButton *)scanQRCodeButton {
    
    if (!_scanQRCodeButton) {
        _scanQRCodeButton = [self createButton];
        _scanQRCodeButton.frame = CGRectMake(CGRectGetMidX(self.view.bounds) - kScanningButtonPadding * 1.5 - 35 * 2, 8, 35, CGRectGetHeight(self.buttonContainerView.bounds) - 16);
        _scanQRCodeButton.tag = 0;
        [_scanQRCodeButton setImage:[UIImage imageNamed:@"ScanQRCode"] forState:UIControlStateNormal];
        [_scanQRCodeButton setImage:[UIImage imageNamed:@"ScanQRCode_HL"] forState:UIControlStateSelected];
        _scanQRCodeButton.selected = YES;
        [_scanQRCodeButton setTitle:@"扫码" forState:UIControlStateNormal];
//        [_scanQRCodeButton setTitlePositionWithType:XHButtonTitlePostionTypeBottom];
    }
    return _scanQRCodeButton;
}
- (UIButton *)scanBookButton {
    if (!_scanBookButton) {
        _scanBookButton = [self createButton];
        CGRect scanBookButtonFrame = self.scanQRCodeButton.frame;
        scanBookButtonFrame.origin.x += kScanningButtonPadding + CGRectGetWidth(self.scanQRCodeButton.bounds);
        _scanBookButton.frame = scanBookButtonFrame;
        _scanBookButton.tag = 1;
        [_scanBookButton setImage:[UIImage imageNamed:@"ScanBook"] forState:UIControlStateNormal];
        [_scanBookButton setImage:[UIImage imageNamed:@"ScanBook_HL"] forState:UIControlStateSelected];
        [_scanBookButton setTitle:@"封面" forState:UIControlStateNormal];
//        [_scanBookButton setTitlePositionWithType:XHButtonTitlePostionTypeBottom];
    }
    return _scanBookButton;
}
- (UIButton *)scanStreetButton {
    if (!_scanStreetButton) {
        _scanStreetButton = [self createButton];
        CGRect scanBookButtonFrame = self.scanBookButton.frame;
        scanBookButtonFrame.origin.x += kScanningButtonPadding + CGRectGetWidth(self.scanQRCodeButton.bounds);
        _scanStreetButton.frame = scanBookButtonFrame;
        _scanStreetButton.tag = 2;
        [_scanStreetButton setImage:[UIImage imageNamed:@"ScanStreet"] forState:UIControlStateNormal];
        [_scanStreetButton setImage:[UIImage imageNamed:@"ScanStreet_HL"] forState:UIControlStateSelected];
        [_scanStreetButton setTitle:@"街景" forState:UIControlStateNormal];
//        [_scanStreetButton setTitlePositionWithType:XHButtonTitlePostionTypeBottom];
    }
    return _scanStreetButton;
}
- (UIButton *)scanWordButton {
    if (!_scanWordButton) {
        _scanWordButton = [self createButton];
        CGRect scanBookButtonFrame = self.scanStreetButton.frame;
        scanBookButtonFrame.origin.x += kScanningButtonPadding + CGRectGetWidth(self.scanQRCodeButton.bounds);
        _scanWordButton.frame = scanBookButtonFrame;
        _scanWordButton.tag = 3;
        [_scanWordButton setImage:[UIImage imageNamed:@"ScanWord"] forState:UIControlStateNormal];
        [_scanWordButton setImage:[UIImage imageNamed:@"ScanWord_HL"] forState:UIControlStateSelected];
        [_scanWordButton setTitle:@"翻译" forState:UIControlStateNormal];
//        [_scanWordButton setTitlePositionWithType:XHButtonTitlePostionTypeBottom];
    }
    return _scanWordButton;
}

- (ScanningView *)scanningView {
    if (!_scanningView) {
        _scanningView = [[ScanningView alloc] initWithFrame:self.view.bounds];
    }
    return _scanningView;
}
- (CaptureHelper *)captureHelper {
    if (!_captureHelper) {
        _captureHelper = [[CaptureHelper alloc] init];
        [_captureHelper setDidOutputSampleBufferHandle:^(CMSampleBufferRef sampleBuffer) {
            // 这里可以做子线程的QRCode识别
//            NSLog(@"image : %@", [VideoOutputSampleBufferFactory imageFromSampleBuffer:sampleBuffer]);
        }];
    }
    return _captureHelper;
}


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"扫描二维码";
    
//    [self beginScanning];//开始扫二维码
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"qrItem"] style:UIBarButtonItemStylePlain target:self action:@selector(qrScanAction:)];
    
    [self.view addSubview:self.preview];
    
    [self.view addSubview:self.scanningView];
    [self.view addSubview:self.buttonContainerView];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.captureHelper showCaptureOnView:self.preview];
}


- (void)qrScanAction:(UIBarButtonItem *)sender {
    MyQRViewController *vc = [[MyQRViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}










/*
- (void)setupMaskView {
    //设置统一的视图颜色和视图的透明度
        UIColor *color = [UIColor blackColor];
        float alpha = 0.7;
    
        //设置扫描区域外部上部的视图
        UIView *topView = [[UIView alloc]init];
        topView.frame = CGRectMake(0, 0, SCREENWidth, (SCREENHeight-64-QRCodeWidth)/2.0);
        topView.backgroundColor = color;
        topView.alpha = alpha;
    
        //设置扫描区域外部左边的视图
        UIView *leftView = [[UIView alloc]init];
        leftView.frame = CGRectMake(0, 0+topView.frame.size.height, (SCREENWidth-QRCodeWidth)/2.0,QRCodeWidth);
        leftView.backgroundColor = color;
        leftView.alpha = alpha;
    
        //设置扫描区域外部右边的视图
        UIView *rightView = [[UIView alloc]init];
        rightView.frame = CGRectMake((SCREENWidth-QRCodeWidth)/2.0+QRCodeWidth,64+topView.frame.size.height, (SCREENWidth-QRCodeWidth)/2.0,QRCodeWidth);
        rightView.backgroundColor = color;
        rightView.alpha = alpha;
    
        //设置扫描区域外部底部的视图
        UIView *botView = [[UIView alloc]init];
        botView.frame = CGRectMake(0, 64+QRCodeWidth+topView.frame.size.height,SCREENWidth,SCREENHeight-64-QRCodeWidth-topView.frame.size.height);
        botView.backgroundColor = color;
        botView.alpha = alpha;
    
        //将设置好的扫描二维码区域之外的视图添加到视图图层上
        [self.view addSubview:topView];
        [self.view addSubview:leftView];
        [self.view addSubview:rightView];
        [self.view addSubview:botView];
    
    
    UIView *maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.4;
    [self.view addSubview:maskView];
    
    
    //贝塞尔曲线 画一个带有圆角的矩形
    UIBezierPath *bpath = [UIBezierPath bezierPathWithRect:self.view.bounds];
    
//    [bpath appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake((SCREENWidth-QRCodeWidth)/2.0, 50,QRCodeWidth,QRCodeWidth) cornerRadius:1]];
    
    [bpath appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake((SCREENWidth-QRCodeWidth)/2.0, 50,QRCodeWidth,QRCodeWidth) cornerRadius:1] bezierPathByReversingPath]];
    
    //创建一个CAShapeLayer 图层
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bpath.CGPath;
    
    //添加图层蒙板
    maskView.layer.mask = shapeLayer;
    
}
*/

/**
 
- (void)setupScanWindowView {
    //设置扫描区域的位置(考虑导航栏和电池条的高度为64)
    UIView *scanWindow = [[UIView alloc]initWithFrame:CGRectMake((SCREENWidth-QRCodeWidth)/2.0,50,QRCodeWidth,QRCodeWidth)];
    scanWindow.clipsToBounds = YES;
    [self.view addSubview:scanWindow];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(scanWindow.frame) + 10, kScreenWidth, 20)];
    label.text = @"将二维码放入框内，即可自动扫描";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:scanWindow.bounds];
    imgV.image = [UIImage imageNamed:@"scan_frame.png"];
    [scanWindow addSubview:imgV];
    
    
    //设置扫描区域的动画效果
    CGFloat scanNetImageViewH = 241;
    CGFloat scanNetImageViewW = scanWindow.frame.size.width;
    
    _scanNetImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"scan_net"]];
    _scanNetImageView.frame = CGRectMake(0, -scanNetImageViewH, scanNetImageViewW, scanNetImageViewH);
    CABasicAnimation *scanNetAnimation = [CABasicAnimation animation];
    scanNetAnimation.keyPath =@"transform.translation.y";
    scanNetAnimation.byValue = @(QRCodeWidth+50);
    scanNetAnimation.duration = 1.5;
    scanNetAnimation.repeatCount = MAXFLOAT;
    [_scanNetImageView.layer addAnimation:scanNetAnimation forKey:nil];
    [scanWindow addSubview:_scanNetImageView];
}
- (void)beginScanning {
    
    [MBProgressHUD showLoadToView:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //获取摄像设备
        AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        //创建输入流
        AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        
        if (!input) return;
        //创建输出流
        AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
        
        //特别注意的地方：有效的扫描区域，定位是以设置的右顶点为原点。屏幕宽所在的那条线为y轴，屏幕高所在的线为x轴
        CGFloat x = ((SCREENHeight-QRCodeWidth-64)/2.0)/SCREENHeight;
        CGFloat y = ((SCREENWidth-QRCodeWidth)/2.0)/SCREENWidth;
        CGFloat width = QRCodeWidth/SCREENHeight;
        CGFloat height = QRCodeWidth / SCREENWidth;
        output.rectOfInterest = CGRectMake(x, y, width, height);
        
        //设置代理在主线程里刷新
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        //初始化链接对象
        _session = [[AVCaptureSession alloc]init];
        //高质量采集率
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        
        [_session addInput:input];
        [_session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code];
        
        AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        layer.frame = self.view.layer.bounds;
        [self.view.layer insertSublayer:layer atIndex:0];
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [NSThread sleepForTimeInterval:2];
            //开始捕获
            [_session startRunning];
            [self setupMaskView];//设置扫描区域之外的阴影视图
            
            [self setupScanWindowView];//设置扫描二维码区域的视图
        });
    });
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if (metadataObjects.count>0) {
        
        [_session stopRunning];
        //得到二维码上的所有数据
        AVMetadataMachineReadableCodeObject * metadataObject = metadataObjects.firstObject;
        NSString *str = metadataObject.stringValue;
        NSLog(@"------>>>> %@",str);
        
        [self.scanNetImageView.layer removeAllAnimations];
    }
}
*/

@end
