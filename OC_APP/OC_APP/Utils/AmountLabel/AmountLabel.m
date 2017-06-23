//
//  AmountLabel.m
//  AmountLabel
//
//  Created by xingl on 2017/6/20.
//  Copyright © 2017年 yjpal. All rights reserved.
//

#import "AmountLabel.h"

@interface AmountLabel () {
    NSTimer *_timer;
    NSInteger old;
}
@end

@implementation AmountLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadView];
        _amount = 0.00;
    }
    return self;
}

- (void)loadView {
    // Drawing code
    self.textAlignment = NSTextAlignmentCenter;
    self.layer.borderWidth = 2;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.textColor = [UIColor redColor];
    self.text = @"0.00";

    _timer = [NSTimer scheduledTimerWithTimeInterval:1/100.0 target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
    _timer.fireDate = [NSDate distantFuture];//定时器暂停
}
- (void)updateLabel {
    
    if (old < _amount) {
        old++;
        NSLog(@"++");
    } else if (old > _amount){
        old--;
        NSLog(@"--");
    } else {
        _timer.fireDate = [NSDate distantFuture];
    }
    NSString *text = [NSString stringWithFormat:@"%.2f",old/100.0];
    
    self.text = text;
}

- (void)setAmount:(NSInteger)amount {
    

    _amount = amount;
    _timer.fireDate = [NSDate distantPast];
}


@end
