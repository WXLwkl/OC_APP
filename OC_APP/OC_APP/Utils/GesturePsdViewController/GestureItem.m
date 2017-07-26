//
//  GestureItem.m
//  shoushi
//
//  Created by xingl on 2017/7/17.
//  Copyright © 2017年 xingl. All rights reserved.
//

#import "GestureItem.h"
#import "SecureManager.h"

//外空心圆边界宽度
CGFloat const circleBorderWidth = 1.0f;

//内部的实心圆所占外圆的比例大小
CGFloat const circleRatio = 0.3f;

//三角形箭头的边长
CGFloat const arrowH = 8.0;

@interface GestureItem ()

@property (nonatomic,strong) UIColor *circleColor;

@end

@implementation GestureItem



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.itemStatus = GestureItemStatusNormal;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    
    CGContextRef cr = UIGraphicsGetCurrentContext();
    CGContextClearRect(cr, rect);
    
    //画外圆圈
    CGFloat circleDiameter = MIN(rect.size.width, rect.size.height) - circleBorderWidth * 2.0;
    CGRect circleInRect = CGRectMake(circleBorderWidth, circleBorderWidth, circleDiameter, circleDiameter);
    CGContextAddEllipseInRect(cr, circleInRect);
    CGContextSetLineWidth(cr, circleBorderWidth);
    [self.circleColor set];
    CGContextStrokePath(cr);
    
    //画内实心圆
    if (self.itemStatus != GestureItemStatusNormal) {
        
        CGFloat filledCircleDiameter = circleDiameter * circleRatio;
        CGFloat filledCircleX = (rect.size.width - filledCircleDiameter) * 0.5;
        CGFloat filledCircleY = (rect.size.height - filledCircleDiameter) * 0.5;
        CGContextAddEllipseInRect(cr, CGRectMake(filledCircleX, filledCircleY, filledCircleDiameter, filledCircleDiameter));
        [self.circleColor set];
        CGContextFillPath(cr);
        
        //画指示方向三角箭头
        if (self.itemStatus == GestureItemStatusSelectedAndShowArrow || self.itemStatus == GestureItemStatusErrorAndShowArrow) {
            //先平移到圆心然后再旋转然后再平移回来
            CGFloat offset = MIN(rect.size.width, rect.size.height) * 0.5;
            CGContextTranslateCTM(cr, offset, offset);
            CGContextRotateCTM(cr, self.angle);
            CGContextTranslateCTM(cr, -offset, -offset);
            
            CGFloat arrowMargin = (filledCircleY - arrowH) * 0.5;
            CGContextMoveToPoint(cr, (rect.size.width - arrowH * 1.5) * 0.5, filledCircleY - arrowMargin);
            CGContextAddLineToPoint(cr, (rect.size.width + arrowH * 1.5) * 0.5, filledCircleY - arrowMargin);
            CGContextAddLineToPoint(cr, rect.size.width * 0.5, filledCircleY - arrowMargin - arrowH);
            CGContextClosePath(cr);
            CGContextSetFillColorWithColor(cr, self.circleColor.CGColor);
            CGContextFillPath(cr);
        }
        
    }
}


- (void)setItemStatus:(GestureItemStatus)itemStatus {
    _itemStatus = itemStatus;
    if (_itemStatus == GestureItemStatusNormal) {
        self.circleColor = CircleNormalColor;
    } else if (_itemStatus == GestureItemStatusSelected || _itemStatus == GestureItemStatusSelectedAndShowArrow) {
        self.circleColor = CircleSelectedColor;
    } else if (_itemStatus == GestureItemStatusError || _itemStatus == GestureItemStatusErrorAndShowArrow) {
        self.circleColor = CircleErrorColor;
    }
    [self setNeedsDisplay];
}

@end
