//
//  CLView.m
//  弹出视图
//
//  Created by 李 红宝 on 16/1/16.
//  Copyright © 2016年 陈林. All rights reserved.
//

#import "CLView.h"

@implementation CLView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.sheetBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        self.sheetBtn.clipsToBounds = YES;
        self.sheetBtn.layer.cornerRadius = 25;
        [self.sheetBtn setCenter:CGPointMake(self.frame.size.width / 2, 30)];
        
        self.sheetLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, self.frame.size.width, 20)];
        [self addSubview:self.sheetLab];
        [self.sheetBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.sheetLab setTextAlignment:NSTextAlignmentCenter];
        self.sheetLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.sheetBtn];
        
    }
    return self;
}


- (void)btnClick:(UIButton *)btn
{
    self.block(self.sheetBtn.tag);
}

- (void)selectedIndex:(RRBlock)block
{
    self.block = block;
}




@end
