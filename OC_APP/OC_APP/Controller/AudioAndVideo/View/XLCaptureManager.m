//
//  AVCaptureManager.m
//  OC_APP
//
//  Created by xingl on 2018/6/22.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "XLCaptureManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface XLCaptureManager ()

@property (nonatomic, weak) UIView *superView;

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong) AVCaptureDeviceInput *audioInput;
@property (nonatomic, strong) AVCaptureMovieFileOutput *fileOutput;

@property (nonatomic, strong) UIImageView *focusCursor; //聚焦光标

@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat recordTime;

@end

@implementation XLCaptureManager

@end
