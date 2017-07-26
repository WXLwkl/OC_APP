//
//  UILabel+Common.m
//  OC_APP
//
//  Created by xingl on 2017/7/6.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "UILabel+Common.h"

@implementation UILabel (Common)


- (CGFloat)lineHeight {
    CGSize rowSize = [@"" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName, nil]];
    return rowSize.height;
}

- (NSInteger)textNumberOfLines {
    CGSize contentSize = [self.text boundingRectWithSize:CGSizeMake(self.width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.font} context:nil].size;
    return contentSize.height / self.lineHeight;
}

- (CGFloat)textHeight {
    CGSize size = [self textRectForBounds:CGRectMake(0, 0, self.width, 10000) limitedToNumberOfLines:self.numberOfLines].size;
    return size.height;
}

- (CGFloat)textWidth {
    CGSize size = [self textRectForBounds:CGRectMake(0, 0, self.width, 10000) limitedToNumberOfLines:self.numberOfLines].size;
    return size.width;
}


- (CGSize)textSizeForLimitedSize:(CGSize)size {
    CGRect rect = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
    self.frame = rect;
    CGFloat height = self.textHeight > size.height ? size.height : self.textHeight;
    return CGSizeMake(self.textWidth, height);
}

- (NSMutableAttributedString *)attributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace limitWidth:(CGFloat)limitWidth {
    if (string == nil) {
        string = @"";
    }
    self.width = limitWidth;
    self.text = string;
    lineSpace = self.textNumberOfLines > 1 ? lineSpace : 0;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    NSRange range = NSMakeRange(0, string.length);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    return attributedString;
}

@end
