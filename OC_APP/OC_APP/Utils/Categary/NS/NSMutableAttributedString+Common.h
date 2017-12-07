//
//  NSMutableAttributedString+Common.h
//  OC_APP
//
//  Created by xingl on 2017/11/24.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (Common)


/**
 设置颜色

 @param color 颜色
 @param range 区间
 */
- (void)xl_setColor:(UIColor *)color range:(NSRange)range;

/**
 设置字体

 @param font 字体
 @param range 区间
 */
- (void)xl_setFont:(UIFont *)font range:(NSRange)range;

/**
 设置背景颜色

 @param backgroundColor 背景颜色
 @param range 区域
 */
- (void)xl_setBackgroundColor:(UIColor *)backgroundColor range:(NSRange)range;

/**
 设置链接 (注意：UILabel无法使用该属性, 但UITextView 控件可以使用)
 // 注意：跳转链接要实现UITextView的这个委托方法
 - (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)url inRange:(NSRange)characterRange {
 return YES;
 }
 @param link 链接
 @param range 区域
 */
- (void)xl_setLink:(id)link range:(NSRange)range;

/**
 设置字符间距：默认0（禁用）
 
 @param kern 间距
 @param range 区域
 */
- (void)xl_setKern:(NSNumber *)kern range:(NSRange)range;

/**
 设置文本阴影
 
 @param shadow 阴影
 @param range 区域
 */
- (void)xl_setShadow:(NSShadow *)shadow range:(NSRange)range;


/**
 设置描边宽度：正值空心描边，负值实心描边，默认0(不描边)

 @param strokeWidth 宽度
 @param strokeColor 颜色
 @param range 区域
 */
- (void)xl_setStrokeWidth:(NSNumber *)strokeWidth StrokeColor:(UIColor *)strokeColor range:(NSRange)range;

/**
 设置中划线

 @param strikethroughStyle 中划线类型
 @param strikethroughColor 线颜色
 @param range 区域
 */
- (void)xl_setStrikethroughStyle:(NSUnderlineStyle)strikethroughStyle color:(UIColor *)strikethroughColor range:(NSRange)range;


/**
 设置下划线

 @param underlineStyle 划线类型
 @param underlineColor 划线颜色
 @param range 区域
 */
- (void)xl_setUnderlineStyle:(NSUnderlineStyle)underlineStyle color:(UIColor *)underlineColor range:(NSRange)range;


/**
 文本扁平化：正值横向拉伸，负值横向压缩，默认0（不拉伸）

 @param expansion 包含浮点数的NSNumber对象
 @param range 区域
 */
- (void)xl_setExpansion:(NSNumber *)expansion range:(NSRange)range;


/**
 设置字体倾斜 ：正值向右倾斜，负值向左倾斜， 默认0（不倾斜）

 @param obliqueness 倾斜量
 @param range 区域
 */
- (void)xl_setObliqueness:(NSNumber *)obliqueness range:(NSRange)range;

/**
 设置基础偏移量：正值向上偏移，负值向下偏移，默认0（不偏移）

 @param baselineOffset 偏移量
 @param range 区域
 */
- (void)xl_setBaselineOffset:(NSNumber *)baselineOffset range:(NSRange)range;

/**
 附件(常用作图文混排) ：默认nil(没有附件)
 
 @param attachment 附件
 @param range 区域
 */
- (void)xl_setAttachment:(NSTextAttachment *)attachment range:(NSRange)range;


/**
 添加属性

 @param name 属性名
 @param value 属性值
 @param range 区域
 */
- (void)xl_setAttribute:(NSString *)name value:(id)value range:(NSRange)range;

/**
 移除所有属性

 @param range 区间
 */
- (void)xl_removeAttributesInRange:(NSRange)range;

@end
