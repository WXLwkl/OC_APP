//
//  LoginViewController.m
//  OC_APP
//
//  Created by xingl on 2017/10/27.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "LoginViewController.h"
#import <POP.h>

static CGFloat const SpringSpeed = 6.0;
static CGFloat const SpringBounciness = 16.0;

@interface LoginViewController ()<CAAnimationDelegate>

/// logo图
@property (nonatomic, strong) UIImageView *loginImage;
///logo下的文字
@property (nonatomic, strong) UILabel *loginWord;
/// get按钮
@property (nonatomic, strong) UIButton *getButton;
/// login按钮
@property (nonatomic, strong) UIButton *loginButton;
/// 登录时加一个看不见的蒙版，让控件不能再点击
@property (nonatomic, strong) UIView *hudView;
/// 执行登录按钮动画的view (动画效果不是按钮本身，而是这个view)
@property (nonatomic, strong) UIView *loginAnimView;
/// 登录转圈的那条白线所在的layer
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
// get按钮动画view
@property (nonatomic, strong) UIView *animView;

// 账号
@property (nonatomic, strong) UITextField *accountTextField;
/// 密码
@property (nonatomic, strong) UITextField *passwordTextField;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.statusBarStyle = UIStatusBarStyleDefault;

    [self layoutSubviews];
    [self initSubviews];
}
- (void)initSubviews {
    UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:dismissBtn];
    [dismissBtn.layer setMasksToBounds:YES];
    [dismissBtn.layer setCornerRadius:15.0];
    dismissBtn.backgroundColor = THEME_color;
    dismissBtn.frame = CGRectMake(20, 50, 30, 30);
    [dismissBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dismissBtn setTitle:@"X" forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];

    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:registerBtn];
    registerBtn.backgroundColor = THEME_color;
    registerBtn.frame = CGRectMake(20, kScreenHeight - 80, 100, 30);
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn setTitle:@"快速注册" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];

}

- (void)layoutSubviews {

    //文字
    self.loginWord.xl_centerX = self.view.xl_centerX;
    self.loginWord.xl_y = self.view.xl_centerY - self.loginWord.xl_height - 20;

    //logo
    CGFloat loginImageWH = kScreenWidth * 0.25;
    self.loginImage.frame = CGRectMake((kScreenWidth - loginImageWH) * 0.5, CGRectGetMinY(self.loginWord.frame) - 10 - loginImageWH, loginImageWH, loginImageWH);

    // get按钮
    CGFloat getButtonW = kScreenWidth * 0.4;
    self.getButton.frame = CGRectMake((kScreenWidth-getButtonW)*0.5, kScreenHeight*0.7 - 20, getButtonW, 44);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ButtonAction
- (void)dismissAction {
    [self xl_closeSelfAction];
}

- (void)getButtonClick {
    // get按钮动画的view
    UIView *animView = [[UIView alloc] init];
    self.animView = animView;
    animView.layer.cornerRadius = 10;
    animView.frame = self.getButton.frame;
    animView.backgroundColor = self.getButton.backgroundColor;
    [self.view addSubview:animView];
    self.getButton.hidden = YES;
    self.loginButton.hidden = NO;
    // get背景颜色
    CABasicAnimation *changeColor1 = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    changeColor1.fromValue = (__bridge id)THEME_color.CGColor;
    changeColor1.toValue = (__bridge id _Nullable)([UIColor whiteColor].CGColor);
    changeColor1.duration = 0.8f;
    changeColor1.beginTime = CACurrentMediaTime();
    changeColor1.fillMode = kCAFillModeForwards;
    changeColor1.removedOnCompletion = false;
    [animView.layer addAnimation:changeColor1 forKey:changeColor1.keyPath];

    // get按钮变宽
    CABasicAnimation *anim1 = [CABasicAnimation animationWithKeyPath:@"bounds.size.width"];
    anim1.fromValue = @(CGRectGetWidth(animView.bounds));
    anim1.toValue = @(kScreenWidth * 0.8);
    anim1.duration = 0.1;
    anim1.beginTime = CACurrentMediaTime();
    anim1.fillMode = kCAFillModeForwards;
    anim1.removedOnCompletion = false;
    [animView.layer addAnimation:anim1 forKey:anim1.keyPath];

    // get按钮变高
    CABasicAnimation *anim2 = [CABasicAnimation animationWithKeyPath:@"bounds.size.height"];
    anim2.fromValue = @(CGRectGetHeight(animView.bounds));
    anim2.toValue = @(kScreenHeight * 0.3);
    anim2.duration = 0.1;
    anim2.beginTime = CACurrentMediaTime() + 0.1;
    anim2.fillMode = kCAFillModeForwards;
    anim2.removedOnCompletion = false;
    anim2.delegate = self; //变高结束后加阴影
    [animView.layer addAnimation:anim2 forKey:anim2.keyPath];

    self.accountTextField.alpha = 0.0;
    self.passwordTextField.alpha = 0.0;
    [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.accountTextField.alpha = 1.0;
        self.passwordTextField.alpha = 1.0;
    } completion:nil];

    // login按钮出现动画
    self.loginButton.xl_centerX = self.view.xl_centerX;
//    self.loginButton.xl_centerY = kScreenHeight * 0.7 + 44 + (kScreenHeight * 0.3 - 44) * 0.5 - 115;
    self.loginButton.xl_centerY = CGRectGetMaxY(self.animView.frame);
    CABasicAnimation *animLoginBtn = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
    animLoginBtn.fromValue = [NSValue valueWithCGSize:CGSizeMake(0, 0)];
    animLoginBtn.toValue = [NSValue valueWithCGSize:CGSizeMake(kScreenWidth * 0.5, 44)];
    animLoginBtn.duration = 0.4;
    animLoginBtn.beginTime = CACurrentMediaTime() + 0.2;
    animLoginBtn.fillMode = kCAFillModeForwards;
    animLoginBtn.removedOnCompletion = false;
    animLoginBtn.delegate = self; // 在代理方法(动画完成回调)里，让按钮真正的宽高改变，而不仅仅是它的layer,否则看得到点不到
    [self.loginButton.layer addAnimation:animLoginBtn forKey:animLoginBtn.keyPath];

    // 按钮移动动画
    POPSpringAnimation *anim3 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    anim3.fromValue = [NSValue valueWithCGRect:CGRectMake(animView.xl_centerX, animView.xl_centerY, animView.xl_width, animView.xl_height)];
    anim3.toValue = [NSValue valueWithCGRect:CGRectMake(animView.xl_centerX, animView.xl_centerY-95, animView.xl_width, animView.xl_height)];
    anim3.beginTime = CACurrentMediaTime()+0.2;
    anim3.springBounciness = SpringBounciness;
    anim3.springSpeed = SpringSpeed;
    [animView pop_addAnimation:anim3 forKey:nil];

    // 图片移动动画
    POPSpringAnimation *anim4 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    anim4.fromValue = [NSValue valueWithCGRect:CGRectMake(self.loginImage.xl_x, self.loginImage.xl_y, self.loginImage.xl_width, self.loginImage.xl_height)];
    anim4.toValue = [NSValue valueWithCGRect:CGRectMake(self.loginImage.xl_x, self.loginImage.xl_y-75, self.loginImage.xl_width, self.loginImage.xl_height)];
    anim4.beginTime = CACurrentMediaTime()+0.2;
    anim4.springBounciness = SpringBounciness;
    anim4.springSpeed = SpringSpeed;
    [self.loginImage pop_addAnimation:anim4 forKey:nil];

    // 文字移动动画
    POPSpringAnimation *anim5 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    anim5.fromValue = [NSValue valueWithCGRect:CGRectMake(self.loginWord.xl_x, self.loginWord.xl_y, self.loginWord.xl_width, self.loginWord.xl_height)];
    anim5.toValue = [NSValue valueWithCGRect:CGRectMake(self.loginWord.xl_x, self.loginWord.xl_y-75, self.loginWord.xl_width, self.loginWord.xl_height)];
    anim5.beginTime = CACurrentMediaTime()+0.2;
    anim5.springBounciness = SpringBounciness;
    anim5.springSpeed = SpringSpeed;
    [self.loginWord pop_addAnimation:anim5 forKey:nil];

}

- (void)loginButtonClick {

    // 覆盖一层view，用以屏蔽点击事件
    self.hudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [[UIApplication sharedApplication].keyWindow addSubview:self.hudView];
    self.hudView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];

    //执行登录按钮转圈动画的view
    self.loginAnimView = [[UIView alloc] initWithFrame:self.loginButton.frame];
    self.loginAnimView.layer.cornerRadius = 10;
    self.loginAnimView.layer.masksToBounds = YES;
    self.loginAnimView.frame = self.loginButton.frame;
    self.loginAnimView.backgroundColor = self.loginButton.backgroundColor;
    [self.view addSubview:self.loginAnimView];
    self.loginButton.hidden = YES;

    //把view从宽的样子变圆
    CGPoint centerPoint = self.loginAnimView.center;
    CGFloat radius = MIN(self.loginButton.frame.size.width, self.loginButton.frame.size.height);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{

        self.loginAnimView.frame = CGRectMake(0, 0, radius, radius);
        self.loginAnimView.center = centerPoint;
        self.loginAnimView.layer.cornerRadius = radius/2;
        self.loginAnimView.layer.masksToBounds = YES;

    } completion:^(BOOL finished) {

        // 给圆加一条不封闭的白色曲线
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake(radius/2, radius/2) radius:radius/2 - 5 startAngle:0 endAngle:M_PI_2 * 2 clockwise:YES];
        self.shapeLayer = [[CAShapeLayer alloc] init];
        self.shapeLayer.lineWidth = 1.5;
        self.shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        self.shapeLayer.fillColor = self.loginButton.backgroundColor.CGColor;
        self.shapeLayer.frame = CGRectMake(0, 0, radius, radius);
        self.shapeLayer.path = path.CGPath;
        [self.loginAnimView.layer addSublayer:self.shapeLayer];

        // 让圆转起来， 实现加载中的效果
        CABasicAnimation *basicAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        basicAnim.duration = 0.4;
        basicAnim.fromValue = @(0);
        basicAnim.toValue = @(2 * M_PI);
        basicAnim.repeatCount = MAXFLOAT;
        [self.loginAnimView.layer addAnimation:basicAnim forKey:nil];

        //开始登录
        [self doLogin];
    }];
}

#pragma mark - helper
/** 模拟登录 */
- (void)doLogin {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        if ([self.accountTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""]) {
            //失败
            [self loginFail];
        } else {
            [self loginSuccess];
        }

    });
}

/** 登录失败 */
- (void)loginFail {

    //把蒙版、动画view等隐藏，把真正的login按钮显示出来
    self.loginButton.hidden = NO;
    [self.hudView removeFromSuperview];
    [self.loginAnimView removeFromSuperview];
    [self.loginAnimView.layer removeAllAnimations];


    [self.loginButton xl_shake];

}

/** 登录成功 */
- (void)loginSuccess {
    //移除蒙版
    [self.hudView removeFromSuperview];

    [self xl_closeSelfAction];
}

#pragma mark - CAAnimationDelegate 动画代理
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {

    if ([((CABasicAnimation *)anim).keyPath isEqualToString:@"bounds.size.height"]) {
        //阴影颜色
        self.animView.layer.shadowColor = [UIColor redColor].CGColor;
        //阴影的透明度
        self.animView.layer.shadowOpacity = 0.8f;
        //阴影的圆角
        self.animView.layer.shadowRadius = 5.0f;
        //阴影偏移量
        self.animView.layer.shadowOffset = CGSizeMake(1, 1);

        self.accountTextField.alpha = 1.0;
        self.passwordTextField.alpha = 1.0;
    } else if ([((CABasicAnimation *)anim).keyPath isEqualToString:@"bounds.size"]) {
        self.loginButton.bounds = CGRectMake(kScreenWidth * 0.5, kScreenHeight * 0.7 + 44 + (kScreenHeight * 0.3 - 44) * 0.5 - 95, kScreenWidth * 0.5, 44);
    }
}

#pragma mark - lazy
- (UIImageView *)loginImage {
    if (!_loginImage) {
        _loginImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"User"]];
        [self.view addSubview:_loginImage];
    }
    return _loginImage;
}

- (UILabel *)loginWord {
    if (!_loginWord) {
        _loginWord = [[UILabel alloc] init];
        [self.view addSubview:_loginWord];
        _loginWord.font = [UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:34.0f];
        _loginWord.textColor = [UIColor blackColor];
        _loginWord.text = @"OC_APP Login";
        [_loginWord sizeToFit];
        _loginWord.backgroundColor = [UIColor redColor];
    }
    return _loginWord;
}

- (UIButton *)getButton {
    if (!_getButton) {
        _getButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_getButton];
        [_getButton.layer setMasksToBounds:YES];
        [_getButton.layer setCornerRadius:22.0];
        _getButton.backgroundColor = THEME_color;
        [_getButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_getButton setTitle:@"GET" forState:UIControlStateNormal];
        [_getButton addTarget:self action:@selector(getButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getButton;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_loginButton];
        _loginButton.frame = CGRectMake(0, 0, 0, 0);
        _loginButton.hidden = YES;
        [_loginButton.layer setMasksToBounds:YES];
        [_loginButton.layer setCornerRadius:5.0];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton setTitle:@"LOGIN" forState:UIControlStateNormal];
        _loginButton.backgroundColor = THEME_color;
        [_loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UITextField *)accountTextField {
    if (!_accountTextField) {
        _accountTextField = [[UITextField alloc] init];
        _accountTextField.font = [UIFont systemFontOfSize:15];
        _accountTextField.placeholder = @"账号";
        _accountTextField.alpha = 0.0;
        _accountTextField.xl_placeholderColor = [UIColor grayColor];
        _accountTextField.textAlignment = NSTextAlignmentCenter;
        _accountTextField.keyboardType = UIKeyboardTypePhonePad;
        _accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _accountTextField.tintColor = THEME_color;

        UIView *seperatorLine = [[UIView alloc] init];
        [_accountTextField addSubview:seperatorLine];
        seperatorLine.backgroundColor = [UIColor grayColor];
        [seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(_accountTextField);
            make.height.mas_equalTo(1.5);
        }];
        [self.view addSubview:_accountTextField];
        _accountTextField.frame = CGRectMake(kScreenWidth*0.2, kScreenHeight*0.7-(kScreenHeight*0.3-44)*0.5-95+25, kScreenWidth*0.6, 50);
    }
    return _accountTextField;
}

- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] init];
        _passwordTextField.font = [UIFont systemFontOfSize:15];
        _passwordTextField.borderStyle = UITextBorderStyleNone;
        _passwordTextField.placeholder = @"密码";
        _passwordTextField.alpha = 0.0;
        _passwordTextField.xl_placeholderColor = [UIColor grayColor];
        _passwordTextField.textAlignment = NSTextAlignmentCenter;
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.tintColor = THEME_color;

        UIView *seperatorLine = [[UIView alloc] init];
        [_passwordTextField addSubview:seperatorLine];
        seperatorLine.backgroundColor = [UIColor grayColor];
        [seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(_passwordTextField);
            make.height.mas_equalTo(1.5);
        }];
        [self.view addSubview:_passwordTextField];
        _passwordTextField.frame = CGRectMake(kScreenWidth*0.2, kScreenHeight*0.7-(kScreenHeight*0.3-44)*0.5-95+10+50+25, kScreenWidth*0.6, 50);
    }
    return _passwordTextField;
}

@end
