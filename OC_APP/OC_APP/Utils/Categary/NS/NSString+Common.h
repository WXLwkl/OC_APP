//
//  NSString+Common.h
//  OC_APP
//
//  Created by xingl on 2017/6/10.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Common)



NSString *XL_FilterString(id obj);
BOOL XL_IsEmptyString(NSObject *obj);



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
@end
