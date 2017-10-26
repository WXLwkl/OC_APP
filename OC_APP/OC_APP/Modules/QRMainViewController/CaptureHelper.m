//
//  CaptureHelper.m
//  OC_APP
//
//  Created by xingl on 2017/10/19.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "CaptureHelper.h"

@interface CaptureHelper ()

@property (nonatomic, copy) DidOutputSampleBufferBlock didOutputSampleBuffer;

@property (nonatomic, strong) dispatch_queue_t captureSessionQueue;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureDeviceInput *captureInput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *captureOutput;


@end

@implementation CaptureHelper

#pragma mark - 对外接口
- (void)setDidOutputSampleBufferHandle:(DidOutputSampleBufferBlock)didOutputSampleBuffer {
    self.didOutputSampleBuffer = didOutputSampleBuffer;
}

- (void)showCaptureOnView:(UIView *)preview {
    dispatch_async(self.captureSessionQueue, ^{
        [self.captureSession startRunning];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.captureVideoPreviewLayer.frame = preview.bounds;
            [preview.layer addSublayer:self.captureVideoPreviewLayer];
        });
    });
}

#pragma mark - Propertys

- (AVCaptureSession *)captureSession {
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
        AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error;
        _captureInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
        if (error) {
            NSLog(@"%@",error.localizedDescription);
        }
        if ([_captureSession canAddInput:_captureInput]) {
            [_captureSession addInput:_captureInput];
        }
        _captureOutput = [[AVCaptureVideoDataOutput alloc] init];
        _captureOutput.alwaysDiscardsLateVideoFrames = YES;
        [_captureOutput setSampleBufferDelegate:self queue:self.captureSessionQueue];
        NSString *key = (NSString *)kCVPixelBufferPixelFormatTypeKey;
        NSNumber *value = [NSNumber numberWithUnsignedInteger:kCVPixelFormatType_32BGRA];
        NSDictionary *videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
        [_captureOutput setVideoSettings:videoSettings];
        [self.captureSession addOutput:self.captureOutput];
        
        NSString *preset = 0;
        if (NSClassFromString(@"NSOrderedSet") && [UIScreen mainScreen].scale > 1 && [inputDevice supportsAVCaptureSessionPreset:AVCaptureSessionPresetiFrame960x540]) {
            preset = AVCaptureSessionPresetiFrame960x540;
        }
        if (!preset) {
            preset = AVCaptureSessionPresetMedium;
        }
        self.captureSession.sessionPreset = preset;
    }
    return _captureSession;
}
- (AVCaptureVideoPreviewLayer *)captureVideoPreviewLayer {
    if (!_captureVideoPreviewLayer) {
        _captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _captureVideoPreviewLayer;
}




#pragma mark - Life Cycle

- (id)init {
    self = [super init];
    if (self) {
        _captureSessionQueue = dispatch_queue_create("com.HUAJIE.captureSessionQueue", 0);
    }
    return self;
}

- (void)dealloc {
    _captureSessionQueue = nil;
    _captureVideoPreviewLayer = nil;
    
    if (![_captureSession canAddOutput:self.captureOutput])
        [_captureSession removeOutput:self.captureOutput];
    self.captureOutput = nil;
    
    [_captureSession stopRunning];
    _captureSession = nil;
}


#pragma mark - AVCaptureVideoDataOutputSampleBuffer Delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    if (self.didOutputSampleBuffer) {
        self.didOutputSampleBuffer(sampleBuffer);
    }
}



@end
