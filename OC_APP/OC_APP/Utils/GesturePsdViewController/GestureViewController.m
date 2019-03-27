//
//  GestureViewController.m
//  shoushi
//
//  Created by xingl on 2017/7/17.
//  Copyright © 2017年 xingl. All rights reserved.
//

#import "GestureViewController.h"

#import "GestureView.h"
#import "GestureItem.h"
#import "GesturePreviewView.h"


#import "SecureManager.h"

NSString * const promptDefaultMessage =          @"绘制解锁图案";
NSString * const promptSetAgainMessage =         @"再次绘制解锁图案";
NSString * const promptSetAgainErrorMessage =    @"前后设置不一致";
NSString * const promptChangeGestureMessage =    @"请输入原手势密码";
NSString * const promptPointShortMessage =       @"连接至少4个点，请重新设置";
NSString * const promptPasswordErrorMessage =    @"手势密码错误";

#define MarginTop   25.0
#define Margin      8.0
#define ShapeWH     40.0
#define BottomHeight  44.0

#define ImageWH    80

@interface GestureViewController ()

//手势预览图
@property (nonatomic, strong) GesturePreviewView *shapeView;
//九宫格
@property (nonatomic, strong) GestureView *gestureView;
//提示Label
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, copy) NSString *firstGestureCode;

@property (nonatomic, copy) GestureSetBlock block;
@end

@implementation GestureViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _gestureSetType = GestureSetTypeChange;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupNav];
    [self setupSubViews];

    
}
- (void)setupNav {
  
    self.title = @"设置手势密码";
    if (self.gestureSetType != GestureSetTypeSetting) {
        self.title = @"验证手势密码";
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self setupNavRightItem];
}
- (void)setupNavRightItem {
    if (self.gestureSetType != GestureSetTypeSetting) {
        return;
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重设" style:UIBarButtonItemStylePlain target:self action:@selector(resetGesture)];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
}
// 重设手势
- (void)resetGesture {
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    self.shapeView.gestureCode = nil;
    self.firstGestureCode = nil;
    self.messageLabel.text = promptDefaultMessage;
    self.messageLabel.textColor = [UIColor blackColor];
    
}
- (void)setupSubViews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self.view addSubview:self.shapeView];
    [self.view addSubview:self.messageLabel];
    
    if (self.gestureSetType != GestureSetTypeSetting) {
        if ([self.shapeView superview]) {
            [self.shapeView removeFromSuperview];
        }
        self.messageLabel.xl_y = MarginTop + Margin;
        self.messageLabel.text = promptChangeGestureMessage;
    }
    [self setupGestureView];
}
- (void)setupGestureView {
    [self.view addSubview:self.gestureView];
    //是否显示指示手势划过的方向箭头, 在初始设置手势密码的时候才显示, 其他的不用显示
    self.gestureView.showArrowDirection = self.gestureSetType == GestureSetTypeSetting ? YES : NO;
    
    if (self.gestureSetType == GestureSetTypeVerify) {
        
        self.gestureView.hideGesturePath = ![SecureManager gestureShowStatus];
    }
    
    WeakSelf(self);
    [self.gestureView setGestureResult:^BOOL(NSString *gestureCode){
        StrongSelf(self);
        return [self gestureResult:gestureCode];
    }];
}


// 验证手势密码成功后，修改手势密码用到
- (void)resetTopViews {
    
    if (self.gestureSetType != GestureSetTypeChange) {
        return;
    }
    
    self.gestureSetType = GestureSetTypeSetting;
    
    if (![self.shapeView superview]) {
        [self.view addSubview:self.shapeView];
    }

    self.messageLabel.xl_y = MarginTop + ShapeWH + Margin;
    self.messageLabel.text = promptDefaultMessage;
    self.messageLabel.textColor = [UIColor blackColor];
}

// 手势密码结果的处理
- (BOOL)gestureResult:(NSString *)gestureCode {
    
    if (self.gestureSetType == GestureSetTypeSetting) {
        // 首次设置手势密码
        
        if (gestureCode.length >= 4) {
            if (!self.firstGestureCode) {
                self.shapeView.gestureCode = gestureCode;
                self.firstGestureCode = gestureCode;
                self.messageLabel.text = promptSetAgainMessage;
                //导航栏上的重置按钮
                [self.navigationItem.rightBarButtonItem setEnabled:YES];
                
                return YES;
            } else if ([self.firstGestureCode isEqualToString:gestureCode]) {
                // 第二次绘制成功，返回上一页
                [SecureManager saveGestureCodeKey:gestureCode];
                if (self.block) {
                    self.block(YES);
                }
                [self popViewController];
                return YES;
            }
        }
        // 点数少于4 或者 前后不一致
        if (gestureCode.length < 4 || self.firstGestureCode != nil) {
            // 点数少于4 或者 前后不一致
            self.messageLabel.text = gestureCode.length < 4 ? promptPointShortMessage : promptSetAgainErrorMessage;
            self.messageLabel.textColor = CircleErrorColor;
            [self.messageLabel xl_shake];
            return NO;
        }
        
    } else if (self.gestureSetType == GestureSetTypeVerify) {
        // 关闭手势密码
        if ([self verifyGestureCodeWitCode:gestureCode]) {
            //密码验证成功，回调关闭你手势密码
//            [SCSecureHelper saveGestureCodeKey:nil];
            if (self.block) {
                self.block(YES);
            }
            [self popViewController];
            
            return YES;
        }
        return NO;
        
    } else if (self.gestureSetType == GestureSetTypeChange) {
        // 修改手势密码，修改前先验证原密码
        if ([self verifyGestureCodeWitCode:gestureCode]) {
            [self resetTopViews];
            return YES;
        }
        return NO;
    }
    
    return NO;
}

// 验证原密码
- (BOOL)verifyGestureCodeWitCode:(NSString *)gestureCode {
    
    
    //允许错误的次数
    static NSInteger errorCount = 5;
    
    NSString * saveGestureCode = [SecureManager gainGestureCodeKey];
    if ([gestureCode isEqualToString:saveGestureCode]) {
        self.title = @"设置手势密码";
        errorCount = 5;
        return YES;
    } else {
        
        if (errorCount - 1 == 0) {//你已经输错五次了！ 退出登陆！
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"手势密码已失效" message:@"请重新登陆" delegate:self cancelButtonTitle:nil otherButtonTitles:@"重新登陆", nil];
            [alertView show];
            errorCount = 5;
            return NO;
        }
//        self.messageLabel.text =  promptPasswordErrorMessage;
        self.messageLabel.text = [NSString stringWithFormat:@"密码错误，还可以再输入%ld次", (long)--errorCount];
        self.messageLabel.textColor = CircleErrorColor;
        [self.messageLabel xl_shake];
        
        
        
        return NO;
    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [SecureManager openGesture:NO];
    
    if (self.block) {
        self.block(NO);
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - lazy
- (GesturePreviewView *)shapeView {
    
    if (!_shapeView) {
        CGFloat shapeX = (kScreenWidth - ShapeWH) * 0.5;
        _shapeView = [[GesturePreviewView alloc] initWithFrame:CGRectMake(shapeX, MarginTop, ShapeWH, ShapeWH)];
        _shapeView.backgroundColor = [UIColor clearColor];
    }
    return _shapeView;
}
- (UILabel *)messageLabel {
    if (!_messageLabel) {
        CGFloat labelY = MarginTop + ShapeWH + Margin;
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, labelY, kScreenWidth, LabelHeight)];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:16.0];
        _messageLabel.text = promptDefaultMessage;
    }
    return _messageLabel;
}

- (GestureView *)gestureView {
    if (!_gestureView) {
        CGFloat gestureViewX = (kScreenWidth - GestureWH) * 0.5;
        CGFloat gestureViewY = MarginTop * 2.0 + Margin + ShapeWH + LabelHeight;
        _gestureView = [[GestureView  alloc] initWithFrame:CGRectMake(gestureViewX, gestureViewY, GestureWH, GestureWH)];
    }
    return _gestureView;
}


#pragma mark - 对外的方法
- (void)gestureSetComplete:(GestureSetBlock)block {
    self.block = block;
}

#pragma mark - action事件
- (void)back {
    // 点击返回设置失败
    if (self.block) {
        self.block(NO);
    }
    [self popViewController];
}
- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    NSLog(@"%@===dealloc",NSStringFromClass([self class]));
}
@end
