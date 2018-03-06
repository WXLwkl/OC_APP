//
//  XLWebViewController.h
//  OC_APP
//
//  Created by xingl on 2018/3/2.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "RootViewController.h"
#import "XLWebView.h"

@interface XLWebViewController : RootViewController <WKUIDelegate, WKNavigationDelegate,XLWebViewMessageHandleDelegate>

@property (nonatomic, strong) XLWebView *webView;
@property (nonatomic,   copy) NSString *url;


@end
