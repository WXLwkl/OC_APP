//
//  XLWebViewController.m
//  OC_APP
//
//  Created by xingl on 2018/3/2.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "ScriptMessageHandlerViewController.h"
#import "AudioTool.h"

@interface ScriptMessageHandlerViewController ()

@end

@implementation ScriptMessageHandlerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.webView loadLocalHTMLWithFileName:@"main"];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"调用JS" style:UIBarButtonItemStylePlain target:self action:@selector(callJS:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - WebView

- (void)callJS:(id)sender {
    
    [self.webView callJS:[NSString stringWithFormat:@"callJs('我是Objective-C')"] handler:^(NSString *response) {
        NSLog(@"JS返回结果：%@",response);
    }];
}

- (void)webView:(XLWebView *)webView didReceiveScriptMessage:(ScriptMessage *)message {
    if ([message.method isEqualToString:@"scanClick"]) {
        NSLog(@"这是个扫一扫按钮功能内容有%@", message.params);
    } else if ([message.method isEqualToString:@"locationClick"]) {
        if (message.callback.length) {
            [self.webView callJS:[NSString stringWithFormat:@"%@('女儿国')",message.callback] handler:^(id  _Nullable response) {
                NSLog(@"调用callback结果：%@",response);
            }];
        }
    } else if ([message.method isEqualToString:@"shareClick"]) {
        
        NSString *title = message.params[@"title"];
        NSString *content = message.params[@"content"];
        NSString *url = message.params[@"url"];
        
        if (message.callback.length) {
            [self.webView callJS:[NSString stringWithFormat:@"%@('%@ %@ %@')",message.callback, title, content, url] handler:^(id  _Nullable response) {
                NSLog(@"调用callback结果：%@",response);
            }];
        }
    } else if ([message.method isEqualToString:@"payClick"]) {
        
        NSString *orderNo = [message.params objectForKey:@"order_no"];
        long long amount = [[message.params objectForKey:@"amount"] longLongValue];
        NSString *subject = [message.params objectForKey:@"subject"];
        NSString *channel = [message.params objectForKey:@"channel"];
        NSLog(@"%@---%lld---%@---%@",orderNo,amount,subject,channel);
        
        
        if (message.callback.length) {
            [self.webView callJS:[NSString stringWithFormat:@"%@('%@')",message.callback, @"支付成功"] handler:^(id  _Nullable response) {
                NSLog(@"调用callback结果：%@",response);
            }];
        }
    } else if ([message.method isEqualToString:@"playSound"]) {
        
        AudioTool *tool = [[AudioTool alloc] initSystemSoundWithName:message.params[@"value"] SoundType:@"caf"];
        [tool play];
    } else {
        [super webView:webView didReceiveScriptMessage:message];
    }
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
