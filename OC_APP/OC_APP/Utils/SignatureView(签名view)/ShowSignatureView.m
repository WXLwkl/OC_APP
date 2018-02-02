//
//  ShowSignatureView.m
//  OC_APP
//
//  Created by xingl on 2018/1/29.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "ShowSignatureView.h"
#import "SignatureView.h"

#define SignatureViewHeight ((kScreenWidth*(350))/(375))

@interface ShowSignatureView () <SignatureViewDelegate> {
    UIView *_mainView;
    UIButton *_maskView;
    SignatureView *signatureView;
    UIButton *btn3;
}

@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation ShowSignatureView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = RGBAColor(0, 0, 0, 0.4);
        self.userInteractionEnabled = YES;
        
        [self setupView];
    }
    return self;
}

- (id)initWithMainView:(UIView*)mainView
{
    self = [super init];
    if(self)
    {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.userInteractionEnabled = YES;
        _mainView = mainView;
        [self setupView];
    }
    return self;
}

- (void)showInView:(UIView *)view {
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
}

- (void)setupView {
    
    _maskView = [UIButton buttonWithType:UIButtonTypeCustom];
    _maskView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _maskView.backgroundColor = RGBAColor(0, 0, 0, 0.4);
    _maskView.userInteractionEnabled = YES;
    [_maskView addTarget:self action:@selector(onTapMaskView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_maskView];
    
    //背景
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 0)];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.backgroundView.userInteractionEnabled = YES;
    [_maskView addSubview:self.backgroundView];
    
    UILabel *headView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    headView.backgroundColor = [UIColor whiteColor];
    headView.textAlignment = NSTextAlignmentCenter;
    headView.textColor = RGBColor(0.32 * 256, 0.32 * 256, 0.32 * 256);
    headView.font = [UIFont systemFontOfSize:15];
    
    UIView *sepView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 45, kScreenWidth, 1)];
    sepView1.backgroundColor = RGBColor(238, 238, 238);
    [self.backgroundView addSubview:sepView1];
    headView.text = @"";
    [self.backgroundView addSubview:headView];
    
    signatureView = [[SignatureView alloc] initWithFrame:CGRectMake(0,46, kScreenWidth, SignatureViewHeight - 44 - 44)];
    signatureView.backgroundColor = [UIColor whiteColor];
    signatureView.delegate = self;
    signatureView.showMessage = @"";
    [self.backgroundView addSubview:signatureView];
    
    
    UIButton *OKBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 50, 0, 44, 44)];
    [OKBtn setTitle:@"清除" forState:UIControlStateNormal];
    [OKBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    OKBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [OKBtn addTarget:self action:@selector(onClear) forControlEvents:UIControlEventTouchUpInside];
    [OKBtn setTitleColor:[UIColor colorWithRed:155.0/255 green:155.0/255 blue:155.0/255 alpha:1.0]forState:UIControlStateNormal];
    [self.backgroundView addSubview:OKBtn];
    
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(6, 0, 44, 44)];
    [cancelBtn setTitle:@"签名" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn setTitleColor:[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0]forState:UIControlStateNormal];
    [self.backgroundView addSubview:cancelBtn];
    
    
    btn3 = [[UIButton alloc] initWithFrame:CGRectMake(0, SignatureViewHeight-44, kScreenWidth, 44)];
    [btn3 setTitle:@"提交" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:0.5] forState:UIControlStateNormal];
    btn3.titleLabel.font = [UIFont systemFontOfSize:15];
    btn3.backgroundColor = [UIColor colorWithRed:0.1529 green:0.7765 blue:0.7765 alpha:1.0];
    [btn3 addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:btn3];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.backgroundView setFrame:CGRectMake(0, kScreenHeight -SignatureViewHeight, kScreenWidth, SignatureViewHeight)];
    } completion:^(BOOL finished) {
    }];
}

- (void)cancelAction {
    [self hide];
}

- (void)show {
    [UIView animateWithDuration:0.5 animations:^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        [self.backgroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, SignatureViewHeight)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)onTapMaskView:(id)sender {
    [self hide];
}
//清除
- (void)onClear {
    [signatureView clear];
    [btn3 setTitleColor:RGBColor(255, 255, 255) forState:UIControlStateNormal];
}

- (void)okAction {
    [signatureView sure];
    if (signatureView.SignatureImg) {
        NSLog(@"haveImage");
        self.hidden = YES;
        [self hide];
        if (self.delegate && [self.delegate respondsToSelector:@selector(onSubmitBtn:)]) {
            [self.delegate onSubmitBtn:signatureView.SignatureImg];
        }
    } else {
        NSLog(@"NoImage");
    }
}

/**
 获取截图图片
 
 @param image 手写绘制图
 */
- (void)getSignatureImg:(UIImage*)image {
    
}


/**
 产生签名手写动作
 */
- (void)onSignatureWriteAction {
    
    [btn3 setTitleColor:RGBColor(255, 255, 255) forState:UIControlStateNormal];
}

@end
