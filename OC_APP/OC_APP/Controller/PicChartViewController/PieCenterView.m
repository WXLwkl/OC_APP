//
//  PicCenterView.m
//  OC_APP
//
//  Created by xingl on 2018/5/25.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "PieCenterView.h"

@interface PieCenterView ()

@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UIView *centerView;

@end

@implementation PieCenterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
        UIView *centerView = [[UIView alloc] init];
        centerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:centerView];
        self.centerView = centerView;
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        nameLabel.font = [UIFont systemFontOfSize:18];
        
        nameLabel.textAlignment = NSTextAlignmentCenter;
        
        self.nameLabel = nameLabel;
        
        
        [centerView addSubview:nameLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.frame.size.width * 0.5;
    self.layer.masksToBounds = true;
    
    self.centerView.frame = CGRectMake(6, 6, self.frame.size.width - 6 * 2, self.frame.size.width - 6 * 2);
    self.centerView.layer.cornerRadius = self.centerView.frame.size.width * 0.5;
    self.centerView.layer.masksToBounds = YES;
    
    self.nameLabel.frame = self.centerView.bounds;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.nameLabel.text = title;
}

@end
