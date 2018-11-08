//
//  RequestManager.h
//  OC_APP
//
//  Created by xingl on 2017/8/16.
//  Copyright © 2017年 兴林. All rights reserved.
//

static NSString * const url1 = @"http://c.m.163.com/nc/video/home/1-10.html";
static NSString * const url2 = @"http://apis.baidu.com/apistore/";
static NSString * const url3 = @"http://yycloudvod1932283664.bs2dl.yy.com/djMxYTkzNjQzNzNkNmU4ODc1NzY1ODQ3ZmU5ZDJlODkxMTIwMjM2NTE5Nw";
static NSString * const url4 = @"http://www.aomy.com/attach/2012-09/1347583576vgC6.jpg";
static NSString * const url5 = @"http://chanyouji.com/api/users/likes/268717.json";


#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef NS_ENUM(NSUInteger, HttpRequestSerializer) {
    /** 设置请求数据为JSON格式*/
    HttpRequestSerializerJSON,
    /** 设置请求数据为HTTP格式*/
    HttpRequestSerializerHTTP,
};

typedef NS_ENUM(NSUInteger, HttpResponseSerializer) {
    /** 设置响应数据为JSON格式*/
    HttpResponseSerializerJSON,
    /** 设置响应数据为HTTP格式*/
    HttpResponseSerializerHTTP,
};
/*! 实时监测网络状态的 block */
typedef void(^NetworkStatusBlock)(AFNetworkReachabilityStatus status);

/*! 定义请求成功的 block */
typedef void( ^ResponseSuccess)(id response);
/*! 定义请求失败的 block */
typedef void( ^ResponseFail)(NSError *error);

/*! 定义上传进度 block */
typedef void( ^UploadProgress)(int64_t bytesProgress,
                               int64_t totalBytesProgress);
/*! 定义下载进度 block */
typedef void( ^DownloadProgress)(int64_t bytesProgress, int64_t totalBytesProgress);


@interface RequestManager : NSObject

/**
 监听网络状态
 */
@property (nonatomic, assign) AFNetworkReachabilityStatus networkStatus;

/**
 创建的请求的超时间隔（以秒为单位），此设置为全局统一设置一次即可，默认超时时间间隔为30秒。
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/**
 设置网络请求参数的格式，此设置为全局统一设置一次即可，默认：HttpRequestSerializerJSON
 */
@property (nonatomic, assign) HttpRequestSerializer requestSerializer;

/**
 设置服务器响应数据格式，此设置为全局统一设置一次即可，默认：HttpResponseSerializerJSON
 */
@property (nonatomic, assign) HttpResponseSerializer responseSerializer;


/**
 自定义请求头：httpHeaderField
 */
@property(nonatomic, strong) NSDictionary *httpHeaderFieldDictionary;

/*!
 *  获得全局唯一的网络请求实例单例方法
 *
 *  @return 网络请求类NetManager单例
 */
+ (instancetype)sharedRequestManager;

#pragma mark - 网络请求的类方法 --- get / post / put / delete
/**
 网络请求的实例方法 get
 
 @param urlString 请求的地址
 @param isNeedCache 是否需要缓存，只有 get / post 请求有缓存配置
 @param parameters 请求的参数
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @return NSURLSessionTask
 */
+ (NSURLSessionTask *)GET:(NSString *)urlString
              isNeedCache:(BOOL)isNeedCache
               parameters:(NSDictionary *)parameters
             successBlock:(ResponseSuccess)successBlock
             failureBlock:(ResponseFail)failureBlock;

/**
 网络请求的实例方法 post
 
 @param urlString 请求的地址
 @param isNeedCache 是否需要缓存，只有 get / post 请求有缓存配置
 @param parameters 请求的参数
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @return NSURLSessionTask
 */
+ (NSURLSessionTask *)POST:(NSString *)urlString
               isNeedCache:(BOOL)isNeedCache
                parameters:(NSDictionary *)parameters
              successBlock:(ResponseSuccess)successBlock
              failureBlock:(ResponseFail)failureBlock;

/**
 网络请求的实例方法 put
 
 @param urlString 请求的地址
 @param parameters 请求的参数
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @return NSURLSessionTask
 */
+ (NSURLSessionTask *)PUT:(NSString *)urlString
               parameters:(NSDictionary *)parameters
             successBlock:(ResponseSuccess)successBlock
             failureBlock:(ResponseFail)failureBlock;


/**
 网络请求的实例方法 delete
 
 @param urlString 请求的地址
 @param parameters 请求的参数
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @param progress 进度
 @return NSURLSessionTask
 */
+ (NSURLSessionTask *)DELETE:(NSString *)urlString
                  parameters:(NSDictionary *)parameters
                successBlock:(ResponseSuccess)successBlock
                failureBlock:(ResponseFail)failureBlock
                    progress:(DownloadProgress)progress;



/**
 上传图片(多图)
 
 @param urlString urlString description
 @param parameters 上传图片预留参数---视具体情况而定 可为空
 @param imageArray 上传的图片数组
 @param fileNames 上传的图片数组 fileName
 @param imageType 图片类型，如：png、jpg、gif
 @param imageScale 图片压缩比率（0~1.0）
 @param successBlock 上传成功的回调
 @param failureBlock 上传失败的回调
 @param progress 上传进度
 @return NSURLSessionTask
 */
+ (NSURLSessionTask *)uploadImage:(NSString *)urlString
                       parameters:(NSDictionary *)parameters
                       imageArray:(NSArray *)imageArray
                        fileNames:(NSArray <NSString *>*)fileNames
                        imageType:(NSString *)imageType
                       imageScale:(CGFloat)imageScale
                     successBlock:(ResponseSuccess)successBlock
                      failurBlock:(ResponseFail)failureBlock
                   uploadProgress:(UploadProgress)progress;


/**
 视频上传
 
 @param urlString 上传的url
 @param parameters 上传视频预留参数---视具体情况而定 可移除
 @param videoPath 上传视频的本地沙河路径
 @param successBlock 成功的回调
 @param failureBlock 失败的回调
 @param progress 上传的进度
 */
+ (void)uploadVideo:(NSString *)urlString
         parameters:(NSDictionary *)parameters
          videoPath:(NSString *)videoPath
       successBlock:(ResponseSuccess)successBlock
       failureBlock:(ResponseFail)failureBlock
     uploadProgress:(UploadProgress)progress;


/**
 文件上传
 
 @param urlString urlString description
 @param parameters parameters description
 @param fileName fileName description
 @param filePath filePath description
 @param successBlock successBlock description
 @param failureBlock failureBlock description
 @param UploadProgressBlock UploadProgressBlock description
 @return NSURLSessionTask
 */
+ (NSURLSessionTask *)uploadFile:(NSString *)urlString
                      parameters:(NSDictionary *)parameters
                        fileName:(NSString *)fileName
                        filePath:(NSString *)filePath
                    successBlock:(ResponseSuccess)successBlock
                    failureBlock:(ResponseFail)failureBlock
             UploadProgressBlock:(UploadProgress)UploadProgressBlock;


/**
 文件下载
 
 @param urlString 请求的url
 @param parameters 文件下载预留参数---视具体情况而定 可移除
 @param savePath 下载文件保存路径
 @param successBlock 下载文件成功的回调
 @param failureBlock 下载文件失败的回调
 @param progress 下载文件的进度显示
 @return NSURLSessionTask
 */
+ (NSURLSessionTask *)downLoadFile:(NSString *)urlString
                        parameters:(NSDictionary *)parameters
                          savaPath:(NSString *)savePath
                      successBlock:(ResponseSuccess)successBlock
                      failureBlock:(ResponseFail)failureBlock
                  downLoadProgress:(DownloadProgress)progress;


#pragma mark - 网络状态监测
/*!
 *  获取网络状态
 */
+ (void)startNetWorkMonitoringWithBlock:(NetworkStatusBlock)networkStatus;

#pragma mark - 自定义请求头
/**
 *  自定义请求头
 */
+ (void)setValue:(NSString *)value forHTTPHeaderKey:(NSString *)HTTPHeaderKey;

/**
 删除所有请求头
 */
+ (void)clearAuthorizationHeader;

#pragma mark - 取消 Http 请求
/*!
 *  取消所有 Http 请求
 */
+ (void)cancelAllRequest;

/*!
 *  取消指定 URL 的 Http 请求
 */
+ (void)cancelRequestWithURL:(NSString *)URL;

@end
