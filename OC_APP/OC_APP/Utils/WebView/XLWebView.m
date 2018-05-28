//
//  XLWebView.m
//  OC_APP
//
//  Created by xingl on 2018/3/2.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "XLWebView.h"

@interface XLWebView ()

@property (nonatomic, strong) NSURL *baseUrl;
@end

@implementation XLWebView

- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration {
    self = [super initWithFrame:frame configuration:configuration];
    if (self) {
        
        if (configuration) {
            
            [configuration.userContentController addScriptMessageHandler:self name:@"webViewApp"];
        }
        
        //这句是关闭系统自带的侧滑后退（历史浏览记录）
        //        self.allowsBackForwardNavigationGestures = YES;
    }
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    if (newSuperview) return;
    
    [self.configuration.userContentController removeScriptMessageHandlerForName:@"webViewApp"];
    
}


#pragma mark - Load Url
- (void)loadRequestWithUrl:(NSString *)urlString; {
    
    [self loadRequestWithUrl:urlString params:nil];
}

- (void)loadRequestWithUrl:(NSString *)urlString params:(NSDictionary *)params {
    
    NSURL *url = [self generateURL:urlString params:params];
    
    [self loadRequest:[NSURLRequest requestWithURL:url]];
}
/**
 *  加载本地HTML页面
 *
 *  @param htmlName html页面文件名称
 */
- (void)loadLocalHTMLWithFileName:(nonnull NSString *)htmlName {
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:htmlName
                                                          ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    
    [self loadHTMLString:htmlCont baseURL:baseURL];
}

- (NSURL *)generateURL:(NSString*)baseURL params:(NSDictionary*)params {
    self.urlString = baseURL;
    self.params = params;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:params];
    NSMutableArray *pairs = [NSMutableArray array];
    for (NSString *key in param.keyEnumerator) {
        NSString *value = [NSString stringWithFormat:@"%@", [param objectForKey:key]];
        NSString *escaped_value = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)value, NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", kCFStringEncodingUTF8);
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
        
    }
    NSString *query = [pairs componentsJoinedByString:@"&"];
    baseURL = [baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = @"";
    if ([baseURL containsString:@"?"]) {
        url = [NSString stringWithFormat:@"%@&%@", baseURL, query];
    } else {
        url = [NSString stringWithFormat:@"%@?%@", baseURL, query];
    }
    //绝对地址
    if ([url.lowercaseString hasPrefix:@"http"]) {
        return [NSURL URLWithString:url];
    } else {
        return [NSURL URLWithString:url relativeToURL:self.baseUrl];
    }
}
/**
 *  重新加载webview
 */
- (void)reloadWebView {
    [self loadRequestWithUrl:self.urlString params:self.params];
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSLog(@"message:%@",message.body);
    if ([message.body isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *body = (NSDictionary *)message.body;
        
        ScriptMessage *msg = [ScriptMessage new];
        [msg setValuesForKeysWithDictionary:body];
        
        if (self.messageHandlerDelegate && [self.messageHandlerDelegate respondsToSelector:@selector(webView:didReceiveScriptMessage:)]) {
            [self.messageHandlerDelegate webView:self didReceiveScriptMessage:msg];
        }
    }
    
}

#pragma mark - JS

- (void)callJS:(NSString *)jsMethod {
    [self callJS:jsMethod handler:nil];
}

- (void)callJS:(NSString *)jsMethod handler:(void (^)(id _Nullable))handler {
    
    NSLog(@"call js:%@",jsMethod);
    [self evaluateJavaScript:jsMethod completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        if (handler) {
            handler(response);
        }
    }];
}

@end
