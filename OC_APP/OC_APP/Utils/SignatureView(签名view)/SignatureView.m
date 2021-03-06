//
//  SignatureView.m
//  OC_APP
//
//  Created by xingl on 2018/1/26.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "SignatureView.h"
#import <QuartzCore/QuartzCore.h>

#define StrWidth 210
#define StrHeight 20

static CGPoint midpoint(CGPoint p0,CGPoint p1) {
    return (CGPoint) {
        (p0.x + p1.x) / 2.0,
        (p0.y + p1.y) / 2.0
    };
}

@interface SignatureView () {
    UIBezierPath *path;
    CGPoint previousPoint;
    BOOL isHaveDraw;
}

@end

@implementation SignatureView

- (void)commonInit {
    
    self.backgroundColor = [UIColor whiteColor];
    
    path  = [UIBezierPath bezierPath];
    [path setLineWidth:2];
    max = 0;
    min = 0;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    pan.maximumNumberOfTouches = pan.minimumNumberOfTouches = 1;
    [self addGestureRecognizer:pan];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
        self.currentPointArr = [NSMutableArray array];
        self.hasSignatureImg = NO;
        isHaveDraw = NO;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}


- (void)clear {
    if (self.currentPointArr && self.currentPointArr.count > 0) {
        [self.currentPointArr removeAllObjects];
    }
    self.hasSignatureImg = NO;
    max = 0;
    min = 0;
    
    path = [UIBezierPath bezierPath];
    [path setLineWidth:2];
    isHaveDraw = NO;
    [self setNeedsDisplay];
}

- (void)sure {
    // 没有签名发生时
    if (max == 0 && min == 0) {
        min = 0;
        max = 0;
    }
    isSure = YES;
    [self setNeedsDisplay];
    return [self imageRepresentation];
}

- (UIImage*)imageBlackToTransparent:(UIImage*)image {
    // 分配内存
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t *rgbImageBuf = (uint32_t *)malloc(bytesPerRow * imageHeight);
    
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    
    uint32_t *pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++) {
        if (*pCurPtr == 0xffffff) {
            uint8_t *ptr = (uint8_t *)pCurPtr;
            ptr[0] = 0;
        }
    }
    
    // 将内存转为Image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, NULL);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace, kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider, NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage *resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    //释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

- (void)imageRepresentation {
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    image = [self imageBlackToTransparent:image];
    
    NSLog(@"width:%f,height:%f",image.size.width,image.size.height);
    
    UIImage *img = [self cutImage:image];
    
    self.SignatureImg = [self scaleToSize:img];
}
//压缩图片,最长边为128(根据不同的比例来压缩)
- (UIImage *)scaleToSize:(UIImage *)img {
    CGRect rect;
    CGFloat imageWidth = img.size.width;
    if (imageWidth >= 128) {
        rect = CGRectMake(0, 0, 128, self.frame.size.height);
    } else {
        rect = CGRectMake(0, 0, img.size.width, self.frame.size.height);
    }
    CGSize size = rect.size;
    UIGraphicsBeginImageContext(size);
    [img drawInRect:rect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setNeedsDisplay];
    return scaledImage;
}
//只截取签名部分图片
- (UIImage *)cutImage:(UIImage *)image {
    CGRect rect;
    if (min == 0 && max == 0) {
        rect = CGRectZero;
    } else {
        rect = CGRectMake(min - 3, 0, max - min + 6, self.frame.size.height);
    }
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *img = [UIImage imageWithCGImage:imageRef];
    
    UIImage *lastImage = [self addText:img text:self.showMessage];
    CGImageRelease(imageRef);
    [self setNeedsDisplay];
    return lastImage;
}

//签名完成，给签名照添加新的水印
- (UIImage *)addText:(UIImage *)img text:(NSString *)mark {
    CGFloat w = img.size.width;
    CGFloat h = img.size.height;
    
    // 根据截图大小改变文字大小
    CGFloat size = 20;
    UIFont *textFont = [UIFont systemFontOfSize:size];
    CGSize sizeOfText = [mark sizeWithFont:textFont constrainedToSize:CGSizeMake(128, 30)];
    
    if (w < sizeOfText.width) {
        while (sizeOfText.width > w) {
            size--;
            textFont = [UIFont systemFontOfSize:size];
            sizeOfText = [mark sizeWithFont:textFont constrainedToSize:CGSizeMake(128,30)];
        }
    } else {
        size =45;
        textFont = [UIFont systemFontOfSize:size];
        sizeOfText = [mark sizeWithFont:textFont constrainedToSize:CGSizeMake(self.frame.size.width,30)];
        while (sizeOfText.width>w) {
            size ++;
            textFont = [UIFont systemFontOfSize:size];
            sizeOfText = [mark sizeWithFont:textFont constrainedToSize:CGSizeMake(self.frame.size.width,30)];
        }
    }
    UIGraphicsBeginImageContext(img.size);
    [[UIColor redColor] set];
    [img drawInRect:CGRectMake(0,0, w, h)];
    [mark drawInRect:CGRectMake((w-sizeOfText.width)/2,(h-sizeOfText.height)/2, sizeOfText.width, sizeOfText.height)withFont:textFont];
    UIImage *aimg =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return aimg;
}

- (void)pan:(UIPanGestureRecognizer *)pan  {
    CGPoint currentPoint = [pan locationInView:self];
    NSLog(@"获取到的触摸点的位置为--currentPoint:%@",NSStringFromCGPoint(currentPoint));
    CGPoint midPoint = midpoint(previousPoint, currentPoint);
    [self.currentPointArr addObject:[NSValue valueWithCGPoint:currentPoint]];
    self.hasSignatureImg = YES;
    CGFloat viewHeight = self.frame.size.height;
    CGFloat currentY = currentPoint.y;
    if (pan.state == UIGestureRecognizerStateBegan) {
        [path moveToPoint:currentPoint];
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        [path addQuadCurveToPoint:midPoint controlPoint:previousPoint];
    }
    if (0 <= currentY && currentY <= viewHeight) {
        if (max == 0 && min == 0) {
            max = currentPoint.x;
            min = currentPoint.x;
        } else {
            if (max <= currentPoint.x) {
                max = currentPoint.x;
            }
            if (min >= currentPoint.x) {
                min = currentPoint.x;
            }
        }
    }
    
    previousPoint = currentPoint;
    [self setNeedsDisplay];
    isHaveDraw = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSignatureWriteAction)]) {
        [self.delegate onSignatureWriteAction];
    }
}


- (void)drawRect:(CGRect)rect {
    
    [[UIColor blackColor] setStroke];
    [path stroke];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!isSure && !isHaveDraw) {
        NSString *str = @"此处手写签名: 正楷, 工整书写";
        CGContextSetRGBFillColor(context, 199/255.0, 199/255.0, 199/255.0, 1.0); //设置填充颜色
        CGRect rect1 = CGRectMake((rect.size.width - StrWidth) / 2, (rect.size.height - StrHeight) / 3 - 5, StrWidth, StrHeight);
        origionX = rect1.origin.x;
        totalWidth = rect1.origin.x + StrWidth;
        UIFont *font = [UIFont systemFontOfSize:15]; //设置字体
//        [str drawInRect:rect1 withAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName: font}];
        [str drawInRect:rect1 withFont:font];
    } else {
        isSure = NO;
    }
}

@end
