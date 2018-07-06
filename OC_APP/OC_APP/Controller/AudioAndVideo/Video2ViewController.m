//
//  Video2ViewController.m
//  OC_APP
//
//  Created by xingl on 2018/6/25.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "Video2ViewController.h"
#import "VideoPlayController.h"
#import "VideoView1.h"

@interface Video2ViewController ()<VideoView1Delegate>

@property (nonatomic, strong) VideoView1 *videoView;

@end

@implementation Video2ViewController

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
    if (self.videoView.manager.recordState == LLRecordStateFinish) {
        [self.videoView reset];
    }
}

#pragma mark - delegate
- (void)dismissVC {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)recordFinishWithvideoUrl:(NSURL *)videoUrl {
    
    VideoPlayController *vc = [[VideoPlayController alloc] init];
    vc.videoUrl = videoUrl;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - lazy
- (VideoView1 *)videoView {
    if (!_videoView) {
        _videoView = [[VideoView1 alloc] initWithFrame:self.view.bounds];
        _videoView.delegate = self;
    }
    return _videoView;
}

@end
