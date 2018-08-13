//
//  XLVideoDownload.h
//  OC_APP
//
//  Created by xingl on 2018/8/6.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XLVideoDownload;

@protocol XLVideoDownloadDelegate <NSObject>

// 没有完整的缓存文件，告诉播放器自己去用网络地址进行播放
- (void)didNoCacheFileWithManager:(XLVideoDownload *)manager;
// 已经存在下载好的这个文件，告诉播放器可以直接利用filePath播放
- (void)didFileExistedWithManager:(XLVideoDownload *)manager path:(NSString *)filePath;

// 开始下载数据（包括长度和类型）
- (void)didStartReceiveManager:(XLVideoDownload *)manager videoLength:(NSUInteger)videoLength;
// 正在下载
- (void)didReceiveManager:(XLVideoDownload *)manager progress:(CGFloat)progress;

//完成下载
- (void)didFinishLoadingWithManager:(XLVideoDownload *)manager fileSavePath:(NSString *)filePath;

//下载失败(错误码)
- (void)didFailLoadingWithManager:(XLVideoDownload *)manager error:(NSError *)errorCode;


@end

@interface XLVideoDownload : NSObject

@property (nonatomic, weak) id<XLVideoDownloadDelegate> delegate;

- (instancetype)initWithURL:(NSString *)videoUrl withDelegate:(id)delegate;

- (void)start;
- (void)suspend;
- (void)cancel;

@end
