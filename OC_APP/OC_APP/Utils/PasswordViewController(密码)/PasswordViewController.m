//
//  PasswordViewController.m
//  OC_APP
//
//  Created by xingl on 2017/12/7.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "PasswordViewController.h"

@interface PasswordViewController () {

    UITextField *topTX;
    UIButton *nextBtn;
    UILabel *lab;
    NSMutableArray *dataSource;
    NSString *pass;
}

@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"暂时显示支付密码";

    dataSource = [[NSMutableArray alloc] initWithCapacity:6];
    pass = [[NSString alloc] init];
    [self configUI];

}

- (void)configUI {

    CGSize size = self.view.bounds.size;

    lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(0, 20, size.width, 30);
    lab.text = @"请输入6位数字支付密码";
    lab.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    lab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lab];

    topTX = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    topTX.hidden = YES;
    topTX.keyboardType = UIKeyboardTypeNumberPad;
    [topTX addTarget:self action:@selector(txchange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:topTX];


    nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(20, 200, size.width-40, 50);
    nextBtn.backgroundColor = THEME_color;
    nextBtn.layer.cornerRadius = 6.0;
    nextBtn.hidden = YES;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(goNext:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];

    //进入界面，topTX成为第一响应
    [topTX becomeFirstResponder];

    for (int i = 0; i < 6; i++) {
        UITextField *pwdLabel = [[UITextField alloc] initWithFrame:CGRectMake((size.width-5-50*6)/2.0+i*49, 60, 50, 50)];
        pwdLabel.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
        pwdLabel.enabled = NO;
        pwdLabel.textAlignment = NSTextAlignmentCenter;//居中
        pwdLabel.secureTextEntry = YES;//设置密码模式
        pwdLabel.layer.borderWidth = 1;
        [self.view addSubview:pwdLabel];

        [dataSource addObject:pwdLabel];
    }
}
#pragma mark 文本框内容改变
- (void)txchange:(UITextField *)tx {
    if ([lab.text isEqualToString:@"请输入6位数字支付密码"]) {
        NSString *password = tx.text;
        for (int i = 0; i < dataSource.count; i++)
        {
            UITextField *pwdtx = [dataSource objectAtIndex:i];
            if (i < password.length)
            {
                NSString *pwd = [password substringWithRange:NSMakeRange(i, 1)];
                pwdtx.text = pwd;
                pwdtx.font = [UIFont systemFontOfSize:30];
            } else {
                pwdtx.text = nil;
            }

        }

        if (password.length == 6)
        {
            NSLog(@"密码:%@",password);
            pass = password;
            tx.text = nil;
            lab.text = @"请再次输入6位数字支付密码";

            for (int i = 0; i < dataSource.count; i++)
            {
                UITextField *pwdtx = [dataSource objectAtIndex:i];
                pwdtx.text = nil;

            }

        }
    } else if ([lab.text isEqualToString:@"请再次输入6位数字支付密码"]) {

        nextBtn.hidden = NO;

        nextBtn.enabled = NO;

        NSString *password = tx.text;
        for (int i = 0; i < dataSource.count; i++)
        {
            UITextField *pwdtx = [dataSource objectAtIndex:i];
            if (i < password.length)
            {
                NSString *pwd = [password substringWithRange:NSMakeRange(i, 1)];
                pwdtx.text = pwd;
                pwdtx.font = [UIFont systemFontOfSize:30];
            } else {
                pwdtx.text = nil;
            }

        }
        if (password.length == 6)
        {
            NSLog(@"密码:%@",password);

            nextBtn.enabled = YES;

            if (password == pass) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"密码通过" delegate:nil cancelButtonTitle:@"完成" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"你输入的密码不一致" delegate:nil cancelButtonTitle:@"完成" otherButtonTitles:nil, nil];
                [alert show];
            }

        }

    }

}
- (void)goNext:(UIButton *)sender {
    NSLog(@"------");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    if ([topTX isFirstResponder]) {
        [topTX resignFirstResponder];
    } else {
        [topTX becomeFirstResponder];
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
