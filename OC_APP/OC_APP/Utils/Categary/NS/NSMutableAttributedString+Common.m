//
//  NSMutableAttributedString+Common.m
//  OC_APP
//
//  Created by xingl on 2017/11/24.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "NSMutableAttributedString+Common.h"
#import <CoreText/CoreText.h>

@implementation NSMutableAttributedString (Common)

//文本颜色
- (void)xl_setColor:(UIColor *)color range:(NSRange)range {
    [self xl_setAttribute:(id)kCTForegroundColorAttributeName value:(id)color.CGColor range:range];
    [self xl_setAttribute:NSForegroundColorAttributeName value:color range:range];
}
//文本字体
- (void)xl_setFont:(UIFont *)font range:(NSRange)range {
    
    [self xl_setAttribute:NSFontAttributeName value:font range:range];
}
//文本背景颜色
- (void)xl_setBackgroundColor:(UIColor *)backgroundColor range:(NSRange)range {
    [self xl_setAttribute:NSBackgroundColorAttributeName value:backgroundColor range:range];
}
//文本空心描边
- (void)xl_setStrokeWidth:(NSNumber *)strokeWidth StrokeColor:(UIColor *)strokeColor range:(NSRange)range {
    [self xl_setAttribute:NSStrokeWidthAttributeName value:strokeWidth range:range];
    
    [self xl_setAttribute:(id)kCTStrokeColorAttributeName value:(id)strokeColor.CGColor range:range];
    [self xl_setAttribute:NSStrokeColorAttributeName value:strokeColor range:range];
}
//文本阴影
- (void)xl_setShadow:(NSShadow *)shadow range:(NSRange)range {
    [self xl_setAttribute:NSShadowAttributeName value:shadow range:range];
}
//文本点击链接
- (void)xl_setLink:(id)link range:(NSRange)range {
    
    [self xl_setAttribute:NSLinkAttributeName value:link range:range];
}
//文本中划线
- (void)xl_setStrikethroughStyle:(NSUnderlineStyle)strikethroughStyle color:(UIColor *)strikethroughColor range:(NSRange)range {
    NSNumber *style = strikethroughStyle == 0 ? nil : @(strikethroughStyle);
    [self xl_setAttribute:NSStrikethroughStyleAttributeName value:style range:range];
    [self xl_setAttribute:NSStrikethroughColorAttributeName value:strikethroughColor range:range];
}
//文本下划线
- (void)xl_setUnderlineStyle:(NSUnderlineStyle)underlineStyle color:(UIColor *)underlineColor range:(NSRange)range {
    NSNumber *style = underlineStyle == 0 ? nil : @(underlineStyle);
    [self xl_setAttribute:NSUnderlineStyleAttributeName value:style range:range];
    
    [self xl_setAttribute:(id)kCTUnderlineColorAttributeName value:(id)underlineColor.CGColor range:range];
    [self xl_setAttribute:NSUnderlineColorAttributeName value:underlineColor range:range];
}
//文本扁平化
- (void)xl_setExpansion:(NSNumber *)expansion range:(NSRange)range {
    [self xl_setAttribute:NSExpansionAttributeName value:expansion range:range];
}
//文本倾斜
- (void)xl_setObliqueness:(NSNumber *)obliqueness range:(NSRange)range {
    [self xl_setAttribute:NSObliquenessAttributeName value:obliqueness range:range];
}
//基础偏移量
- (void)xl_setBaselineOffset:(NSNumber *)baselineOffset range:(NSRange)range {
    [self xl_setAttribute:NSBaselineOffsetAttributeName value:baselineOffset range:range];
}
//文字间距
- (void)xl_setKern:(NSNumber *)kern range:(NSRange)range {
    [self xl_setAttribute:NSKernAttributeName value:kern range:range];
}
//富文本
- (void)xl_setAttachment:(NSTextAttachment *)attachment range:(NSRange)range {
    [self xl_setAttribute:NSAttachmentAttributeName value:attachment range:range];
}

- (void)xl_setAttribute:(NSString *)name value:(id)value range:(NSRange)range {
    if (!name || [NSNull isEqual:name]) return;
    
    if (value && ![NSNull isEqual:value])
        [self addAttribute:name value:value range:range];
    else
        [self removeAttribute:name range:range];
}

- (void)xl_removeAttributesInRange:(NSRange)range {
    [self setAttributes:nil range:range];
}

@end
