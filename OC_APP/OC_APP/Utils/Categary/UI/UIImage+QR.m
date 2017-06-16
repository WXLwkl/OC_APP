//
//  UIImage+QR.m
//  OC_APP
//
//  Created by xingl on 2017/6/6.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "UIImage+QR.h"

@implementation UIImage (QR)

#pragma mark - 生成黑白二维码
+ (UIImage *)xl_qrCodeImageWithContent:(NSString *)content
                    codeImageLenght:(CGFloat)lenght {
    
    UIImage *image = [self qrCodeImageWithContent:content codeImageSize:lenght];
    return image;
}
#pragma mark - 生成黑白带logo的二维码
+ (UIImage *)xl_qrCodeImageWithContent:(NSString *)content
                    codeImageLenght:(CGFloat)lenght
                               logo:(UIImage *)logo
                             radius:(CGFloat)radius {
    
    UIImage *image = [self qrCodeImageWithContent:content codeImageSize:lenght];
    return [self imageInsertedImage:image insertImage:logo radius:radius];
}
#pragma mark - 生成多彩带logo的二维码
+ (UIImage *)xl_qrCodeImageWithContent:(NSString *)content
                      codeImageLenght:(CGFloat)lenght
                               logo:(UIImage *)logo
                             radius:(CGFloat)radius
                                red:(CGFloat)red
                              green:(CGFloat)green
                               blue:(CGFloat)blue {
    
    UIImage *image = [self qrCodeImageWithContent:content codeImageSize:lenght red:red green:green blue:blue];
    return [self imageInsertedImage:image insertImage:logo radius:radius];
}

// 生成条形码图片
+ (UIImage *)xl_generateBarCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height {
    
    CIImage *barcodeImage;
    NSData *data = [code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    
    [filter setValue:data forKey:@"inputMessage"];
    barcodeImage = [filter outputImage];
    
    // 消除模糊
    CGFloat scaleX = width / barcodeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = height / barcodeImage.extent.size.height;
    CIImage *transformedImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
}
//改变二维码颜色
+ (UIImage *)qrCodeImageWithContent:(NSString *)content codeImageSize:(CGFloat)size red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
    UIImage *image = [self qrCodeImageWithContent:content codeImageSize:size];
    
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

//改变二维码尺寸大小
+ (UIImage *)qrCodeImageWithContent:(NSString *)content codeImageSize:(CGFloat)size{
    CIImage *image = [self qrCodeImageWithContent:content];
    CGRect integralRect = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(integralRect), size/CGRectGetHeight(integralRect));
    
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
    return [UIImage imageWithCGImage:scaledImage];
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
