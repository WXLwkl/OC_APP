//
//  SubCell.m
//  OC_APP
//
//  Created by xingl on 2018/5/15.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "SubCell.h"

@interface SubCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation SubCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.85 alpha:0.9];
        
        _label = [[UILabel alloc] init];
        _label.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.50];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.numberOfLines = 0;
        _label.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_label];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = self.bounds;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.label.text = title;
}


@end
