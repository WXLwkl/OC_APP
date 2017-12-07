//
//  LightSensitiveViewController.m
//  OC_APP
//
//  Created by xingl on 2017/11/23.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "LightSensitiveViewController.h"
#import <ImageIO/ImageIO.h>
#import <AVFoundation/AVFoundation.h>

@interface LightSensitiveViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *session;

@end

@implementation LightSensitiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"光感";
    [self xl_setNavBackItem];
    
    [self lightSensitive];
}

- (void)lightSensitive {
    // 1、获取硬件设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 2、创建输入流
    AVCaptureDeviceInput * input = [[AVCaptureDeviceInput alloc] initWithDevice:device error:nil];
    // 3、创建设备输出流
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [output setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    // AVCaptureSession属性
    self.session = [[AVCaptureSession alloc] init];
    // 设置为高质量采集率
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    // 添加会话输入和输出
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }
    if ([self.session canAddOutput:output]) {
        [self.session addOutput:output];
    }
    // 启动会话
    [self.session startRunning];
}
#pragma mark- AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    
    NSLog(@"%f", brightnessValue); //值越大，光强度效果越明显
    
    // 根据brightnessValue的值来打开和关闭闪光灯
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    BOOL result = [device hasTorch]; //判断设备是否有闪光灯
    if (brightnessValue < 0 && result) { //打开闪光灯
        // 更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOn]; //开
        [device unlockForConfiguration];
    } else if (brightnessValue > 0 && result) { // 关闭闪光灯
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOff]; //关
        [device unlockForConfiguration];
    }
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
