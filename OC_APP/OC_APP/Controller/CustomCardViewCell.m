//
//  CustomCardViewCell.m
//  OC_APP
//
//  Created by xingl on 2018/4/12.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "CustomCardViewCell.h"

@implementation CustomCardViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [[[NSBundle mainBundle] loadNibNamed:@"CustomCardViewCell" owner:nil options:nil] firstObject];
    [self setValue:reuseIdentifier forKey:@"reuseIdentifier"];
    [self initView];
    
    return self;
}

@end
