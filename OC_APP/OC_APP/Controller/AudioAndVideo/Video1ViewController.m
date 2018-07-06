//
//  Video1ViewController.m
//  OC_APP
//
//  Created by xingl on 2018/6/21.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "Video1ViewController.h"
#import "View/VideoView.h"
#import "VideoPlayController.h"

@interface Video1ViewController ()<VideoViewDelegate>

@property (nonatomic, strong) VideoView *videoView;

@end

@implementation Video1ViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.videoView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.videoView.captureManager.recordState == XLRecordStateFinish) {
        [self.videoView reset];
    }
}

- (void)dismissVC {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)recordFinishWithvideoUrl:(NSURL *)videoUrl {
    
    VideoPlayController *vc = [[VideoPlayController alloc] init];
    vc.videoUrl = videoUrl;
    [self.navigationController pushViewController:vc animated:YES];
}

- (VideoView *)videoView {
    if (!_videoView) {
        _videoView = [[VideoView alloc] initWithFrame:self.view.bounds];
        _videoView.delegate = self;
    }
    return _videoView;
}

@end
