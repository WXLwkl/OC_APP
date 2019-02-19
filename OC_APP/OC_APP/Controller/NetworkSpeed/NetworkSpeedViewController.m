//
//  NetworkSpeedViewController.m
//  OC_APP
//
//  Created by xingl on 2019/2/18.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "NetworkSpeedViewController.h"
#import "NetworkSpeedView.h"
#import "MeasurNetTools.h"
#import <AFNetworking.h>

@interface NetworkSpeedViewController ()

@property (strong, nonatomic) NetworkSpeedView *rectView;

@property (strong, nonatomic) UILabel *numberLb;
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UILabel *ipLabel;
@property (nonatomic, strong) UILabel *placeLabel;

@property (nonatomic, assign) CGFloat lastTrans;

@end

@implementation NetworkSpeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"测网速";
    
    [self initSubviews];
    
    WeakSelf(self);
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    __weak typeof(AFNetworkReachabilityManager *) weakReachabilityManager = reachabilityManager;
    [reachabilityManager startMonitoring];
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
//            [MBProgressHUD addTipWith:self.view WithTipContent:@"暂无网络"];
        } else if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
            
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前是移动网络，测速可能会消耗较多流量，是否继续测速" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"继续" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"返回" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                [weakself.navigationController popViewControllerAnimated:YES];
            }];
            [alertC addAction:alertAction1];
            [alertC addAction:alertAction];
            [self presentViewController:alertC animated:YES completion:nil];
        }
        
        [weakReachabilityManager stopMonitoring];
    }];
}

- (void)initSubviews {
    CGFloat width = kScreenWidth - 40;
    CGFloat height = kScreenWidth - 40;
    CGFloat x = 20;
    CGFloat y = 80;
    
    _rectView = [[NetworkSpeedView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [_rectView show];
    [self.view addSubview:_rectView];
    
    _numberLb = [[UILabel alloc] initWithFrame:CGRectMake(80, CGRectGetMaxX(_rectView.frame)-30, kScreenWidth-160, 45)];
    _numberLb.textAlignment = NSTextAlignmentCenter;
    _numberLb.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    _numberLb.backgroundColor = [UIColor clearColor];
    _numberLb.textColor = [UIColor whiteColor];
    [self.view addSubview:_numberLb];
    
    _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_numberLb.frame)+10, kScreenWidth, 18)];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.backgroundColor = [UIColor clearColor];
    _messageLabel.textColor = [UIColor whiteColor];
    _messageLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    [self.view addSubview:_messageLabel];
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(80, CGRectGetMaxY(_rectView.frame), kScreenWidth-160, 60);
    [button setBackgroundImage:[UIImage imageNamed:@"cwsanniubg"] forState:(UIControlStateNormal)];
    [button setTitle:@"测网速" forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
    
    _ipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(button.frame)+15, kScreenWidth, 20)];
    _ipLabel.textAlignment = NSTextAlignmentCenter;
    _ipLabel.font = [UIFont systemFontOfSize:15];
    _ipLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:.5];
    [self.view addSubview:_ipLabel];
    
    
    _placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_ipLabel.frame)+5, kScreenWidth, 20)];
    _placeLabel.textAlignment = NSTextAlignmentCenter;
    _placeLabel.font = [UIFont systemFontOfSize:15];
    _placeLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:.5];
    [self.view addSubview:_placeLabel];
    
    _lastTrans = -0.75*M_PI;
}

- (void)buttonClick:(UIButton *)button {
    button.enabled = NO;
    _messageLabel.text = @"正在检测网络,请稍后";
    
    if (_lastTrans != -0.75*M_PI) {
        if (_lastTrans > 0) {
            [self setRectViewTrans:0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self setRectViewTrans:-0.75*M_PI];
                [self startNetSpeedWith:button];
            });
        } else {
            [self setRectViewTrans:-0.75*M_PI];
            [self startNetSpeedWith:button];
        }
    } else {
        [self startNetSpeedWith:button];
    }
}

- (void)setRectViewTrans:(CGFloat)trans {
    _rectView.needleLayer.transform = CATransform3DMakeRotation(trans, 0, 0, 1);
}

- (void)startNetSpeedWith:(UIButton *)button {
    [self setIp];
    MeasurNetTools *measurNet = [[MeasurNetTools alloc] initWithblock:^(float speed) {
        [self setProgressWith:speed andIsLast:NO];
    } finishMeasureBlock:^(float speed) {
        [self setProgressWith:speed andIsLast:YES];
        self.messageLabel.text = [NSString stringWithFormat:@"当前速度相当于%@带宽",[self formatBandWidth:speed/timeCount]];
        button.enabled = YES;
    } failedBlock:^(NSError * _Nonnull error) {
        button.enabled = YES;
    }];
    [measurNet startMeasur];
}

- (void)setProgressWith:(CGFloat)speed andIsLast:(BOOL)isLast {
    speed = speed / timeCount;
    NSString *speedStr = [NSString stringWithFormat:@"%@/S", [self formattedFileSize:speed]];
    _numberLb.text = speedStr;
    CGFloat llM = 0;
    CGFloat llMFloat = speedStr.floatValue;
    if ([speedStr containsString:@"KB"]) {
        llM = llMFloat / 1024;
    } else if ([speedStr containsString:@"M"]) {
        llM = llMFloat;
    } else if ([speedStr containsString:@"bytes"]) {
        llM = llMFloat / 1024 / 1024;
    } else if ([speedStr containsString:@"GB"]) {
        llM = llMFloat * 1024;
    }
    
    CGFloat angle = llM / (CGFloat)12 * 1.5 * M_PI;
    CGFloat needAngle = angle - 0.75 * M_PI;
    
    if (needAngle > 0.75 * M_PI) {
        needAngle = 0.75 * M_PI;
    }
    if (needAngle < -0.75*M_PI) {
        needAngle = -0.75*M_PI;
    }
    [self setRectViewTrans:needAngle];
    if (isLast) {
        _lastTrans = needAngle;
    }
}

- (void)setIp {
    NSURL *url = [NSURL URLWithString:@"http://ip.taobao.com/service/getIpInfo.php?ip=myip"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:(NSURLRequestReloadIgnoringLocalAndRemoteCacheData) timeoutInterval:100];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError == nil) {
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
            NSDictionary *dic = dataDic[@"data"];
            
            self.ipLabel.text = [NSString stringWithFormat:@"IP: %@", dic[@"ip"]];
            
            NSString *country = dic[@"country"];
            if ([country isKindOfClass:[NSString class]] && [country isEqualToString:@"中国"]) {
                NSString *city = dic[@"city"];
                if ([city isKindOfClass:[NSString class]] && city.length > 0) {
                    country = city;
                }
            }
            self.placeLabel.text = [NSString stringWithFormat:@"%@%@",country,dic[@"isp"]];
        }
    }];
}

- (NSString *)formattedFileSize:(unsigned long long)size {
    return [self formattedFileSize:size suffixLenth:NULL];
}

- (NSString *)formattedFileSize:(unsigned long long)size suffixLenth:(NSInteger *)length {
    NSInteger len = 0;
    NSString *formattedStr = nil;
    size = size;
    if (size == 0)
        formattedStr = NSLocalizedString(@"0 KB",@""), len = 2;
    else
        if (size > 0 && size < 1024)
            formattedStr = [NSString stringWithFormat:@"%qubytes", size], *length = 2, len = 7;
        else
            if (size >= 1024 && size < pow(1024, 2))
                formattedStr = [NSString stringWithFormat:@"%.2fKB", (size / 1024.)], len = 2;
            else
                if (size >= pow(1024, 2) && size < pow(1024, 3))
                    formattedStr = [NSString stringWithFormat:@"%.2fMB", (size / pow(1024, 2))], len = 2;
                else
                    if (size >= pow(1024, 3))
                        formattedStr = [NSString stringWithFormat:@"%.2fGB", (size / pow(1024, 3))], len = 2;
    if (length) {
        *length = len;
    }
    return formattedStr;
}
- (NSString *)formatBandWidth:(unsigned long long)size {
    size *=8;
    
    NSString *formattedStr = nil;
    if (size == 0){
        formattedStr = NSLocalizedString(@"0",@"");
        
    }else if (size > 0 && size < 1024){
        formattedStr = [NSString stringWithFormat:@"%qu", size];
        
    }else if (size >= 1024 && size < pow(1024, 2)){
        int intsize = (int)(size / 1024);
        int model = size % 1024;
        if (model > 512) {
            intsize += 1;
        }
        
        formattedStr = [NSString stringWithFormat:@"%dK",intsize ];
        
    }else if (size >= pow(1024, 2) && size < pow(1024, 3)){
        unsigned long long l = pow(1024, 2);
        int intsize = size / pow(1024, 2);
        int  model = (int)(size % l);
        if (model > l/2) {
            intsize +=1;
        }
        formattedStr = [NSString stringWithFormat:@"%dM", intsize];
        
    }else if (size >= pow(1024, 3)){
        int intsize = size / pow(1024, 3);
        formattedStr = [NSString stringWithFormat:@"%dG", intsize];
    }
    
    return formattedStr;
}

@end
