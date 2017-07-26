//
//  GesturePreviewView.m
//  shoushi
//
//  Created by xingl on 2017/7/18.
//  Copyright © 2017年 xingl. All rights reserved.
//
#import "SecureManager.h"
#import "GesturePreviewView.h"

@interface GesturePreviewView ()

@property (nonatomic, strong) NSMutableArray *numberArray;

@end

@implementation GesturePreviewView


- (NSMutableArray *)numberArray {
    if (!_numberArray) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:9];
        for (NSInteger i = 0; i < 9; i++) {
            NSNumber *n = [NSNumber numberWithInteger:0];
            [array addObject:n];
        }
        _numberArray = array;
    }
    return _numberArray;
}


- (void)drawRect:(CGRect)rect {
    CGContextRef cr = UIGraphicsGetCurrentContext();
    
    CGFloat squareWH = MIN(rect.size.width, rect.size.height);
    CGFloat marginBorder = 3.0;
    CGFloat marginNear = 3.0;
    CGFloat circleWH = (squareWH - (marginBorder+marginNear) * 2.0) / 3.0;
    
    for (NSInteger i = 0; i < 9; i++) {
        NSInteger currentRow = i / 3;
        NSInteger currentColumn = i % 3;
        
        CGFloat circleX = marginBorder + (marginNear + circleWH) * currentColumn;
        CGFloat circleY = marginBorder + (marginNear + circleWH) * currentRow;
        
        CGRect circleFrame = CGRectMake(circleX, circleY, circleWH, circleWH);
        
        CGContextAddEllipseInRect(cr, circleFrame);
        [CircleNormalColor set];
        NSNumber *n = self.numberArray[i];
        if (n.integerValue == 1) {
            CGContextFillPath(cr);
        } else {
            CGContextSetLineWidth(cr, 1.0);
            CGContextStrokePath(cr);
        }
    }
}

- (void)setGestureCode:(NSString *)gestureCode {
    _gestureCode = gestureCode;
    
    self.numberArray = nil;
    for (NSInteger i = 0; i < gestureCode.length; i++) {
        NSString *subStr = [gestureCode substringWithRange:NSMakeRange(i, 1)];
        NSInteger subInt = subStr.integerValue;
        [self.numberArray replaceObjectAtIndex:subInt withObject:[NSNumber numberWithInteger:1]];
    }
    [self setNeedsDisplay];
}

@end
