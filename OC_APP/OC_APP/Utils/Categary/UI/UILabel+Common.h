//
//  UILabel+Common.h
//  OC_APP
//
//  Created by xingl on 2017/7/6.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Common)

@property (nonatomic, readonly) CGFloat lineHeight;
@property (nonatomic, readonly) NSInteger textNumberOfLines;
@property (nonatomic, readonly) CGFloat textHeight;
@property (nonatomic, readonly) CGFloat textWidth;

- (CGSize)textSizeForLimitedSize:(CGSize)size;

- (NSMutableAttributedString *)attributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace limitWidth:(CGFloat)limitWidth;

@end
