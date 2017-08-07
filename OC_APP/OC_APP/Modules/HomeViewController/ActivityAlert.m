//
//  ActivityAlert.m
//  OC_APP
//
//  Created by xingl on 2017/8/1.
//  Copyright © 2017年 兴林. All rights reserved.
//
typedef void(^FinishBlock)();

#import "ActivityAlert.h"

@interface ActivityAlert ()

@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIView *contentView;

@property (nonatomic, copy) FinishBlock finishBlock;
@end

@implementation ActivityAlert

+ (instancetype)showWithView:(UIView *)view trueAction:(void(^)())block {
    ActivityAlert *alert = [[ActivityAlert alloc]initWithView:view];
    [view addSubview:alert];
    alert.finishBlock = block;
    return alert;
}

- (instancetype)init {
    self = [super init];
    UIWindow *tempKeyboardWindow;
    if([[[UIApplication sharedApplication] windows] count] > 1) {
        tempKeyboardWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    }
    else {
        tempKeyboardWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    }
    return [self initWithView:tempKeyboardWindow];
}

- (instancetype)initWithView:(UIView *)view{
    
    return [self initWithFrame:view.bounds];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI {
    
    float scaleW = self.bounds.size.width/320;
    
    _bgView = [[UIView alloc]initWithFrame:self.bounds];
    _bgView.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
    _bgView.userInteractionEnabled = YES;
    [self addSubview:_bgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenBg)];
    [_bgView addGestureRecognizer:tap];
    
    
    _contentView = [[UIView alloc]init];
    _contentView.layer.cornerRadius = 10;
    _contentView.frame = CGRectMake(0, 0, 240*scaleW, 240*scaleW);
    _contentView.center = _bgView.center;
    _contentView.userInteractionEnabled = YES;
    [_bgView addSubview:_contentView];
    
    
    [self showAnimationAlert:_contentView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenBg1)];
    [_contentView addGestureRecognizer:tap1];
    
    //-------------中间部位
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:_contentView.bounds];
    imgV.image = [UIImage imageNamed:@"activity"];
    imgV.contentMode = UIViewContentModeScaleAspectFit;
    [_contentView addSubview:imgV];
   
}

-(void)hiddenBg {
    
    [self hideAnimationAlert:_contentView hideCompleteBlock:^{
        [self removeFromSuperview];
    }];
}
- (void)hiddenBg1 {
    
    if (self.finishBlock) {
        self.finishBlock();
    }
    [self removeFromSuperview];

}

//显示
-(void)showAnimationAlert:(UIView *)view {
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animation];
    bounceAnimation.duration = 0.3;
    bounceAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.7],
                              [NSNumber numberWithFloat:1.15],
                              [NSNumber numberWithFloat:0.9],
                              [NSNumber numberWithFloat:1.0],
                              nil];
    
    [view.layer addAnimation:bounceAnimation forKey:@"transform.scale"];
    [UIView animateWithDuration:0.15 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }];
}

- (void)hideAnimationAlert:(UIView *)view hideCompleteBlock:(void(^)())hideCompleteBlock {
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animation];
    bounceAnimation.duration = 0.15;
    bounceAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:1.05],
                              [NSNumber numberWithFloat:0.5],
                              nil];
    
    [view.layer addAnimation:bounceAnimation forKey:@"transform.scale"];
    
    [UIView animateWithDuration:0.13
                     animations:^{
                         
                         self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
                     }
                     completion:^(BOOL finished) {
                         
                         hideCompleteBlock();
                     }];
}
@end
