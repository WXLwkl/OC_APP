//
//  MarqueeCell.m
//  OC_APP
//
//  Created by xingl on 2018/2/23.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "MarqueeCell.h"

@interface MarqueeCell()

@property (nonatomic, weak) UILabel * titleLabe;

@end

@implementation MarqueeCell

-(instancetype)init
{
    if (self = [super init]) {
        [self setUpSubViews];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews {
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabe = titleLabel;
    [self addSubview:titleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    self.titleLabe.frame = CGRectMake(8, 0, w - 16, h);
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabe.text = title;
}

@end
