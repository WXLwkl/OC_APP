//
//  XLWebViewController.m
//  OC_APP
//
//  Created by xingl on 2018/3/2.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "XLWebViewController.h"
#import "UINavigationController+SGProgress.h"

@interface XLWebViewController ()

@end

@implementation XLWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"加载中...";
    [self setupWebView];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    if (self.url.length) {
        [self.webView loadRequestWithUrl:self.url];
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.webView.frame = self.view.bounds;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController hiddenSGProgress];
}

- (void)setupWebView {
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    _webView = [[XLWebView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) configuration:config];
    _webView.scrollView.scrollEnabled = YES;
    _webView.messageHandlerDelegate = self;
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    
    [self.view addSubview:_webView];
}

- (void)dealloc {
    NSLog(@"dealloc --- %@",NSStringFromClass([self class]));
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        if (object == self.webView) {
            [self.navigationController setSGProgressPercentage:self.webView.estimatedProgress*100 andTintColor:[UIColor colorWithRed:24/255.0 green:124/255.0 blue:244/255.0f alpha:1.0]];
        }
        else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else if ([keyPath isEqualToString:@"title"]){
        if (object == self.webView) {
            self.navigationItem.title = self.webView.title;
        }
        else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - SHWKWebViewMessageHandleDelegate

/**
 *  JS调用原生方法处理
 */
- (void)webView:(XLWebView *)webView didReceiveScriptMessage:(ScriptMessage *)message {
    
    NSLog(@"webView method:%@",message.method);
    
    //返回上一页
    if ([message.method isEqualToString:@"tobackpage"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    //打开新页面
    else if ([message.method isEqualToString:@"openappurl"]) {
        
        NSString *url = [message.params objectForKey:@"url"];
        if (url.length) {
            XLWebViewController *webViewController = [[XLWebViewController alloc] init];
            webViewController.url = url;
            
            [self.navigationController pushViewController:webViewController animated:YES];
        }
    }
}






#pragma mark - WKNavigationDelegate

/**
 *  页面开始加载时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    NSLog(@"%s：%@", __FUNCTION__,webView.URL);
}

/**
 *  当内容开始返回时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
    NSLog(@"%s", __FUNCTION__);
}

/**
 *  页面加载完成之后调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    NSLog(@"%s", __FUNCTION__);
    
}

/**
 *  加载失败时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 *  @param error      错误
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    NSLog(@"%s%@", __FUNCTION__,error);
    [self.navigationController hiddenSGProgress];
}

/**
 *  接收到服务器跳转请求之后调用
 *
 *  @param webView      实现该代理的webview
 *  @param navigation   当前navigation
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
    NSLog(@"%s", __FUNCTION__);
}

/**
 *  在收到响应后，决定是否跳转
 *
 *  @param webView            实现该代理的webview
 *  @param navigationResponse 当前navigation
 *  @param decisionHandler    是否跳转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    NSLog(@"%s", __FUNCTION__);
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}

/**
 *  在发送请求之前，决定是否跳转
 *
 *  @param webView          实现该代理的webview
 *  @param navigationAction 当前navigation
 *  @param decisionHandler  是否调转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSLog(@"URL: %@", navigationAction.request.URL.absoluteString);
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (NSString *)valueForParam:(NSString *)param inUrl:(NSURL *)url {
    
    NSArray *queryArray = [url.query componentsSeparatedByString:@"&"];
    for (NSString *params in queryArray) {
        NSArray *temp = [params componentsSeparatedByString:@"="];
        if ([[temp firstObject] isEqualToString:param]) {
            return [temp lastObject];
        }
    }
    return @"";
}

- (NSMutableDictionary *)paramsOfUrl:(NSURL *)url {
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    
    NSArray *queryArray = [url.query componentsSeparatedByString:@"&"];
    for (NSString *params in queryArray) {
        NSArray *temp = [params componentsSeparatedByString:@"="];
        NSString *key = [temp firstObject];
        NSString *value = temp.count == 2 ? [temp lastObject]:@"";
        [paramDict setObject:value forKey:key];
    }
    return paramDict;
}

- (NSString *)stringByJoinUrlParams:(NSDictionary *)params {
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *key in params.allKeys) {
        [arr addObject:[NSString stringWithFormat:@"%@=%@",key,params[key]]];
    }
    return [arr componentsJoinedByString:@"&"];
}

- (NSString *)urlWithoutQuery:(NSURL *)url {
    NSRange range = [url.absoluteString rangeOfString:@"?"];
    if (range.location != NSNotFound) {
        return [url.absoluteString substringToIndex:range.location];
    }
    return url.absoluteString;
}

#pragma mark - WKUIDelegate

/**
 *  处理js里的alert
 *
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 *  处理js里的confirm
 */
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}


@end
