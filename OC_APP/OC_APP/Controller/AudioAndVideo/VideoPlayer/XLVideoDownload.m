//
//  XLVideoDownload.m
//  OC_APP
//
//  Created by xingl on 2018/8/6.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "XLVideoDownload.h"

@interface XLVideoDownload ()<NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, strong) NSFileHandle *fileHandle;

@property (nonatomic, assign) NSInteger currentLength;
@property (nonatomic, assign) NSInteger totalLength;

@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, copy) NSString *videoTempPath;
@property (nonatomic, copy) NSString *videoCachePath;

@end

@implementation XLVideoDownload

- (instancetype)initWithURL:(NSString *)videoUrl withDelegate:(id)delegate {
    self = [super init];
    
    if (self) {
        self.videoUrl = videoUrl;
        self.delegate = delegate;
     
        [self fileJudge];
    }
    return self;
}
//开始/继续
- (void)start {
    if (self.dataTask == nil) {
        [self sendHttpRequst];
    } else {
        [self.dataTask resume];
    }
}
- (void)suspend {
    [self.dataTask suspend];
}
- (void)cancel {
    [self.dataTask cancel];
    self.dataTask = nil;
}


- (void)fileJudge {
    
    _fileManager = [NSFileManager defaultManager];
    NSString *videoName = [[self.videoUrl componentsSeparatedByString:@"/"] lastObject];
    // 临时下载路径
    self.videoTempPath = [self tempFilePathWithFileName:videoName];
    // 缓存路径
    self.videoCachePath = [self cacheFilePathWithName:videoName];
    
    if ([_fileManager fileExistsAtPath:self.videoCachePath]) { // 缓存目录下已存在下载完的文件
        if (self.delegate && [self.delegate respondsToSelector:@selector(didFileExistedWithManager:path:)]) {
            [self.delegate didFileExistedWithManager:self path:self.videoCachePath];
        }
    } else { // 判断当前目录下有无已下载的临时文件
        if ([_fileManager fileExistsAtPath:self.videoTempPath]) {
            // 可以读到
            _fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:self.videoTempPath];
            // 存在已下载数据的文件
            _currentLength = [_fileHandle seekToEndOfFile];
        } else {
            // 不存在文件
            _currentLength = 0;
            // 创建文件
            [_fileManager createFileAtPath:self.videoTempPath contents:nil attributes:nil];
            // 创建后再读
            _fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:self.videoTempPath];
        }
        [self sendHttpRequst];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didNoCacheFileWithManager:)]) {
            [self.delegate didNoCacheFileWithManager:self];
        }
    }
    
}

- (NSURLSession *)session{
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}
- (void)sendHttpRequst {
    [_fileHandle seekToEndOfFile];
    NSURL *url = [NSURL URLWithString:_videoUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setValue:[NSString stringWithFormat:@"bytes=%ld-", _currentLength] forHTTPHeaderField:@"Range"];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request];
    self.dataTask = dataTask;
    
    [self.dataTask resume];
    
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(nonnull NSURLSessionDataTask *)dataTask didReceiveResponse:(nonnull NSURLResponse *)response completionHandler:(nonnull void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSDictionary *dic = [httpResponse allHeaderFields];
    NSString *content = dic[@"Content-Range"];
    NSArray *array = [content componentsSeparatedByString:@"/"];
    NSString *length = array.lastObject;
    
    NSUInteger videoLength;
    if ([length integerValue] == 0) {
        videoLength = (NSUInteger)httpResponse.expectedContentLength;
    } else {
        videoLength = [length integerValue];
    }
    // 接受到响应的时候 告诉系统如何处理服务器返回的数据
    completionHandler(NSURLSessionResponseAllow);
    //得到请求文件的数据大小
    _totalLength = response.expectedContentLength + _currentLength;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didStartReceiveManager:videoLength:)]) {
        [self.delegate didStartReceiveManager:self videoLength:videoLength];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    //使用文件句柄指针来写数据（边写边移动）
    [_fileHandle writeData:data];
    
    //累加已经下载的文件数据大小
    _currentLength += data.length;
    
    //计算文件的下载进度 = 已经下载的 / 文件的总大小
    CGFloat progress = 1.0 * _currentLength / _totalLength;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveManager:progress:)]) {
        [self.delegate didReceiveManager:self progress:progress];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error == nil) { // 下载成功
        // 当前下载的文件路径
        NSURL *TempPathUrl = [NSURL fileURLWithPath:self.videoTempPath];
        NSURL *cacheFileUrl = [NSURL fileURLWithPath:self.videoCachePath];
        
        if (![self.fileManager fileExistsAtPath:self.videoCachePath]) {
            [self.fileManager createDirectoryAtPath:self.videoCachePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        // 如果该路径下文件已经存在，就要先将其移除，在移动文件
        if ([self.fileManager fileExistsAtPath:[cacheFileUrl path] isDirectory:NULL]) {
            [self.fileManager removeItemAtURL:cacheFileUrl error:NULL];
        }
        //移动文件至缓存目录
        [self.fileManager moveItemAtURL:TempPathUrl toURL:cacheFileUrl error:NULL];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishLoadingWithManager:fileSavePath:)]) {
            [self.delegate didFinishLoadingWithManager:self fileSavePath:self.videoCachePath];
        }
    } else { // 下载失败
        if (self.delegate && [self.delegate respondsToSelector:@selector(didFailLoadingWithManager:error:)]) {
            [self.delegate didFailLoadingWithManager:self error:error];
        }
    }
}

#pragma mark - path
- (NSString *)tempFilePathWithFileName:(NSString *)name {
    return [[NSHomeDirectory( ) stringByAppendingPathComponent:@"tmp"] stringByAppendingPathComponent:name];
}
- (NSString *)cacheFilePathWithName:(NSString *)name{
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *cacheFolderPath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/Moment_Videos/%@",name]];
    return cacheFolderPath;
}
@end
