//
//  UILabel+Common.m
//  OC_APP
//
//  Created by xingl on 2017/7/6.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "UILabel+Common.h"

@implementation UILabel (Common)


- (CGFloat)xl_lineHeight {
    CGSize rowSize = [@"" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName, nil]];
    return rowSize.height;
}

- (NSInteger)xl_textNumberOfLines {
    CGSize contentSize = [self.text boundingRectWithSize:CGSizeMake(self.xl_width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.font} context:nil].size;
    return contentSize.height / self.xl_lineHeight;
}

- (CGFloat)xl_textHeight {
    CGSize size = [self textRectForBounds:CGRectMake(0, 0, self.xl_width, 10000) limitedToNumberOfLines:self.numberOfLines].size;
    return size.height;
}

- (CGFloat)xl_textWidth {
    CGSize size = [self textRectForBounds:CGRectMake(0, 0, self.xl_width, 10000) limitedToNumberOfLines:self.numberOfLines].size;
    return size.width;
}


- (CGSize)xl_textSizeForLimitedSize:(CGSize)size {
    CGRect rect = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
    self.frame = rect;
    CGFloat height = self.xl_textHeight > size.height ? size.height : self.xl_textHeight;
    return CGSizeMake(self.xl_textWidth, height);
}

- (NSMutableAttributedString *)xl_attributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace limitWidth:(CGFloat)limitWidth {
    if (string == nil) {
        string = @"";
    }
    self.xl_width = limitWidth;
    self.text = string;
    lineSpace = self.xl_textNumberOfLines > 1 ? lineSpace : 0;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    NSRange range = NSMakeRange(0, string.length);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    return attributedString;
}

@end
