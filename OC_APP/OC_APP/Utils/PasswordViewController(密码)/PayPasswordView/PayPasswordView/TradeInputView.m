//
//  TradeInputView.m
//  OC_APP
//
//  Created by xingl on 2017/12/12.
//  Copyright © 2017年 兴林. All rights reserved.
//

typedef NS_ENUM(NSInteger, TradeInputViewButtonType) {
    TradeInputViewButtonTypeWithCancle = 10000,
    TradeInputViewButtonTypeWithOk = 20000,
};

#define TradeInputViewNumCount 6

#import "TradeInputView.h"
#import "TradeKeyboard.h"

@interface TradeInputView ()
/** 数字数组 */
@property (nonatomic, strong) NSMutableArray *nums;
/** 确定按钮 */
@property (nonatomic, weak) UIButton *okBtn;
/** 取消按钮 */
@property (nonatomic, weak) UIButton *cancleBtn;
@end

@implementation TradeInputView

#pragma mark - LazyLoad
- (NSMutableArray *)nums {
    if (_nums == nil) {
        _nums = [NSMutableArray array];
    }
    return _nums;
}
#pragma mark - LifeCircle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        /** 注册keyboard通知 */
        [self setupKeyboardNote];
        /** 添加子控件 */
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    /** 确定按钮 */
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:okBtn];
    self.okBtn = okBtn;
    [self.okBtn setBackgroundImage:[UIImage imageNamed:@"trade.bundle/password_ok_up"] forState:UIControlStateNormal];
    [self.okBtn setBackgroundImage:[UIImage imageNamed:@"trade.bundle/password_ok_down"] forState:UIControlStateHighlighted];
    [self.okBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.okBtn.tag = TradeInputViewButtonTypeWithOk;

    /** 取消按钮 */
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:cancleBtn];
    self.cancleBtn = cancleBtn;
    [self.cancleBtn setBackgroundImage:[UIImage imageNamed:@"trade.bundle/password_cancel_up"] forState:UIControlStateNormal];
    [self.cancleBtn setBackgroundImage:[UIImage imageNamed:@"trade.bundle/password_cancel_down"] forState:UIControlStateHighlighted];
    [self.cancleBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.cancleBtn.tag = TradeInputViewButtonTypeWithCancle;
}
#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];

    /** 取消按钮 */
    self.cancleBtn.xl_width = kScreenWidth * 0.409375;
    self.cancleBtn.xl_height = kScreenWidth * 0.128125;
    self.cancleBtn.xl_x = kScreenWidth * 0.05;
    self.cancleBtn.xl_y = self.xl_height - (kScreenWidth * 0.05 + self.cancleBtn.xl_height);

    /** 确定按钮 */
    self.okBtn.xl_y = self.cancleBtn.xl_y;
    self.okBtn.xl_width = self.cancleBtn.xl_width;
    self.okBtn.xl_height = self.cancleBtn.xl_height;
    self.okBtn.xl_x = CGRectGetMaxX(self.cancleBtn.frame) + kScreenWidth * 0.025;
}

/** 注册keyboard通知 */
- (void)setupKeyboardNote {
    // 删除通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delete) name:TradeKeyboardDeleteButtonClick object:nil];

    // 确定通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ok) name:TradeKeyboardOkButtonClick object:nil];

    // 数字通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(number:) name:TradeKeyboardNumberButtonClick object:nil];
}
// 删除
- (void)delete
{
    [self.nums removeLastObject];
    [self setNeedsDisplay];
}

// 数字
- (void)number:(NSNotification *)note
{
    if (self.nums.count >= TradeInputViewNumCount) return;
    NSDictionary *userInfo = note.userInfo;
    NSNumber *numObj = userInfo[TradeKeyboardNumberKey];
    [self.nums addObject:numObj];
    [self setNeedsDisplay];
}

// 确定
- (void)ok
{

}

// 按钮点击
- (void)btnClick:(UIButton *)btn
{
    if (btn.tag == TradeInputViewButtonTypeWithCancle) {  // 取消按钮点击
        if ([self.delegate respondsToSelector:@selector(tradeInputView:cancleBtnClick:)]) {
            [self.delegate tradeInputView:self cancleBtnClick:btn];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:TradeInputViewCancleButtonClick object:self];
    } else if (btn.tag == TradeInputViewButtonTypeWithOk) {  // 确定按钮点击
        if ([self.delegate respondsToSelector:@selector(tradeInputView:okBtnClick:)]) {
            [self.delegate tradeInputView:self okBtnClick:btn];
        }
        // 包装通知字典
        NSMutableString *pwd = [NSMutableString string];
        for (int i = 0; i < self.nums.count; i++) {
            NSString *str = [NSString stringWithFormat:@"%@", self.nums[i]];
            [pwd appendString:str];
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[ZCTradeInputViewPwdKey] = pwd;
        [[NSNotificationCenter defaultCenter] postNotificationName:TradeInputViewOkButtonClick object:self userInfo:dict];
    } else {

    }
}

- (void)drawRect:(CGRect)rect {
    // 画图
    UIImage *bg = [UIImage imageNamed:@"trade.bundle/pssword_bg"];
    UIImage *field = [UIImage imageNamed:@"trade.bundle/password_in"];

    [bg drawInRect:rect];

    CGFloat x = kScreenWidth * 0.096875 * 0.5;
    CGFloat y = kScreenWidth * 0.40625 * 0.5;
    CGFloat w = kScreenWidth * 0.846875;
    CGFloat h = kScreenWidth * 0.121875;
    [field drawInRect:CGRectMake(x, y, w, h)];

    // 画字
    NSString *title = @"请输入交易密码";

    CGSize size = [self sizeWithTitle:title font:[UIFont systemFontOfSize:kScreenWidth * 0.053125] andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat titleW = size.width;
    CGFloat titleH = size.height;
    CGFloat titleX = (self.xl_width - titleW) * 0.5;
    CGFloat titleY = kScreenWidth * 0.03125;
    CGRect titleRect = CGRectMake(titleX, titleY, titleW, titleH);

    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:kScreenWidth * 0.053125];
    attr[NSForegroundColorAttributeName] = RGBColor(102, 102, 102);

    [title drawInRect:titleRect withAttributes:attr];

    // 画点
    UIImage *pointImage = [UIImage imageNamed:@"trade.bundle/yuan"];
    CGFloat pointW = kScreenWidth * 0.05;
    CGFloat pointH = pointW;
    CGFloat pointY = kScreenWidth * 0.24;
    CGFloat pointX;
    CGFloat margin = kScreenWidth * 0.0484375;
    CGFloat padding = kScreenWidth * 0.045578125;
    for (int i = 0; i < self.nums.count; i++) {
        pointX = margin + padding + i * (pointW + 2 * padding);
        [pointImage drawInRect:CGRectMake(pointX, pointY, pointW, pointH)];
    }

    // ok按钮状态
    BOOL statue = NO;
    if (self.nums.count == TradeInputViewNumCount) {
        statue = YES;
    } else {
        statue = NO;
    }
    self.okBtn.enabled = statue;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (CGSize)sizeWithTitle:(NSString *)title font:(UIFont *)font andMaxSize:(CGSize)maxSize {
    NSDictionary *arrts = @{NSFontAttributeName:font};

    return [title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:arrts context:nil].size;
}
@end
