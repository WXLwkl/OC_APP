//
//  WebJSBridgeViewController.m
//  OC_APP
//
//  Created by xingl on 2018/1/4.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "WebJSBridgeViewController.h"
#import "WebViewJavascriptBridge.h"

@interface WebJSBridgeViewController ()

@property WebViewJavascriptBridge *bridge;

@end

@implementation WebJSBridgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    if(htmlPath.length==0) return;
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [self loadHTMLString:appHtml baseURL:baseURL];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
