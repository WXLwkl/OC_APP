//
//  XLVideoPlayer.m
//  OC_APP
//
//  Created by xingl on 2018/8/6.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "XLVideoPlayer.h"
#import "XLVideoDownload.h"

@interface XLVideoPlayer ()

@property(nonatomic, strong)  XLVideoDownload *manager;       //数据下载器

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *videoShowView;            //用于视频显示的View

@property (nonatomic, copy) NSString *videoUrl;               //视频地址



@end

@implementation XLVideoPlayer

- (void)playWithUrl:(NSString *)videoUrl showView:(UIView *)showView {
    self.videoUrl = videoUrl;
    self.backgroundView = showView;
    self.videoShowView.frame = self.backgroundView.bounds;
    
    //实例化下载器，会根据URL查找当前本地有无缓存，处理结果在代理<LYDownloadManagerDelegate>方法内
    self.manager = [[XLVideoDownload alloc] initWithURL:videoUrl withDelegate:self];
}

@end
