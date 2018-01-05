//
//  RootWebViewController.m
//  OC_APP
//
//  Created by xingl on 2017/12/15.
//  Copyright © 2017年 兴林. All rights reserved.
//

#define k404NotFoundHTMLPath [[NSBundle bundleForClass:NSClassFromString(@"html")] pathForResource:@"html.bundle/404" ofType:@"html"]
#define kNetworkErrorHTMLPath [[NSBundle bundleForClass:NSClassFromString(@"html")] pathForResource:@"html.bundle/neterror" ofType:@"html"]

#import "RootWebViewController.h"
#import <WebKit/WebKit.h>

static NSUInteger const kContainerViewTag = 0x893147;

@interface RootWebViewController ()<WKUIDelegate, WKNavigationDelegate> {
    NSURL *rootURL;
}

// 进度条
@property (nonatomic, strong) UIProgressView *progressView;

// Container view.
@property(readonly, nonatomic) UIView *containerView;

@property(strong, nonatomic) UILabel *backgroundLabel;

@end

@implementation RootWebViewController

#pragma mark - init
- (instancetype)init {
    if (self = [super init]) {
        [self initializer];
    }
    return self;
}

- (instancetype)initWithURL:(NSString *)url {
    if (self = [super init]) {
        rootURL = [NSURL URLWithString:url];
        [self initializer];
    }
    return self;
}

- (instancetype)initWithFile:(NSString *)url {
    if (self = [super init]) {
        rootURL = [NSURL fileURLWithPath:url];
        [self initializer];
    }
    return self;
}

#pragma mark - set
- (void)setProgressTintColor:(UIColor *)progressTintColor {
    _progressTintColor = progressTintColor;

    self.progressView.progressTintColor = progressTintColor;
}

- (void)setRootUrlStrig:(NSString *)rootUrlStrig {

    _rootUrlStrig = rootUrlStrig;

    [self loadUrlString:_rootUrlStrig];
}
- (void)setMaxAllowedTitleLength:(NSUInteger)maxAllowedTitleLength {

    _maxAllowedTitleLength = maxAllowedTitleLength;
    [self _updateTitleOfWebVC];
}
//- (void)setTimeoutInternal:(NSTimeInterval)timeoutInternal {
//    _timeoutInternal = timeoutInternal;
//    NSMutableURLRequest *request = [_request mutableCopy];
//    request.timeoutInterval = _timeoutInternal;
//    _navigation = [_webView loadRequest:request];
//    _request = [request copy];
//}
//
//- (void)setCachePolicy:(NSURLRequestCachePolicy)cachePolicy {
//    _cachePolicy = cachePolicy;
//
//    NSMutableURLRequest *request = [_request mutableCopy];
//    request.cachePolicy = _cachePolicy;
//    _navigation = [_webView loadRequest:request];
//    _request = [request copy];
//
//}

- (void)setShowsBackgroundLabel:(BOOL)showsBackgroundLabel {

    self.backgroundLabel.hidden = !showsBackgroundLabel;
    _showsBackgroundLabel = showsBackgroundLabel;
}

#pragma mark - 对外
- (void)reload {
    if (rootURL) [self.webView reload];
}

- (void)reloadRootURL {
    if (rootURL) {
        [self loadURL:rootURL];
    }
}

- (void)loadURL:(NSURL *)url {

    if (!url) return;
    rootURL = url;
    if (_webView) {

        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

- (void)loadUrlString:(NSString *)urlString {

    urlString = XL_FilterString(urlString);
    if (XL_IsEmptyString(urlString)) return;

    if ([urlString respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]) {

        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    else{

        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }

    NSURL *url = [NSURL URLWithString:urlString];

    [self loadURL:url];
}

- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL {
    string = XL_FilterString(string);
    if (XL_IsEmptyString(string)) return;

    [self.webView loadHTMLString:string
                              baseURL:baseURL];
}

#pragma mark - life

- (void)dealloc {
    [self.webView stopLoading];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    self.webView.UIDelegate = nil;
    self.webView.navigationDelegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    [self initSubviews];
    [self setupSubviews];

}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    [self updateNavigationItems];

    if (@available(iOS 11.0, *)) {} else {
        id<UILayoutSupport> topLayoutGuide = self.topLayoutGuide;
        id<UILayoutSupport> bottomLayoutGuide = self.bottomLayoutGuide;

        UIEdgeInsets contentInsets = UIEdgeInsetsMake(topLayoutGuide.length, 0.0, bottomLayoutGuide.length, 0.0);
        if (!UIEdgeInsetsEqualToEdgeInsets(contentInsets, self.webView.scrollView.contentInset)) {
            [self.webView.scrollView setContentInset:contentInsets];
        }
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self updateNavigationItems];
}

- (void)initializer {

    _maxAllowedTitleLength = 10;
    //    _timeoutInternal = 30.0;
    _showsBackgroundLabel = YES;

    self.extendedLayoutIncludesOpaqueBars = NO;
}

- (void)initSubviews {

    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:[self configuretion]];
    _webView.allowsBackForwardNavigationGestures =YES; //手势返回
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.scrollView.backgroundColor = [UIColor clearColor];
    _webView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:_webView];

    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [_webView addObserver:self forKeyPath:@"title"
                  options:NSKeyValueObservingOptionNew context:NULL];

    [_webView loadRequest:[NSURLRequest requestWithURL:rootURL]];

    //进度条初始化
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 2)];
    self.progressView.backgroundColor = [UIColor blueColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);

    [self.view addSubview:self.progressView];


    if([self isNavigationHidden]){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)setupSubviews {
    // Add from label and constraints.

    id topLayoutGuide = self.topLayoutGuide;
    id bottomLayoutGuide = self.bottomLayoutGuide;

    // Add web view.

    [self.containerView addSubview:self.backgroundLabel];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_backgroundLabel(<=width)]" options:0 metrics:@{@"width":@(self.view.bounds.size.width)} views:NSDictionaryOfVariableBindings(_backgroundLabel)]];
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];

    [self.containerView addSubview:self.webView];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_webView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_webView)]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_webView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_webView, topLayoutGuide, bottomLayoutGuide, self.backgroundLabel)]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_backgroundLabel]-20-[_webView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backgroundLabel, _webView)]];

    [self.containerView bringSubviewToFront:self.backgroundLabel];

}

- (void)loadView {
    [super loadView];

    UIView *container = [UIView new];
    [container setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:container];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[container]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(container)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[container]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(container)]];
    [container setTag:kContainerViewTag];
}

- (UIView *)containerView {
    return [self.view viewWithTag:kContainerViewTag];
}

- (UILabel *)backgroundLabel {
    if (!_backgroundLabel) {
        _backgroundLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _backgroundLabel.textColor = [UIColor colorWithRed:0.180 green:0.192 blue:0.196 alpha:1.00];
        _backgroundLabel.font = [UIFont systemFontOfSize:12];
        _backgroundLabel.textAlignment = NSTextAlignmentCenter;
        _backgroundLabel.numberOfLines = 0;
        _backgroundLabel.backgroundColor = [UIColor redColor];
        _backgroundLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_backgroundLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _backgroundLabel.hidden = !self.showsBackgroundLabel;
    }
    return _backgroundLabel;
}

- (WKWebViewConfiguration *)configuretion {
    WKWebViewConfiguration *configuretion = [[NSClassFromString(@"WKWebViewConfiguration") alloc] init];
    configuretion.preferences = [[WKPreferences alloc]init];
    configuretion.preferences.minimumFontSize = 10;
    configuretion.preferences.javaScriptEnabled = true;
    configuretion.processPool = [[WKProcessPool alloc]init];
    configuretion.userContentController = [[WKUserContentController alloc] init];
    //    if (@available(iOS 9.0, *)) {
    //        if ([configuretion respondsToSelector:@selector(setApplicationNameForUserAgent:)]) {
    //
    //            [configuretion setApplicationNameForUserAgent:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]];
    //        }
    //    }
    // 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
    configuretion.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    return configuretion;
}

- (void)updateNavigationItems {

    if (!self.navigationItem) return;

    NSMutableArray *items = [NSMutableArray array];

    if ([self.navigationController.viewControllers count]>1 || [self.webView canGoBack]) {

        UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 56, 44)];
        [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [backBtn sizeToFit];
        [backBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
        [backBtn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];

        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];

        [items addObject:backItem];
    }

    if ([self.navigationController.viewControllers count] > 1 && [self.webView canGoBack]) {

        UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(xl_closeSelfAction)];
        closeItem.customView.backgroundColor = [UIColor greenColor];
        [items addObject:closeItem];

        UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedSpace.width = 15.0;
        [items addObject:fixedSpace];
    }
    self.navigationItem.leftBarButtonItems = items;
}

- (void)goBackAction {
    if ([self.webView canGoBack]) {

        [self.webView goBack];
    } else {

        [self xl_closeSelfAction];
    }
}

#pragma makr Private
- (BOOL)isNavigationHidden {
    return !self.navigationController
    || !self.navigationController.navigationBar.isTranslucent
    || !self.navigationController.navigationBar;
}


#pragma mark - Helper
- (void)_updateTitleOfWebVC {
    NSString *title = self.title;
    title = title.length>0 ? title: [_webView title];

    if (title.length > _maxAllowedTitleLength) {
        title = [[title substringToIndex:_maxAllowedTitleLength-1] stringByAppendingString:@"…"];
    }
    self.navigationItem.title = title;
}

- (void)didStartLoad {

    self.navigationItem.title = @"Loading...";
    self.backgroundLabel.text = @"Loading...";
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    [self updateNavigationItems];

    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}

- (void)didStartLoadWithObj:(id)object {
    Class WKNavigationClass = NSClassFromString(@"WKNavigationClass");
    if (WKNavigationClass == NULL) {
        if (![object isKindOfClass:WKNavigationClass] || object == nil) {
            [self didStartLoad];
            return;
        }
    }
    [self didStartLoad];
}


- (void)didFinishLoad {

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self updateNavigationItems];
    [self _updateTitleOfWebVC];

    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *bundle = ([infoDictionary objectForKey:@"CFBundleDisplayName"]?:[infoDictionary objectForKey:@"CFBundleName"])?:[infoDictionary objectForKey:@"CFBundleIdentifier"];

    NSString *host = _webView.URL.host;

    self.backgroundLabel.text = [NSString stringWithFormat:@"%@\"%@\"%@.", @"web page", host?:bundle, @"provided"];

}

- (void)didFailLoadWithError:(NSError *)error {

    if (error.code == NSURLErrorCannotFindHost) {// 404

        [self loadURL:[NSURL fileURLWithPath:k404NotFoundHTMLPath]];
    } else {

        [self loadURL:[NSURL fileURLWithPath:kNetworkErrorHTMLPath]];
    }
    self.backgroundLabel.text = [NSString stringWithFormat:@"%@%@",@"load failed:", error.localizedDescription];
    self.navigationItem.title = @"load failed";

    [self updateNavigationItems];

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

}
#pragma mark - WKNavigationDelegate 方法较为常用

//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//
//}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {

    decisionHandler(WKNavigationResponsePolicyAllow);
}
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"开始加载网页");
    [self didStartLoadWithObj:navigation];

}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{

}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

//    NSString *doc = @"document.body.outerHTML";
//    [webView evaluateJavaScript:doc
//                     completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
//                         if (error) {
//                             NSLog(@"JSError:%@",error);
//                         }
//                         NSLog(@"html:%@",htmlStr);
//                     }] ;

    [self didFinishLoad];
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (error.code == NSURLErrorCancelled) return;

    [self didFailLoadWithError:error];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(nonnull NSError *)error {
    if (error.code == NSURLErrorCancelled) return;

    [self didFailLoadWithError:error];
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    // Get the host name.
    NSString *host = webView.URL.host;
    // Initialize alert view controller.
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:host message:@"terminate" preferredStyle:UIAlertControllerStyleAlert];
    // Initialize cancel action.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:NULL];
    // Initialize ok action.
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:NULL];
    }];
    // Add actions.
    [alert addAction:cancelAction];
    [alert addAction:okAction];
}
#endif
#pragma mark - WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {

    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        if (navigationAction.request) {
            [webView loadRequest:navigationAction.request];
        }
    }
    return nil;
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
- (void)webViewDidClose:(WKWebView *)webView {
}
#endif
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
//    completionHandler(@"http");

    // Get the host of url.
    NSString *host = webView.URL.host;
    // Initialize alert view controller.
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:prompt message:host preferredStyle:UIAlertControllerStyleAlert];
    // Add text field.
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = defaultText;
        textField.font = [UIFont systemFontOfSize:12];
    }];
    // Initialize cancel action.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:NULL];
        // Get inputed string.
        NSString *string = [alert.textFields firstObject].text;
        if (completionHandler != NULL) {
            completionHandler(string?:defaultText);
        }
    }];
    // Initialize ok action.
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:NULL];
        // Get inputed string.
        NSString *string = [alert.textFields firstObject].text;
        if (completionHandler != NULL) {
            completionHandler(string?:defaultText);
        }
    }];
    // Add actions.
    [alert addAction:cancelAction];
    [alert addAction:okAction];
}

// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSLog(@"%@",message);
    //  js 里面的alert实现，如果不实现，网页的alert函数无效  ,
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        completionHandler();
    }]];

    [self presentViewController:alertController animated:YES completion:nil];
}

// 确认框
-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    //  js 里面的alert实现，如果不实现，网页的alert函数无效  ,
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler(YES);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        completionHandler(NO);
    }]];

    [self presentViewController:alertController animated:YES completion:^{}];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 进度条KVO的监听方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;

            }];
        }
    } else if ([keyPath isEqualToString:@"title"]) {


        [self _updateTitleOfWebVC];
        [self updateNavigationItems];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


@end
