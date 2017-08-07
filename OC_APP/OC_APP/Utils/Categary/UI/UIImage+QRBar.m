//
//  UIImage+QRBar.m
//  OC_APP
//
//  Created by xingl on 2017/6/6.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "UIImage+QRBar.h"

@implementation UIImage (QRBar)

#pragma mark - 黑白二维码
+ (UIImage *)xl_qrCodeImageWithContent:(NSString *)content
                    codeImageLenght:(CGFloat)lenght {

    //最原始的图片
    CIImage *ciImage = [self qrCodeImageWithContent:content];
    //改变二维码尺寸大小
    UIImage *image = [self codeImageWithCIImage:ciImage codeImageSize:CGSizeMake(lenght, lenght)];
    return image;
    
}
#pragma mark 黑白带logo的二维码
+ (UIImage *)xl_qrCodeImageWithContent:(NSString *)content
                    codeImageLenght:(CGFloat)lenght
                               logo:(UIImage *)logo
                             radius:(CGFloat)radius {
    
    //改变大小后的黑白的二维码
    UIImage *image = [self xl_qrCodeImageWithContent:content codeImageLenght:lenght];
//    插入logo后的二维码图片
    return [self imageInsertedImage:image insertImage:logo radius:radius];
}
#pragma mark 多彩带logo的二维码
+ (UIImage *)xl_qrCodeImageWithContent:(NSString *)content
                      codeImageLenght:(CGFloat)lenght
                               logo:(UIImage *)logo
                             radius:(CGFloat)radius
                                red:(CGFloat)red
                              green:(CGFloat)green
                               blue:(CGFloat)blue {
    //改变大小后的黑白的二维码
    UIImage *image = [self xl_qrCodeImageWithContent:content codeImageLenght:lenght];
    //改变颜色
    image = [self codeImageWithImage:image red:red green:green blue:blue];
    return [self imageInsertedImage:image insertImage:logo radius:radius];
}
//生成最原始的二维码
+ (CIImage *)qrCodeImageWithContent:(NSString *)content{
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    [qrFilter setValue:contentData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *image = qrFilter.outputImage;
    return image;
}
#pragma mark - 黑白条形码
+ (UIImage *)xl_barCodeImageWithContent:(NSString *)content
                          codeImageSize:(CGSize)size {
    CIImage *image = [self barcodeImageWithContent:content];
    UIImage *resultImage = [self codeImageWithCIImage:image codeImageSize:size];
    return resultImage;
}

#pragma mark 多彩条形码
+ (UIImage *)xl_barCodeImageWithContent:(NSString *)content
                          codeImageSize:(CGSize)size
                                    red:(CGFloat)red
                                  green:(CGFloat)green
                                   blue:(CGFloat)blue {
    if (IOS_Foundation_Before_8) {
        return nil;
    }
    UIImage *image = [self xl_barCodeImageWithContent:content
                                        codeImageSize:size];
    
    return [self codeImageWithImage:image red:red green:green blue:blue];
}
//生成最原始的条形码
+ (CIImage *)barcodeImageWithContent:(NSString *)content {
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    [qrFilter setValue:contentData forKey:@"inputMessage"];
    [qrFilter setValue:@(0.00) forKey:@"inputQuietSpace"];
    CIImage *image = qrFilter.outputImage;
    
    return image;
}



#pragma mark -
//改变图片颜色
+ (UIImage *)codeImageWithImage:(UIImage *)image red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
    
    int imageWidth = image.size.width;
    int imageHeight = image.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t *rgbImageBuf = (uint32_t *)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpaceRef, kCGBitmapByteOrder32Little|kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    //遍历像素, 改变像素点颜色
    int pixelNum = imageWidth * imageHeight;
    uint32_t *pCurPtr = rgbImageBuf;
    for (int i = 0; i<pixelNum; i++, pCurPtr++) {
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900) {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red*255;
            ptr[2] = green*255;
            ptr[1] = blue*255;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    //取出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpaceRef,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage *resultImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpaceRef);
    
    return resultImage;
}

//改变图片尺寸大小
+ (UIImage *)codeImageWithCIImage:(CIImage *)image codeImageSize:(CGSize)size {

    CGRect integralRect = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size.width/CGRectGetWidth(integralRect), size.height/CGRectGetHeight(integralRect));
    
    size_t width = CGRectGetWidth(integralRect)*scale;
    size_t height = CGRectGetHeight(integralRect)*scale;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaNone);
    //    CIContext *context = [CIContext contextWithOptions:nil];
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:integralRect];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, integralRect, bitmapImage);
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    UIImage *resultimage = [UIImage imageWithCGImage:scaledImage];
    CGImageRelease(scaledImage);
    return resultimage;
}


void ProviderReleaseData (void *info, const void *data, size_t size) {
    free((void*)data);
}



/*----------------------------------------------------*/


+ (UIImage *)imageInsertedImage:(UIImage *)originImage insertImage:(UIImage *)insertImage radius: (CGFloat)radius {
    
    if (!insertImage) { return originImage; }
    
    insertImage = [self imageOfRoundRectWithImage:insertImage size:insertImage.size radius:radius];
    
    UIImage * whiteBG = [UIImage imageNamed: @"whiteBG"];
    
    whiteBG = [self imageOfRoundRectWithImage:whiteBG size:whiteBG.size radius:radius];
    
    //白色边缘宽度
    
    const CGFloat whiteSize = 5.f;
    
    CGSize brinkSize = CGSizeMake(originImage.size.width / 4, originImage.size.height / 4);
    
    CGFloat brinkX = (originImage.size.width - brinkSize.width) * 0.5;
    
    CGFloat brinkY = (originImage.size.height - brinkSize.height) * 0.5;
    
    CGSize imageSize = CGSizeMake(brinkSize.width - 2 * whiteSize, brinkSize.height - 2 * whiteSize);
    
    CGFloat imageX = brinkX + whiteSize;
    
    CGFloat imageY = brinkY + whiteSize;
    
    UIGraphicsBeginImageContext(originImage.size);
    
    [originImage drawInRect: (CGRect){ 0, 0, (originImage.size) }];
    
    [whiteBG drawInRect: (CGRect){ brinkX, brinkY, (brinkSize) }];
    
    [insertImage drawInRect: (CGRect){ imageX, imageY, (imageSize) }];
    
    UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultImage;
    
}
+ (UIImage *)imageOfRoundRectWithImage:(UIImage *)image size:(CGSize)size radius:(CGFloat)radius

{
    if (!image) { return nil; }
    const CGFloat width = size.width;
    const CGFloat height = size.height;
    radius = MAX(10.f, radius);
    radius = MIN(20.f, radius);
    UIImage * img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, width, height);
    //绘制圆角
    CGContextBeginPath(context);
    addRoundRectToPath(context,rect,radius,image.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage: imageMasked];
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    return img;
    
}
/**
 *  给上下文添加圆角蒙版
 */
void addRoundRectToPath(CGContextRef context, CGRect rect, float radius, CGImageRef image)
{
    float width, height;
    if (radius == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    width = CGRectGetWidth(rect);
    height = CGRectGetHeight(rect);
    
    //裁剪路径
    CGContextMoveToPoint(context, width, height / 2);
    CGContextAddArcToPoint(context, width, height, width / 2, height, radius);
    CGContextAddArcToPoint(context, 0, height, 0, height / 2, radius);
    CGContextAddArcToPoint(context, 0, 0, width / 2, 0, radius);
    CGContextAddArcToPoint(context, width, 0, width, height / 2, radius);
    CGContextClosePath(context);
    CGContextClip(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
    CGContextRestoreGState(context);
}

@end
