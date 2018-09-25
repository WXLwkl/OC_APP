//
//  BannerImageView.m
//  OC_APP
//
//  Created by xingl on 2018/9/7.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "BannerImageView.h"

@implementation BannerImageView
@synthesize imageView = _imageView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.frame = self.bounds;
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.imageView];
    }
    return self;
}
- (UIImageView *)imageView {
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _imageView;
}

@end
