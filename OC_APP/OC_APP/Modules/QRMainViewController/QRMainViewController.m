//
//  QRMainViewController.m
//  OC_APP
//
//  Created by xingl on 2017/7/21.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "QRMainViewController.h"
#import "QRScanViewController.h"

@interface QRMainViewController ()

@property (nonatomic, assign) CGFloat brightness;

@end

@implementation QRMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"二维码";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"qrItem"] style:UIBarButtonItemStylePlain target:self action:@selector(qrScanAction:)];
    
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(30, 80, kScreenWidth-60, kScreenWidth-60)];
    [self.view addSubview:imgV];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        UIImage *image = [UIImage xl_qrCodeImageWithContent:@"http://weixin.qq.com/r/osx1bTzE12GorXgO95mw" codeImageLenght:400 logo:[UIImage imageNamed:@"weixin.png"] radius:10];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            imgV.image = image;
        });
    });
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imgV.frame), kScreenWidth, 40)];
    label.text = @"扫一扫上面的二维码图案，加我微信";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.brightness = [UIScreen mainScreen].brightness;
    
    [[UIScreen mainScreen] setBrightness:0.7f];
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [[UIScreen mainScreen] setBrightness:self.brightness];
    [super viewWillDisappear:animated];
}

- (void)qrScanAction:(UIBarButtonItem *)sender {
    QRScanViewController *vc = [[QRScanViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
