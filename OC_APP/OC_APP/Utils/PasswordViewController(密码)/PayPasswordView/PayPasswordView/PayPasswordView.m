//
//  PayPasswordView.m
//  OC_APP
//
//  Created by xingl on 2017/12/12.
//  Copyright © 2017年 兴林. All rights reserved.
//


#import "PayPasswordView.h"
#import "TradeKeyboard.h"
#import "TradeInputView.h"

@interface PayPasswordView ()
/** 键盘 */
@property (nonatomic, weak) TradeKeyboard *keyboard;
/** 输入框 */
@property (nonatomic, weak) TradeInputView *inputView;
/** 蒙板 */
@property (nonatomic, weak) UIButton *cover;
/** 响应者 */
@property (nonatomic, weak) UITextField *responsder;
/** 键盘状态 */
@property (nonatomic, assign, getter=isKeyboardShow) BOOL keyboardShow;
/** 返回密码 */
@property (nonatomic, copy) NSString *passWord;
@end

@implementation PayPasswordView

#pragma mark - LifeCircle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        /** 蒙板 */
        [self setupCover];
        /** 键盘 */
        [self setupkeyboard];
        /** 输入框 */
        [self setupInputView];
        /** 响应者 */
        [self setupResponsder];
    }
    return self;
}

/** 蒙板 */
- (void)setupCover {
    UIButton *cover = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:cover];
    self.cover = cover;
    [self.cover setBackgroundColor:[UIColor blackColor]];
    self.cover.alpha = 0.4;
    [self.cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
}
/** 输入框 */
- (void)setupInputView {
    TradeInputView *inputView = [[TradeInputView alloc] init];
    [self addSubview:inputView];
    self.inputView = inputView;

    /** 注册取消按钮点击的通知 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancle) name:TradeInputViewCancleButtonClick object:nil];
    /** 注册确定按钮点击的通知 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputViewOk:) name:TradeInputViewOkButtonClick object:nil];
}
/** 响应者 */
- (void)setupResponsder {
    UITextField *responsder = [[UITextField alloc] init];
    [self addSubview:responsder];
    self.responsder = responsder;
}
/** 键盘 */
- (void)setupkeyboard {
    TradeKeyboard *keyboard = [[TradeKeyboard alloc] init];
    [self addSubview:keyboard];
    self.keyboard = keyboard;

    // 注册确定按钮点击通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ok) name:TradeKeyboardOkButtonClick object:nil];
}
#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];

    /** 蒙板 */
    self.cover.frame = self.bounds;
}

#pragma mark - Private
- (void)coverClick {
    if (self.isKeyboardShow) {  // 键盘是弹出状态
        [self hidenKeyboard:nil];
    } else {  // 键盘是隐藏状态
        [self showKeyboard];
    }
}
/** 键盘弹出 */
- (void)showKeyboard
{
    self.keyboardShow = YES;

    CGFloat marginTop;
    if (iPhone4) {
        marginTop = 42;
    } else if (iPhone5SE) {
        marginTop = 100;
    } else if (iPhone6_6s) {
        marginTop = 120;
    } else {
        marginTop = 140;
    }

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.keyboard.transform = CGAffineTransformMakeTranslation(0, -self.keyboard.xl_height);
        self.inputView.transform = CGAffineTransformMakeTranslation(0, marginTop - self.inputView.xl_y);
    } completion:^(BOOL finished) {

    }];
}

/** 键盘退下 */
- (void)hidenKeyboard:(void (^)(BOOL finished))completion
{
    self.keyboardShow = NO;
    //    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    //        self.keyboard.transform = CGAffineTransformIdentity;
    //        self.inputView.transform = CGAffineTransformIdentity;
    //    } completion:^(BOOL finished) {
    //
    //    }];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.keyboard.transform = CGAffineTransformIdentity;
        self.inputView.transform = CGAffineTransformIdentity;
    } completion:completion];
}

/** 键盘的确定按钮点击 */
- (void)ok
{
    [self hidenKeyboard:nil];
}

/** 输入框的取消按钮点击 */
- (void)cancle {
    [self hidenKeyboard:^(BOOL finished) {

        self.inputView.hidden = YES;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否退出?" message:@"" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        [alertView show];
    }];
}

/** 输入框的确定按钮点击 */
- (void)inputViewOk:(NSNotification *)note
{
    // 获取密码
    NSString *pwd = note.userInfo[ZCTradeInputViewPwdKey];
    // 通知代理\传递密码
    if ([self.delegate respondsToSelector:@selector(finish:)]) {
        [self.delegate finish:pwd];
    }
    // 回调block\传递密码
    if (self.finish) {
        self.finish(pwd);
    }
    // 移除自己
    [self hidenKeyboard:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Public Interface

/** 快速创建 */
+ (instancetype)tradeView {
    return [[self alloc] init];
}

/** 弹出 */
- (void)show {
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)showInView:(UIView *)view {
    // 浮现
    [view addSubview:self];

    /** 键盘起始frame */
    self.keyboard.xl_x = 0;
    self.keyboard.xl_y = kScreenHeight;
    self.keyboard.xl_width = kScreenWidth;
    self.keyboard.xl_height = kScreenWidth * 0.65;

    /** 输入框起始frame */
    self.inputView.xl_height = kScreenWidth * 0.5625;
    self.inputView.xl_y = (self.xl_height - self.inputView.xl_height) * 0.5;
    self.inputView.xl_width = kScreenWidth * 0.94375;
    self.inputView.xl_x = (kScreenWidth - self.inputView.xl_width) * 0.5;

    /** 弹出键盘 */
    [self showKeyboard];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.inputView.hidden = NO;
    if (buttonIndex == 0) {  // 否按钮点击
        [self showKeyboard];
    } else {  // 是按钮点击
        // 清空num数组
        NSMutableArray *nums = [self.inputView valueForKeyPath:@"nums"];
        [nums removeAllObjects];
        [self removeFromSuperview];
        [self.inputView setNeedsDisplay];
    }
}


@end
