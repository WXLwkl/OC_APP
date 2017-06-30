//
//  UIImage+Common.m
//  OC_APP
//
//  Created by xingl on 2017/6/6.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "UIImage+Common.h"

@implementation UIImage (Common)

+ (UIImage *)xl_imageWithClipImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)color {
//    获取图片的宽度和高度
    CGFloat imageWH = image.size.width;
//    设置圆环的宽度
    CGFloat border = borderWidth;
//    圆形的宽度和高度
    CGFloat ovalWH = imageWH + 2 * border;
    
//    1.开启上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(ovalWH, ovalWH), NO, 0);
//    2.画大圆
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, ovalWH, ovalWH)];
    [color set];
    [path fill];
//    3.设置裁剪区域
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(border, border, imageWH, imageWH)];
    [clipPath addClip];
//    4.绘制图片
    [image drawAtPoint:CGPointMake(border, border)];
//    5.获取图片
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
//    6.关闭上下文
    UIGraphicsEndImageContext();
    return clipImage;
}

+ (UIImage *)xl_imageWithCaptureView:(UIView *)captureView {
    UIGraphicsBeginImageContextWithOptions(captureView.bounds.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [captureView.layer renderInContext:ctx];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenImage;
}

+ (UIImage*)xl_imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)xl_imageWithOriginImage:(UIImage *)image scaleToWidth:(CGFloat)defineWidth {
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (UIImage *)xl_imageWithResizedImage:(NSString *)name leftCapWidth:(CGFloat)width topCapHeight:(CGFloat)height {
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:width topCapHeight:height];
}

/*
 
 UIImage *image = [UIImage imageNamed:imageName];
 UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
 //把图片画上去
 [image drawAtPoint:CGPointZero];
 //    绘制文字到图片
 [str drawAtPoint:point withAttributes:dict];
 //    从上下文获取图片
 UIImage *imageWater = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 
 */

+ (UIImage *)xl_imageWithWaterMarkImage:(NSString *)imageName
                             markString:(NSString *)markString
                                  color:(UIColor *)color
                                   font:(UIFont *)font {
    
    if (![color isKindOfClass:[UIColor class]]) {
        
        color = [UIColor whiteColor];
    }
    
    
    if (![markString isKindOfClass:[NSString class]]) {
        
        markString = @"";
    }
    UIImage *image = [UIImage imageNamed:imageName];
    CGFloat imageH = image.size.height;
    
    if (image.size.width * imageH == 0) {
        
        return image;
    }
    
    CGSize size = [markString boundingRectWithSize:image.size options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
    
    CGRect rect = CGRectMake(10,
                             imageH - size.height-10,
                             size.width,
                             size.height);
    
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowOffset = CGSizeMake(1, 1);
    shadow.shadowBlurRadius = 1.0;
    shadow.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    NSDictionary *att = @{NSFontAttributeName:font,
                          NSForegroundColorAttributeName:color,
                          NSShadowAttributeName:shadow,
                          NSVerticalGlyphFormAttributeName:@(0)
                          };

    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //把图片画上去
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //    绘制文字到图片
    [markString drawInRect:rect
            withAttributes:att];
    //    从上下文获取图片
    UIImage *imageWater = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageWater;
}

- (void)setGradientLayerWithView:(UIView *)view {
    // 创建 CAGradientLayer 对象
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    // 设置 gradientLayer 的 Frame
    gradientLayer.frame = view.bounds;
    // 创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor yellowColor].CGColor, (__bridge id)[UIColor redColor].CGColor];
    // 设置三种颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@(0.0f) ,@(0.2f) ,@(1.0f)];
    // 设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    // 添加渐变色到创建的 UIView 上去
    [view.layer addSublayer:gradientLayer];
}

- (UIImage *)xl_imageWithTitle:(NSString *)title fontSize:(CGFloat)fontSize color:(UIColor *)color {
    //画布大小
    CGSize size=CGSizeMake(self.size.width,self.size.height);
    //创建一个基于位图的上下文
    UIGraphicsBeginImageContextWithOptions(size,NO,0.0);//opaque:NO  scale:0.0
    
    [self drawAtPoint:CGPointMake(0.0,0.0)];
    
    //文字居中显示在画布上
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment=NSTextAlignmentCenter;//文字居中
    
    //计算文字所占的size,文字居中显示在画布上
    CGSize sizeText=[title boundingRectWithSize:self.size options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}context:nil].size;
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    
    CGRect rect = CGRectMake((width-sizeText.width)/2, (height-sizeText.height)/2, sizeText.width, sizeText.height);
    //绘制文字
    [title drawInRect:rect withAttributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName: color,NSParagraphStyleAttributeName:paragraphStyle}];
    
    //返回绘制的新图形
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (NSString *)xl_base64EncodedString {
    NSData *data = UIImageJPEGRepresentation(self, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}

@end
