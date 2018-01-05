//
//  RootWebViewController.h
//  OC_APP
//
//  Created by xingl on 2017/12/15.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "RootViewController.h"
#import <WebKit/WebKit.h>
@interface RootWebViewController : RootViewController


///// Time out internal.
//@property(assign, nonatomic) NSTimeInterval timeoutInternal;
///// Cache policy.
//@property(assign, nonatomic) NSURLRequestCachePolicy cachePolicy;

/// Shows background description label. Default is YES.
@property (assign, nonatomic) BOOL showsBackgroundLabel;
/// Max length of title string content. Default is 10.
@property (assign, nonatomic) NSUInteger maxAllowedTitleLength;

@property (nonatomic, strong) NSString *rootUrlStrig;
@property (nonatomic, strong) UIColor *progressTintColor;


@property (nonatomic, strong) WKWebView *webView;

/**
 *  根据远端URL地址加载
 */
- (instancetype)initWithURL:(NSString *)url;

/**
 *  根据本地文件路径加载
 *  eg:[NSBundle.mainBundle pathForResource:@"Swift" ofType:@"pdf"]
 */
- (instancetype)initWithFile:(NSString *)url;

- (void)reload;
- (void)reloadRootURL;

- (void)loadURL:(NSURL *)url;
- (void)loadUrlString:(NSString *)urlString;
- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;


@end
