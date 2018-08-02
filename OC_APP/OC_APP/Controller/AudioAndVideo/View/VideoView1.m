//
//  VideoView1.m
//  OC_APP
//
//  Created by xingl on 2018/6/25.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "VideoView1.h"
#import "RecordProgressView.h"
#import "XLCaptureManager1.h"

@interface VideoView1 ()<XLCaptureManager1Delegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIView *timeView;
@property (nonatomic, strong) UILabel *timelabel;
@property (nonatomic, strong) UIButton *turnCamera;
@property (nonatomic, strong) UIButton *flashBtn;
@property (nonatomic, strong) RecordProgressView *progressView;
@property (nonatomic, strong) UIButton *recordBtn;


@property (nonatomic, strong, readwrite) XLCaptureManager1 *manager;
@end

@implementation VideoView1

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        [self configUI];
    }
    return self;
}

- (void)configUI {
    
    self.manager = [[XLCaptureManager1 alloc] initWithSuperView:self];
    self.manager.delegate = self;
    
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor grayColor];
    self.topView.frame = CGRectMake(0, 0, kScreenHeight, 44);
    [self addSubview:self.topView];
    
    self.timeView = [[UIView alloc] init];
    self.timeView.hidden = YES;
    self.timeView.frame = CGRectMake((kScreenWidth - 100)/2, 16, 100, 34);
    self.timeView.backgroundColor = [UIColor xl_colorWithHexNumber:0x242424];
    self.timeView.layer.cornerRadius = 4;
    self.timeView.layer.masksToBounds = YES;
    [self addSubview:self.timeView];
    
    
    UIView *redPoint = [[UIView alloc] init];
    redPoint.frame = CGRectMake(0, 0, 6, 6);
    redPoint.layer.cornerRadius = 3;
    redPoint.layer.masksToBounds = YES;
    redPoint.center = CGPointMake(25, 17);
    redPoint.backgroundColor = [UIColor redColor];
    [self.timeView addSubview:redPoint];
    
    self.timelabel =[[UILabel alloc] init];
    self.timelabel.font = [UIFont systemFontOfSize:13];
    self.timelabel.textColor = [UIColor whiteColor];
    self.timelabel.frame = CGRectMake(40, 8, 40, 28);
    [self.timeView addSubview:self.timelabel];
    
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelBtn.frame = CGRectMake(15, 10, 24, 24);
    [self.cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.cancelBtn];
    
    
    self.turnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    self.turnCamera.frame = CGRectMake(kScreenWidth - 60 - 28, 11, 28, 22);
    [self.turnCamera setImage:[UIImage imageNamed:@"listing_camera_lens"] forState:UIControlStateNormal];
    [self.turnCamera addTarget:self action:@selector(turnCameraAction) forControlEvents:UIControlEventTouchUpInside];
    [self.turnCamera sizeToFit];
    [self.topView addSubview:self.turnCamera];
    
    
    self.flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.flashBtn.frame = CGRectMake(kScreenWidth - 22 - 15, 11, 22, 22);
    [self.flashBtn setImage:[UIImage imageNamed:@"listing_flash_off"] forState:UIControlStateNormal];
    [self.flashBtn addTarget:self action:@selector(flashAction) forControlEvents:UIControlEventTouchUpInside];
    [self.flashBtn sizeToFit];
    [self.topView addSubview:self.flashBtn];
    
    
    self.progressView = [[RecordProgressView alloc] initWithFrame:CGRectMake((kScreenWidth - 62)/2, kScreenHeight - 32 - 62, 62, 62)];
    self.progressView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.progressView];
    self.recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.recordBtn addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchUpInside];
    self.recordBtn.frame = CGRectMake(5, 5, 52, 52);
    self.recordBtn.backgroundColor = [UIColor redColor];
    self.recordBtn.layer.cornerRadius = 26;
    self.recordBtn.layer.masksToBounds = YES;
    [self.progressView addSubview:self.recordBtn];
    [self.progressView resetProgress];
    
}

- (void)dismissVC {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissVC)]) {
        [self.delegate dismissVC];
    }
}

- (void)turnCameraAction {
    [self.manager turnCameraAction];
}

- (void)flashAction {
    [self.manager switchflash];
}

- (void)startRecord {
    
    if (self.manager.recordState == LLRecordStateInit) {
        [self.manager startRecord];
    } else if (self.manager.recordState == LLRecordStateRecording) {
        [self.manager stopRecord];
    } else {
        [self.manager reset];
    }
}
- (void)stopRecord {
    [self.manager stopRecord];
}
- (void)reset {
    [self.manager reset];
}


- (void)updateViewWithRecording {
    self.timeView.hidden = NO;
    self.topView.hidden = YES;
    [self changeToRecordStyle];
}

- (void)updateViewWithStop {
    self.timeView.hidden = YES;
    self.topView.hidden = NO;
    [self changeToStopStyle];
}

- (void)changeToRecordStyle {
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint center = self.recordBtn.center;
        CGRect rect = self.recordBtn.frame;
        rect.size = CGSizeMake(28, 28);
        self.recordBtn.frame = rect;
        self.recordBtn.layer.cornerRadius = 4;
        self.recordBtn.center = center;
    }];
}

- (void)changeToStopStyle {
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint center = self.recordBtn.center;
        CGRect rect = self.recordBtn.frame;
        rect.size = CGSizeMake(52, 52);
        self.recordBtn.frame = rect;
        self.recordBtn.layer.cornerRadius = 26;
        self.recordBtn.center = center;
    }];
}


#pragma mark - XLCaptureManager1Delegate
- (void)updateFlashState:(LLFlashState)state {
    
    if (state == XLFlashOpen) {
        [self.flashBtn setImage:[UIImage imageNamed:@"listing_flash_on"] forState:UIControlStateNormal];
    }
    if (state == XLFlashClose) {
        [self.flashBtn setImage:[UIImage imageNamed:@"listing_flash_off"] forState:UIControlStateNormal];
    }
    if (state == XLFlashAuto) {
        [self.flashBtn setImage:[UIImage imageNamed:@"listing_flash_auto"] forState:UIControlStateNormal];
    }
}
- (void)updateRecordingProgress:(CGFloat)progress {
    
    [self.progressView updateProgressWithValue:progress];
    self.timelabel.text = [self changeToVideotime:progress * RECORD_MAX_TIME];
    [self.timelabel sizeToFit];
}
- (NSString *)changeToVideotime:(CGFloat)videocurrent {
    
    return [NSString stringWithFormat:@"%02li:%02li",lround(floor(videocurrent/60.f)),lround(floor(videocurrent/1.f))%60];
    
}
- (void)updateRecordState:(LLRecordState)recordState {
    if (recordState == LLRecordStateInit) {
        [self updateViewWithStop];
        [self.progressView resetProgress];
    } else if (recordState == LLRecordStateRecording) {
        [self updateViewWithRecording];
    } else  if (recordState == LLRecordStateFinish) {
        [self updateViewWithStop];
        if (self.delegate && [self.delegate respondsToSelector:@selector(recordFinishWithvideoUrl:)]) {
            [self.delegate recordFinishWithvideoUrl:self.manager.videoUrl];
        }
    }
}

@end