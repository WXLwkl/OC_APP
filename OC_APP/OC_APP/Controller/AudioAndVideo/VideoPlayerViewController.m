//
//  VideoPlayerViewController.m
//  OC_APP
//
//  Created by xingl on 2018/8/7.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "XLVideoPlayerView.h"

@interface VideoPlayerViewController ()

@property (nonatomic, strong) XLVideoPlayerView *player;

@end

@implementation VideoPlayerViewController

#pragma mark - Autorotate
- (BOOL)shouldAutorotate {
    return YES;
}
/** 支持哪些屏幕方向 */
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}
/** 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法） */
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"视频播放器";
    
    _player = [[XLVideoPlayerView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 300)];
    
    [self.view addSubview:_player];
    // 本地视频播放.
    NSString *locVideoPath = [[NSBundle mainBundle]pathForResource:@"videoplayerdata" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:locVideoPath];
    
    _player.isLandscape = YES;
    _player.videoUrl = url;
    
//    [_player playVideo];
    
    
    [_player backButton:^(UIButton *button) {
        NSLog(@"返回按钮被点击");
    }];
    //播放完成回调
    [_player endPlay:^{
    
        NSLog(@"播放完成");
    }];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 400, 100, 50);
    btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}

- (void)buttonClick:(UIButton *)sender {

    NSURL *url = [NSURL URLWithString:@"https://vd3.bdstatic.com//mda-ihcef2f8byau8kbj//mda-ihcef2f8byau8kbj.mp4"];
    
    [self.player setVideoUrl:url];
    [self.player playVideo];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self.player destroyPlayer];
}

@end
