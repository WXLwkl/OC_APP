//
//  SliderView.m
//  OC_APP
//
//  Created by xingl on 2017/12/26.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "SliderView.h"

@implementation SliderView

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
        CGRect frame = self.frame;
        frame.size.width = 15 + _itemWidth * (_progress > 0.5 ? 1 - _progress : _progress);
        frame.origin.x = frame.origin.x + _itemWidth * _progress;
        self.frame = frame;
    }
}
@end
