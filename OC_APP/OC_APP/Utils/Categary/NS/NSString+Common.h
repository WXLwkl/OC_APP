//
//  NSString+Common.h
//  OC_APP
//
//  Created by xingl on 2017/6/10.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Common)

/**
 表情字符串
 
 @return 表情字符串
 */
- (NSString *)xl_emoji;


/** 电话号码中间4位****显示 */
+ (NSString *)xl_getSecrectStringWithPhoneNumber:(NSString *)phoneNum;

/** 银行卡号中间8位 **** **** 显示 */
+ (NSString *)xl_getSecrectStringWithAccountNo:(NSString *)accountNo;

/**
 获取汉字的拼音

 @param chinese 汉字
 @return 拼音
 */
+ (NSString *)xl_transform:(NSString *)chinese;

/**
 阿拉伯数字转成中文
 
 @param arebic 阿拉伯数字
 @return 返回的中文数字
 */
+ (NSString *)xl_translation:(NSString *)arebic;

/**
 格式化金额,三位一逗号

 @param str 金额的字符串
 @param numberStyle 数字格式的枚举
 @return 格式化的字符串
 */
+ (NSString *)xl_stringChangeMoneyWithStr:(NSString *)str numberStyle:(NSNumberFormatterStyle)numberStyle;

/**
 格式化金额,三位一逗号 ,###.##

 @param number 金额
 @return 格式化的字符串
 */
+ (NSString *)xl_stringChangeMoneyWithDouble:(double)number;



/** 清除html标签 */
- (NSString *)xl_stringByStrippingHTML;

/** 清除js脚本 */
- (NSString *)xl_stringByRemovingScriptsAndStrippingHTML;

/** 去除空格 */
- (NSString *)xl_trimmingWhitespace;

/** 去除空格与空行 */
- (NSString *)xl_trimmingWhitespaceAndNewlines;

/** md5编码 */
- (NSString *)xl_md5;
- (NSString *)xl_MD5;

/** base64编码 */
- (NSString *)xl_base64EncodedString;
- (NSString *)xl_base64DecodedString;

//base64转image
- (UIImage *)xl_base64DecodedImage;

#pragma mark - NSMutableAttributedString
/**
 设置字体背景颜色
 
 @param color 背景颜色值
 @param range 区间(NSMakeRange(从0开始的数,从1开始数))
 @return NSMutableAttributedString
 */
- (NSMutableAttributedString *)xl_setStringBackgroundColor:(UIColor *)color range:(NSRange)range;

/**
 设置字体类型

 @param font 字体
 @param range 区间
 @return NSMutableAttributedString
 */
- (NSMutableAttributedString *)xl_setStringFont:(UIFont *)font range:(NSRange)range;

/**
 设置字体颜色

 @param color 颜色
 @param range 区间
 @return NSMutableAttributedString
 */
- (NSMutableAttributedString *)xl_setStringColor:(UIColor *)color range:(NSRange)range;

/**
 设置字体空心

 @param color 字体空心颜色
 @param width 字体空心间距
 @param range 区间
 @return NSMutableAttributedString
 */
- (NSMutableAttributedString *)xl_setStringStrokeColor:(UIColor *)color width:(CGFloat)width range:(NSRange)range;

/**
 设置字体间距

 @param space 间距
 @param range 区间
 @return NSMutableAttributedString
 */
- (NSMutableAttributedString *)xl_setStringSpace:(CGFloat)space range:(NSRange)range;

/**
 设置字体倾斜

 @param gradient 倾斜度
 @param range 区间
 @return NSMutableAttributedString
 */
- (NSMutableAttributedString *)xl_setStringGradient:(CGFloat)gradient range:(NSRange)range;

/**
 设置字体拉伸压缩

 @param expansion 拉伸/压缩值(正：横向拉伸，负：横向压缩)
 @param range 区间
 @return NSMutableAttributedString
 */
- (NSMutableAttributedString *)xl_setStringExpansion:(CGFloat)expansion range:(NSRange)range;

/**
 设置字体的基线偏移

 @param offset 偏移值(正：上，负：下)
 @param range 区间
 @return NSMutableAttributedString
 */
- (NSMutableAttributedString *)xl_setstringBaselineOffset:(CGFloat)offset range:(NSRange)range;

/**
 设置字体阴影

 @param offset 阴影偏移量
 @param radius 模糊半径
 @param color 阴影颜色
 @param range 区间
 */
- (NSMutableAttributedString *)xl_setStringShadowOffset:(CGSize)offset shadowRadius:(CGFloat)radius color:(UIColor *)color range:(NSRange)range;

/**
 设置字体下划线

 @param style 下划线类型
 @param color 下划线颜色
 */
- (NSMutableAttributedString *)xl_setStringUnderLine:(NSUnderlineStyle)style color:(UIColor *)color range:(NSRange)range;

/**
 设置字体删除线

 @param style 删除线类型
 @param color 删除线颜色
 */
- (NSMutableAttributedString *)xl_setStringDeleteLine:(NSUnderlineStyle)style color:(UIColor *)color range:(NSRange)range;

/**
 在字体中加图片
 
 @param imageName 需要加的图片的名字
 @param bounds 图片位置大小
 @param index 图片加载的位置
 @return NSMutableAttributedString
 */
- (NSMutableAttributedString *)xl_setStringWithImage:(NSString *)imageName bounds:(CGRect)bounds index:(NSInteger)index;

@end


#ifdef __cplusplus
extern "C" {
#endif
    NSString *XL_FilterString(id obj);
    BOOL XL_IsEmptyString(NSObject *obj);
#ifdef __cplusplus
}
#endif
