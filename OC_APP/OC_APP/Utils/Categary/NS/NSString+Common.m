//
//  NSString+Common.m
//  OC_APP
//
//  Created by xingl on 2017/6/10.
//  Copyright © 2017年 兴林. All rights reserved.
//

#define EmojiCodeToSymbol(c) ((((0x808080F0 | (c & 0x3F000) >> 4) | (c & 0xFC0) << 10) | (c & 0x1C0000) << 18) | (c & 0x3F) << 24)

#import "NSString+Common.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (Common)

- (NSString *)xl_emoji {
    return [NSString emojiWithStringCode:self];
}

+ (NSString *)emojiWithStringCode:(NSString *)stringCode {
    char *charCode = (char *)stringCode.UTF8String;
    long intCode = strtol(charCode, NULL, 16);
    return [self emojiWithIntCode:intCode];
}
+ (NSString *)emojiWithIntCode:(long)intCode {
    long symbol = EmojiCodeToSymbol(intCode);
    NSString *string = [[NSString alloc] initWithBytes:&symbol length:sizeof(symbol) encoding:NSUTF8StringEncoding];
    if (string == nil) {
        string = [NSString stringWithFormat:@"%C", (unichar)intCode];
    }
    return string;
}


+ (NSString *)xl_getSecrectStringWithPhoneNumber:(NSString *)phoneNum {
    NSMutableString *newStr = [NSMutableString stringWithString:phoneNum];
    NSRange range = NSMakeRange(3, 4);
    [newStr replaceCharactersInRange:range withString:@"****"];
    return newStr;
}
+ (NSString *)xl_getSecrectStringWithAccountNo:(NSString *)accountNo {
    NSMutableString *newStr = [NSMutableString stringWithString:accountNo];
    NSRange range = NSMakeRange(4, 8);
    if (newStr.length>12) {
        [newStr replaceCharactersInRange:range withString:@" **** **** "];
    }
    return newStr;
    
}
+ (NSString *)xl_transform:(NSString *)chinese {
    
    //将NSString转换成NSMutableString
    NSMutableString *pinyin = [chinese mutableCopy];
    //将汉字转换为拼音(带音标)
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    NSLog(@"%@", pinyin);
    //去掉拼音的音标
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    NSLog(@"%@",pinyin);
    
    return pinyin;    
}

+ (NSString *)xl_stringChangeMoneyWithStr:(NSString *)str numberStyle:(NSNumberFormatterStyle)numberStyle {
    
    // 判断是否null 若是赋值为0 防止崩溃
    if (([str isEqual:[NSNull null]] || str == nil)) {
        str = 0;
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle = numberStyle;
    // 注意传入参数的数据长度，可用double
    NSString *money = [formatter stringFromNumber:[NSNumber numberWithDouble:[str doubleValue]]];
    
    return money;
}
// 自定义正数格式(金额的格式转化) 94,862.57 前缀可在所需地方随意添加
+ (NSString *)xl_stringChangeMoneyWithDouble:(double)number {
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.positiveFormat = @",###.##"; // 正数格式
    // 注意传入参数的数据长度，可用double
    NSString *money = [formatter stringFromNumber:@(number)];
    //    money = [NSString stringWithFormat:@"￥%@", money];
    
    return money;
}


/**
 阿拉伯数字转成中文
 
 @param arebic 阿拉伯数字
 @return 返回的中文数字
 */
+ (NSString *)xl_translation:(NSString *)arebic {
    NSString *str = arebic;
    NSArray *arabic_numerals = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chinese_numerals = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chinese_numerals forKeys:arabic_numerals];
    
    NSMutableArray *sums = [NSMutableArray array];
    for (int i = 0; i < str.length; i ++) {
        NSString *substr = [str substringWithRange:NSMakeRange(i, 1)];
        NSString *a = [dictionary objectForKey:substr];
        NSString *b = digits[str.length -i-1];
        NSString *sum = [a stringByAppendingString:b];
        if ([a isEqualToString:chinese_numerals[9]])
        {
            if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
            {
                sum = b;
                if ([[sums lastObject] isEqualToString:chinese_numerals[9]])
                {
                    [sums removeLastObject];
                }
            }else
            {
                sum = chinese_numerals[9];
            }
            
            if ([[sums lastObject] isEqualToString:sum])
            {
                continue;
            }
        }
        
        [sums addObject:sum];
    }
    
    NSString *sumStr = [sums componentsJoinedByString:@""];
    NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
    NSLog(@"%@",str);
    NSLog(@"%@",chinese);
    return chinese;
}



- (NSString *)xl_stringByStrippingHTML
{
    return [self stringByReplacingOccurrencesOfString:@"<[^>]+>" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
}

- (NSString *)xl_stringByRemovingScriptsAndStrippingHTML
{
    NSMutableString *mString = [self mutableCopy];
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<script[^>]*>[\\w\\W]*</script>" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:mString options:NSMatchingReportProgress range:NSMakeRange(0, [mString length])];
    for (NSTextCheckingResult *match in [matches reverseObjectEnumerator]) {
        [mString replaceCharactersInRange:match.range withString:@""];
    }
    return [mString xl_stringByStrippingHTML];
}

- (NSString *)xl_trimmingWhitespace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)xl_trimmingWhitespaceAndNewlines
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}



- (NSString *)xl_md5 {
    
    if (self == nil) {
        return nil;
    }
    
    return [[self xl_MD5] lowercaseString];
}

- (NSString *)xl_MD5 {
    
    if (self == nil) {
        return nil;
    }
    const char* str = [self UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    NSNumber *len = @(strlen(str));
    unsigned int lenU = [len unsignedIntValue];
    CC_MD5(str, lenU, result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        
        [ret appendFormat:@"%02X",result[i]];
    }
    
    return ret;
}




- (NSString *)xl_base64EncodedString {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)xl_base64DecodedString {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)xl_URLEncodeString {

    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              CFSTR("!*'();:@&=+$,/?%#[]"),
                                                              CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
}

- (NSString *)xl_URLDecodeString {

    NSString *decodedString = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                  (__bridge CFStringRef)self,
                                                                                                                  CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));

    return decodedString;
}

- (NSString *)xl_URLGBKEncodedString {

    CFStringEncoding enc = CFStringConvertNSStringEncodingToEncoding(kCFStringEncodingGB_18030_2000);
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (CFStringRef)self,
                                                                                             NULL,
                                                                                             CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                             enc));
    return result;
}


- (UIImage *)xl_base64DecodedImage {
    NSData *decodedImageData = [[NSData alloc]
                                initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
    return decodedImage;
}

- (CGSize)xl_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = @{}.mutableCopy;
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return CGSizeMake(ceil(result.width), ceil(result.height));
}

- (CGFloat)xl_widthForFont:(UIFont *)font {
    CGSize size = [self xl_sizeForFont:font size:CGSizeMake(HUGE, HUGE) mode:NSLineBreakByWordWrapping];
    return size.width;
}

- (CGFloat)xl_heightForFont:(UIFont *)font width:(CGFloat)width {
    CGSize size = [self xl_sizeForFont:font size:CGSizeMake(width, HUGE) mode:NSLineBreakByWordWrapping];
    return size.height;
}

- (CGFloat)heightForString:(NSString *)str font:(UIFont *)font width:(CGFloat)width {
    CGFloat height;
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        CGRect rect = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:@{ NSFontAttributeName: font } context:nil];
        height = rect.size.height;
        height += 1;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGSize size = [str sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
        height = size.height;
    }
    return height;
}
- (CGFloat)xl_heightForFont:(UIFont *)font width:(CGFloat)width line:(NSInteger)line {
    NSMutableString *test = NSMutableString.new;
    for (int i=0; i<line; i++) {
        [test appendString:@"字"];
    }
    CGFloat maxHeight = [self heightForString:test font:font width:1];
    CGFloat height = [self heightForString:self font:font width:width];
    return height > maxHeight ? maxHeight : height;
}




#pragma mark - NSMutableAttributedString

- (NSMutableAttributedString *)xl_setStringBackgroundColor:(UIColor *)color range:(NSRange)range {
    NSDictionary *attrDic = @{NSBackgroundColorAttributeName:color};
    return [self setStringAttributes:attrDic range:range];
}

- (NSMutableAttributedString *)xl_setStringFont:(UIFont *)font range:(NSRange)range {
    NSDictionary *attrDic = @{NSFontAttributeName:font};
    return [self setStringAttributes:attrDic range:range];
}

- (NSMutableAttributedString *)xl_setStringColor:(UIColor *)color range:(NSRange)range {
    NSDictionary *attrDic = @{NSForegroundColorAttributeName:color};
    return [self setStringAttributes:attrDic range:range];
}

- (NSMutableAttributedString *)xl_setStringStrokeColor:(UIColor *)color width:(CGFloat)width range:(NSRange)range {
    NSDictionary *attrDic = @{NSStrokeColorAttributeName:color,
                              NSStrokeWidthAttributeName:@(width)};
    return [self setStringAttributes:attrDic range:range];
}

- (NSMutableAttributedString *)xl_setStringSpace:(CGFloat)space range:(NSRange)range {
    NSDictionary *attrDic = @{NSKernAttributeName:@(space)};
    return [self setStringAttributes:attrDic range:range];
}

- (NSMutableAttributedString *)xl_setStringGradient:(CGFloat)gradient range:(NSRange)range {
    NSDictionary *attrDic = @{NSObliquenessAttributeName:@(gradient)};
    return [self setStringAttributes:attrDic range:range];
}

- (NSMutableAttributedString *)xl_setStringExpansion:(CGFloat)expansion range:(NSRange)range {
    NSDictionary *attrDic = @{NSExpansionAttributeName:@(expansion)};
    return [self setStringAttributes:attrDic range:range];
}

- (NSMutableAttributedString *)xl_setstringBaselineOffset:(CGFloat)offset range:(NSRange)range {
    NSDictionary *attrDic = @{NSBaselineOffsetAttributeName:@(offset)};
    return [self setStringAttributes:attrDic range:range];
}

- (NSMutableAttributedString *)xl_setStringShadowOffset:(CGSize)offset shadowRadius:(CGFloat)radius color:(UIColor *)color range:(NSRange)range {
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = offset;
    shadow.shadowBlurRadius = radius;
    shadow.shadowColor = color;
    NSDictionary *attrDic = @{NSShadowAttributeName:shadow};
    return [self setStringAttributes:attrDic range:range];
}

- (NSMutableAttributedString *)xl_setStringUnderLine:(NSUnderlineStyle)style color:(UIColor *)color range:(NSRange)range {
    NSDictionary *attrDic = @{NSUnderlineStyleAttributeName:@(style),
                              NSUnderlineColorAttributeName:color};
    return [self setStringAttributes:attrDic range:range];
}

- (NSMutableAttributedString *)xl_setStringDeleteLine:(NSUnderlineStyle)style color:(UIColor *)color range:(NSRange)range {
    NSDictionary *attrDic = @{NSStrikethroughStyleAttributeName:@(style),
                              NSStrikethroughColorAttributeName:color};
    return [self setStringAttributes:attrDic range:range];
}

- (NSMutableAttributedString *)xl_setStringWithImage:(NSString *)imageName bounds:(CGRect)bounds index:(NSInteger)index {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:imageName];
    attachment.bounds = bounds;
    NSAttributedString *attachmentStr = [NSAttributedString attributedStringWithAttachment:attachment];
    [attrString insertAttributedString:attachmentStr atIndex:index];
    return attrString;
}

#pragma mark - 私有
- (NSMutableAttributedString *)setStringAttributes:(NSDictionary<NSString *, id>*)attributeDictionary range:(NSRange)range {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    [attributedString addAttributes:attributeDictionary range:range];
    return attributedString;
}

@end

NSString *XL_FilterString(id obj){
    
    if (obj == nil) {
        
        return @"";
    }
    
    if ([obj isKindOfClass:[NSString class]]) {
        
        return [NSString stringWithFormat:@"%@",obj];
        
    }else if([obj isKindOfClass:[NSNumber class]]){
        
        return [NSString stringWithFormat:@"%@",obj];
    }
    return @"";
    
}

BOOL XL_IsEmptyString(NSObject *obj){
    
    BOOL isEmpty = YES;
    
    if (!obj || ![obj isKindOfClass:[NSString class]]) {
        
        isEmpty = YES;
    }
    else{
        
        isEmpty = NO;
    }
    
    if (!isEmpty) {
        
        NSString *string = (NSString *)obj;
        
        if ([string length] == 0
            || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
            
            isEmpty = YES;
        }
        else{
            
            isEmpty = NO;
        }
    }
    
    return isEmpty;
}
