//
//  TitleItem.m
//  OC_APP
//
//  Created by xingl on 2017/12/26.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "TitleItem.h"

@implementation TitleItem

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code

    [super drawRect:rect];
    if (_progress > 0 && _progress <= 1) {
        [self setTitleColor:[UIColor colorWithRed:_progress green:0 blue:0 alpha:1] forState:UIControlStateNormal];
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1 + 0.1 * _progress, 1 + 0.1 * _progress);
    }
}
@end
