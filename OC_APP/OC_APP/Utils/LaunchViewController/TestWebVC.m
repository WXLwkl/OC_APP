//
//  TestWebVC.m
//  广告启动页Demo
//
//  Created by xingl on 2016/9/28.
//  Copyright © 2016年 yjpal. All rights reserved.
//

#import "TestWebVC.h"

@interface TestWebVC ()

@property (nonatomic,strong) UIWebView * webView;

@end

@implementation TestWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"<-" style:UIBarButtonItemStylePlain target:self action:@selector(goBackAction)];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"首页" style:UIBarButtonItemStylePlain target:self action:@selector(GoBackAction)];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
//    self.webView.delegate = self;
    
    [self.view addSubview:self.webView];
    
    NSURL * url = [NSURL URLWithString:_url];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
}

//返回
- (void)goBackAction
{
    if ([self.webView canGoBack])
    {
        [self.webView goBack];
    } else {
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.3];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromLeft];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        
        [self.view.window.layer addAnimation:animation forKey:nil];
        
        [self presentViewController:self.mainViewController animated:NO completion:nil];
    }
}


@end



//@implementation UIViewController (Public)
//- (UINavigationController*)xl_navigationController
//{
//    UINavigationController* nav = nil;
//    if ([self isKindOfClass:[UINavigationController class]]) {
//        nav = (id)self;
//    }
//    else {
//        if ([self isKindOfClass:[UITabBarController class]]) {
//            nav = [((UITabBarController*)self).selectedViewController xl_navigationController];
//        }
//        else {
//            nav = self.navigationController;
//        }
//    }
//    return nav;
//}
//@end




