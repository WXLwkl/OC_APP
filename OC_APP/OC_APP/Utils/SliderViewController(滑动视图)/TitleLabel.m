//
//  TitleLabel.m
//  OC_APP
//
//  Created by xingl on 2018/5/25.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "TitleLabel.h"

@implementation TitleLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [_fillColor set];
    rect.size.width = rect.size.width * _progress;
    UIRectFillUsingBlendMode(rect, kCGBlendModeSourceIn);
}

@end
