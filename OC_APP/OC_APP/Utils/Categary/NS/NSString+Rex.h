//
//  NSString+Rex.h
//  OC_APP
//
//  Created by xingl on 2017/6/10.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Rex)


//包含大写字母
- (BOOL)xl_containcUppercaseLetter;
//包含小写字母
- (BOOL)xl_containcLowercaseLetter;
//包含字母
- (BOOL)xl_containcLetters;
//包含中文
- (BOOL)xl_containCN;
//包含数字
- (BOOL)xl_isContainNumber;
//是否为数学数据
- (BOOL)xl_isMathsNumber;
//是否为正整数
- (BOOL)xl_isMathsNumberIntegerString;
//是否为全数字字符
- (BOOL)xl_isNumberString;
//全数字字符 限制长度
- (BOOL)xl_isNumberString:(NSUInteger)length;
//email地址格式检查
- (BOOL)xl_isEmailString;
//银行卡号
- (BOOL)xl_isBankCardNumber;
//身份证号
- (BOOL)xl_isIDCardNumber;
//验证中文
- (BOOL)xl_isChineseNameString;
//ip
- (BOOL)xl_isIpString;
//手机号
- (BOOL)xl_isPhoneNumberString;
//mac地址
- (BOOL)xl_isMacAddress;
//url
- (BOOL)xl_isValidUrl;

@end
