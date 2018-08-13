//
//  XLVideoPlayer.h
//  OC_APP
//
//  Created by xingl on 2018/8/6.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XLVideoPlayer;

@protocol XLVideoPlayerDelegate <NSObject>

@optional
- (void)videoPlayerDidBackButtonClick;
- (void)videoPlayerDidFullScreenButtonClick;

@end

@interface XLVideoPlayer : NSObject

@property (nonatomic, weak) id<XLVideoPlayerDelegate> delegate;





- (void)playWithUrl:(NSString *)videoUrl showView:(UIView *)showView;
// 播放
- (void)playVideo;
// 暂停
- (void)pauseVideo;
// 停止播放
- (void)stopVideo;

//屏幕转换
- (void)fullScreenChanged:(BOOL)isFullScreen;

@end
