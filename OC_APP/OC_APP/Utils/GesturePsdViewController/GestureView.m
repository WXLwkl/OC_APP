//
//  GestureView.m
//  shoushi
//
//  Created by xingl on 2017/7/17.
//  Copyright © 2017年 xingl. All rights reserved.
//

#import "SecureManager.h"

#import "GestureView.h"
#import "GestureItem.h"

/// 圆圈九宫格边界大小
CGFloat const CircleViewMarginBorder = 5.0f;
CGFloat const CircleViewMarginNear = 30.0f;

/// 圆圈视图tag初始值
NSInteger const CircleViewBaseTag = 100;

///连线的宽度
CGFloat const LineWidth = 4.0f;

@interface GestureView ()

@property (nonatomic,strong) NSMutableArray *selectCircleArray;
@property (nonatomic,assign) CGPoint currentTouchPoint;
@property (nonatomic,assign) GestureItemStatus gestureItemStatus;
@property (nonatomic,strong) UIColor *lineColor;

@end

@implementation GestureView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

//初始化子视图
- (void)initSubViews {
    self.backgroundColor = [UIColor clearColor];
    
    for (NSInteger i = 0; i < 9; i ++) {
        GestureItem *item = [[GestureItem alloc] init];
        item.tag = CircleViewBaseTag + i;
        [self addSubview:item];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //手势视图的大小
    CGFloat squareWH = MIN(self.frame.size.width, self.frame.size.height);
    CGFloat offsetY = 0.0;
    CGFloat offsetX = 0.0;
    
    if (self.frame.size.width >= self.frame.size.height) {
        offsetX = (self.frame.size.width - self.frame.size.height) * 0.5;
    } else {
        offsetY = (self.frame.size.height - self.frame.size.width) * 0.5;
    }
    //小圆大小
    CGFloat circleWH = (squareWH - (CircleViewMarginBorder + CircleViewMarginNear) * 2.0) / 3.0;
    for (NSInteger i = 0; i < 9; i++) {
        GestureItem *item = [self viewWithTag:CircleViewBaseTag + i];
        
        NSInteger currentRow = i / 3;
        NSInteger currentColumn = i % 3;
        
        CGFloat circleX = CircleViewMarginBorder + (CircleViewMarginNear + circleWH) *currentColumn;
        CGFloat circleY = CircleViewMarginBorder + (CircleViewMarginNear + circleWH) * currentRow;
        item.frame = CGRectMake(circleX + offsetX, circleY + offsetY, circleWH, circleWH);
    }
    
}

#pragma mark - setter getter
- (NSMutableArray *)selectCircleArray {
    if (!_selectCircleArray) {
        _selectCircleArray = [NSMutableArray array];
    }
    return _selectCircleArray;
}

- (void)setGestureItemStatus:(GestureItemStatus)gestureItemStatus {
    _gestureItemStatus = gestureItemStatus;
    
    if (_gestureItemStatus == GestureItemStatusNormal) {
        self.lineColor = CircleNormalColor;
    } else if (_gestureItemStatus == GestureItemStatusSelected) {
        self.lineColor = CircleSelectedColor;
    } else if (_gestureItemStatus == GestureItemStatusError) {
        self.lineColor = CircleErrorColor;
    }
}

- (void)drawRect:(CGRect)rect {
    if (self.isHideGesturePath) {
        return;
    }
    
    self.clearsContextBeforeDrawing = YES;
    CGContextRef cr = UIGraphicsGetCurrentContext();
    
    //剪切，画线只能在圆外面
    CGContextAddRect(cr, rect);
    for (NSInteger i = 0; i < 9; i ++) {
        GestureItem *item = [self viewWithTag:CircleViewBaseTag + i];
        CGContextAddEllipseInRect(cr, item.frame);
    }
    CGContextEOClip(cr);
    
    //画线
    for (NSInteger i = 0; i < self.selectCircleArray.count; i++) {
        GestureItem *item = self.selectCircleArray[i];
        CGPoint circleCenter = item.center;
        if (i == 0) {
            CGContextMoveToPoint(cr, circleCenter.x, circleCenter.y);
        } else {
            CGContextAddLineToPoint(cr, circleCenter.x, circleCenter.y);
        }
    }
    
    [self.selectCircleArray enumerateObjectsUsingBlock:^(GestureItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
        if (item.itemStatus != GestureItemStatusError && item.itemStatus != GestureItemStatusErrorAndShowArrow) {
            CGContextAddLineToPoint(cr, self.currentTouchPoint.x, self.currentTouchPoint.y);
        }
    }];
    CGContextSetLineCap(cr, kCGLineCapRound);
    CGContextSetLineWidth(cr, LineWidth);
    [self.lineColor set];
    CGContextStrokePath(cr);
}

#pragma mark - Touch event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self cleanViews];
    [self checkCircleViewTouch:touches];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self checkCircleViewTouch:touches];
    [self setNeedsDisplay];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSMutableString *gestureCode = [NSMutableString string];
    for (GestureItem *item in self.selectCircleArray) {
        [gestureCode appendFormat:@"%ld",(long)(item.tag - CircleViewBaseTag)];
    }
    
    if (gestureCode.length > 0 && self.gestureResult != nil) {
        
        BOOL successGesture = self.gestureResult(gestureCode);
        
        if (successGesture) {
            
            [self cleanViews];
        } else {
            if (!self.isHideGesturePath) {
                for (NSInteger i = 0; i < self.selectCircleArray.count; i++) {
                    GestureItem *item = self.selectCircleArray[i];
                    BOOL showArrow = (self.isShowArrowDirection && i != self.selectCircleArray.count-1);
                    item.itemStatus = showArrow ? GestureItemStatusErrorAndShowArrow : GestureItemStatusError;
                    self.gestureItemStatus = GestureItemStatusError;
                    [self setNeedsDisplay];
                }
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self cleanViews];
            });
        }
    }
}

- (void)cleanViews {
    for (GestureItem *item in self.selectCircleArray) {
        item.itemStatus = GestureItemStatusNormal;
    }
    [self.selectCircleArray removeAllObjects];
    [self setNeedsDisplay];
}
- (void)checkCircleViewTouch:(NSSet *)touches {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    self.currentTouchPoint = point;
    for (NSInteger i = 0; i < 9; i ++) {
        GestureItem *item = [self viewWithTag:CircleViewBaseTag + i];
        if (CGRectContainsPoint(item.frame, point) && ![self.selectCircleArray containsObject:item]) {
            if (!self.isHideGesturePath) {
                item.itemStatus = GestureItemStatusSelected;
                self.gestureItemStatus = GestureItemStatusSelected;
                if (self.selectCircleArray.count > 0 && self.isShowArrowDirection) {
                    GestureItem *lastSelectItem = [self.selectCircleArray lastObject];
                    CGFloat x1 = item.center.x;
                    CGFloat y1 = item.center.y;
                    CGFloat x2 = lastSelectItem.center.x;
                    CGFloat y2 = lastSelectItem.center.y;
                    CGFloat angle = atan2(y1-y2, x1-x2) + M_PI_2;
                    lastSelectItem.angle = angle;
                    lastSelectItem.itemStatus = GestureItemStatusSelectedAndShowArrow;
                }
            }
            [self.selectCircleArray addObject:item];
            break;
        }
    }
}
@end
