//
//  LinkageViewController.m
//  OC_APP
//
//  Created by xingl on 2017/12/8.
//  Copyright © 2017年 兴林. All rights reserved.
//
#import "CollectionViewHeaderView.h"

@implementation CollectionViewHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = RGBAColor(240, 240, 240, 0.8);
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, kScreenWidth - 80, 20)];
        self.title.font = [UIFont systemFontOfSize:14];
        self.title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.title];
    }
    return self;
}

@end
