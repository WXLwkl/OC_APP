//
//  WechatVideoViewController.m
//  OC_APP
//
//  Created by xingl on 2018/6/21.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "WeChatVideoViewController.h"
#import "WeChatVideoView.h"
#import "VideoPlayController.h"

@interface WeChatVideoViewController ()<WeChatVideoViewDelegate>

@property (nonatomic, strong) WeChatVideoView *videoView;

@end

@implementation WeChatVideoViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.videoView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.videoView.captureManager.recordState == WeChatRecordStateFinish) {
        [self.videoView reset];
    }
}
#pragma mark - WeChatVideoViewDelegate
- (void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)recordFinishWithvideoUrl:(NSURL *)videoUrl {
    
    NSLog(@"得到视频url：%@", videoUrl);
    
}

- (void)takePhotoWithImage:(UIImage *)finalImage {
    NSLog(@"获得image，做后续的操作");
}

#pragma mark - lazy
- (WeChatVideoView *)videoView {
    if (!_videoView) {
        _videoView = [[WeChatVideoView alloc] initWithFrame:self.view.bounds];
        _videoView.delegate = self;
    }
    return _videoView;
}

@end
