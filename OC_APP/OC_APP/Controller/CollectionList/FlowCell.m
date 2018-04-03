//
//  FlowCell.m
//  OC_APP
//
//  Created by xingl on 2018/2/22.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "FlowCell.h"

@interface FlowCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation FlowCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.85 alpha:0.9];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.50];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    self.imageView.image = [UIImage imageNamed:imageName];
}

@end
