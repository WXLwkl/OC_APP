//
//  NSString+Rex.m
//  OC_APP
//
//  Created by xingl on 2017/6/10.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "NSString+Rex.h"

@implementation NSString (Rex)

- (BOOL)evaluate:(NSString *)rex{
    
    if (XL_IsEmptyString(self)) {
        
        return NO;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", rex];
    
    return [predicate evaluateWithObject:self];
}
//包含大写字母
- (BOOL)xl_containcUppercaseLetter {
    NSString *rex = @"^.*[A-Z]+.*$";
    return [self evaluate:rex];
}

//包含小写字母
- (BOOL)xl_containcLowercaseLetter {
    NSString *rex = @"^.*[a-z]+.*$";
    return [self evaluate:rex];
}

//包含字母
- (BOOL)xl_containcLetters {
    NSString *rex = @"^.*[a-zA-Z]+.*$";
    return [self evaluate:rex];
}
//包含中文
- (BOOL)xl_containCN {
    NSString *rex = @".*[\\u4e00-\\u9fa5]+.*";
    return [self evaluate:rex];
}
//- (BOOL)isValidChinese;
//{
//    NSString *chineseRegex = @"^[\u4e00-\u9fa5]+$";
//    return [self evaluate:chineseRegex];
//}
//银行卡号
- (BOOL)xl_isBankCardNumber {
    NSString *rex = @"^([0-9]{16}|[0-9]{19})$";
    BOOL vaild = [self evaluate:rex];
    return vaild;
}
//Email
- (BOOL)xl_isEmailString {
    NSString *rex = @"^\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b$";
    BOOL vaild = [self evaluate:rex];
    return vaild;
}
//包含数字
- (BOOL)xl_isContainNumber {
    NSString *rex = @"^.*\\d+.*$";
    
    return [self evaluate:rex];
}
//是否为数学数字
- (BOOL)xl_isMathsNumber {
    NSString *rex = @"^(\\+|-)?\\d+(\\.\\d+)?$";
    BOOL vaild = [self evaluate:rex];
    return vaild;
}
//是否为正整数
- (BOOL)xl_isMathsNumberIntegerString {
    NSString *rex = @"^[1-9]\\d*$";
    BOOL vaild = [self evaluate:rex];
    return vaild;
}
//全数字字符串
- (BOOL)xl_isNumberString {
    NSString *rex = @"^\\d+$";
    BOOL vaild = [self evaluate:rex];
    return vaild;
}

//全数字字符串 限定长度
- (BOOL)xl_isNumberString:(NSUInteger)length{
    NSString *rex = [NSString stringWithFormat:@"^[\\d]{%ld}$",(long)length];
    BOOL vaild = [self evaluate:rex];
    return vaild;
}
//验证身份证
- (BOOL)xl_isIDCardNumber {

    NSString *value = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    int length =0;
    if (!value) {
        return NO;
    }else {
        length = (int)value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return NO;
    }

}

//验证中文
- (BOOL)xl_isChineseNameString {
    NSString *rex = [NSString stringWithFormat:@"^([\\u4e00-\\u9fa5])+(·[\\u4e00-\\u9fa5]+)*$"];
    BOOL vaild = [self evaluate:rex];
    return vaild;
}

//ip
- (BOOL)xl_isIpString{
    
    NSString *rex = @"\\d{1,3}(.\\d{1,3}){3}";
    BOOL vaild = [self evaluate:rex];
    return vaild;
}

- (BOOL)xl_isPhoneNumberString {

    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,1705
     * 联通：130,131,132,152,155,156,185,186,1709
     * 电信：133,1349,153,180,189,1700
     */
    
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188，1705
     */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\\\d|705)\\\\d{7}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,152,155,156,185,186,1709
     */
    NSString * CU = @"^1((3[0-2]|5[256]|8[56])\\\\d|709)\\\\d{7}$";
    /**
     * 中国电信：China Telecom
     * 133,1349,153,180,189,1700
     */
    NSString * CT = @"^1((33|53|8[09])\\\\d|349|700)\\\\d{7}$";
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    NSString * PHS = @"^0(10|2[0-5789]|\\\\d{3})\\\\d{7,8}$";
    
    if (([self evaluate:CM])
        || ([self evaluate:CU])
        || ([self evaluate:CT])
        || ([self evaluate:PHS])) {
        return YES;
    }else {
        return NO;
    }
}
- (BOOL)xl_isMacAddress {
    NSString * macAddRegex = @"([A-Fa-f\\d]{2}:){5}[A-Fa-f\\d]{2}";
    return  [self evaluate:macAddRegex];
}
- (BOOL)xl_isValidUrl {
    NSString *regex = @"^((http)|(https))+:[^\\s]+\\.[^\\s]*$";
    return [self evaluate:regex];
}

@end
