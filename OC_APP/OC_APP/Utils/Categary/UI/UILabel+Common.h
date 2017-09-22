//
//  UILabel+Common.h
//  OC_APP
//
//  Created by xingl on 2017/7/6.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Common)

@property (nonatomic, readonly) CGFloat   xl_lineHeight;
@property (nonatomic, readonly) NSInteger xl_textNumberOfLines;
@property (nonatomic, readonly) CGFloat   xl_textHeight;
@property (nonatomic, readonly) CGFloat   xl_textWidth;

- (CGSize)xl_textSizeForLimitedSize:(CGSize)size;

- (NSMutableAttributedString *)xl_attributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace limitWidth:(CGFloat)limitWidth;

@end
