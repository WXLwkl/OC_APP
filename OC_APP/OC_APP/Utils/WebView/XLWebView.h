//
//  XLWebView.h
//  OC_APP
//
//  Created by xingl on 2018/3/2.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "ScriptMessage.h"
@class XLWebView;

@protocol XLWebViewMessageHandleDelegate <NSObject>

@optional
- (void)webView:(nonnull XLWebView *)webView didReceiveScriptMessage:(nonnull ScriptMessage *)message;

@end


@interface XLWebView : WKWebView <WKScriptMessageHandler,XLWebViewMessageHandleDelegate>

//webview加载的url地址
@property (nullable, nonatomic, copy) NSString *urlString;
//webview加载的参数
@property (nullable, nonatomic, copy) NSDictionary *params;

@property (nullable, nonatomic, weak) id<XLWebViewMessageHandleDelegate> messageHandlerDelegate;

#pragma mark - Load Url
- (void)loadRequestWithUrl:(nonnull NSString *)urlString;

- (void)loadRequestWithUrl:(nonnull NSString *)urlString params:(nullable NSDictionary *)params;
/**
 *  加载本地HTML页面
 *
 *  @param htmlName html页面文件名称
 */
- (void)loadLocalHTMLWithFileName:(nonnull NSString *)htmlName;


- (void)reloadWebView;

#pragma mark - JS Method Invoke

/**
 *  调用JS方法（无返回值）
 *
 *  @param jsMethod JS方法名称
 */
- (void)callJS:(nonnull NSString *)jsMethod;

/**
 *  调用JS方法（可处理返回值）
 *
 *  @param jsMethod JS方法名称
 *  @param handler  回调block
 */
- (void)callJS:(nonnull NSString *)jsMethod handler:(nullable void(^)(__nullable id response))handler;

@end
