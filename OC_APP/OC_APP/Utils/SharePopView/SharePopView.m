//
//  SharePopView.m
//  OC_APP
//
//  Created by xingl on 2017/8/4.
//  Copyright © 2017年 兴林. All rights reserved.
//


#import "SharePopView.h"
#import "CLView.h"
#import "ShareItem.h"

@interface SharePopView ()

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic) CGFloat contentH;


@end

@implementation SharePopView

- (id)initWithTitleArray:(NSArray *)titlearray  picarray:(NSArray *)picarray; {
    self = [super init];
    if (self) {
        
        self.contentH = 90 * ((picarray.count - 1) / 4 + 1) + 40;
        
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        self.contentView = [[UIView alloc]init];
        [_contentView  setFrame:CGRectMake(0, kScreenHeight ,kScreenWidth,self.contentH)];
        [_contentView setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
        [self addSubview:_contentView];
        
        _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.contentH - 40, kScreenWidth, 40)];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelBtn setBackgroundColor:[UIColor whiteColor]];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_cancelBtn];
        
        for (int i = 0; i < picarray.count; i ++) {
            ShareItem *item = [[ShareItem alloc] init];
            item.frame = CGRectMake(i %4 *(kScreenWidth / 4), (i/4) *90 + 20, kScreenWidth/4, 80);
            item.tag = 10 + i;
            [item setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",picarray[i]]] forState:UIControlStateNormal];
            
            [item setTitle:[NSString stringWithFormat:@"%@",titlearray[i]] forState:UIControlStateNormal];

            [item addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.contentView addSubview:item];
               
        }
    }
    return self;
}

- (void)cancelClick:(UIButton *)sender {

    [self dismiss];
}
- (void)selectedAction:(UIButton *)sender {
    
    self.block(sender.tag - 10);
    [self dismiss];
}

- (void)show {
    
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        _contentView.transform = CGAffineTransformMakeTranslation(0,  - self.contentH);
        
    } completion:^(BOOL finished) {
        
        for (UIView *item in self.contentView.subviews) {
            
            if ([item isMemberOfClass:[ShareItem class]]) {
                
                NSLog(@"sssssxxx");
                
                int i = item.tag - 10;
                
                CGPoint location = CGPointMake(kScreenWidth/4* (i%4) + (kScreenWidth/8), i/4 *90 + 45);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i*0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
                            item.center = location; //CGPointMake(160, 284);
                    } completion:nil];
                    
                });
            }
        }
        
    }];
}
- (void)dismiss {
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        _contentView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

- (void)selectedItem:(SelectedBlock)block {
    
    self.block = block;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}
- (void)dealloc {
    NSLog(@"dealloc -----");
}

@end
