//
//  LineProgressView.h
//  OC_APP
//
//  Created by xingl on 2018/1/29.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineProgressView : UIView

@property (nonatomic, strong) UIColor *progressTintColor;
@property (nonatomic, strong) UIColor *borderTintColor;
@property (nonatomic, strong) UIColor *trackTintColor;
@property (nonatomic) CGFloat progress;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
