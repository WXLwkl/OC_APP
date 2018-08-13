//
//  XLSlider.m
//  OC_APP
//
//  Created by xingl on 2018/8/7.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "XLSlider.h"

#define SLIDER_X_BOUND 30
#define SLIDER_Y_BOUND 40

@interface XLSlider ()
/**lastBounds*/
@property (nonatomic,assign) CGRect lastBounds;

@end


@implementation XLSlider

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup {
    UIImage *thumbImage = [UIImage imageNamed:@"Round"];
    [self setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [self setThumbImage:thumbImage forState:UIControlStateNormal];
}
// 控制slider的宽和高，这个方法真正的改变slider滑道的高度
- (CGRect)trackRectForBounds:(CGRect)bounds {
    [super trackRectForBounds:bounds];
    return CGRectMake(bounds.origin.x, bounds.origin.y, CGRectGetWidth(bounds), 2);
}
// 修改滑块位置
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    rect.origin.x = rect.origin.x - 6;
    rect.size.width = rect.size.width + 12;
    CGRect result = [super thumbRectForBounds:bounds trackRect:rect value:value];
    // 记录最终的frame
    _lastBounds = result;
    return result;
}
// 检查点击事件点击范围是否能够交给self处理
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // 调用父类方法,找到能够处理event的view
    UIView *result = [super hitTest:point withEvent:event];
    if (result != self) {
        /*如果这个view不是self,我们给slider扩充一下响应范围,
         这里的扩充范围数据就可以自己设置了
         */
        if ((point.y >= -15) && (point.y < (_lastBounds.size.height + SLIDER_Y_BOUND)) && (point.x >= 0 && point.x < CGRectGetWidth(self.bounds))) {
            result = self;
        }
    }
    return result;
}
// 检查是点击事件的点是否在slider范围内
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL result = [super pointInside:point withEvent:event];
    if (!result) {
        //同理,如果不在slider范围类,扩充响应范围
        if ((point.x >= (_lastBounds.origin.x - SLIDER_X_BOUND)) && (point.x <= (_lastBounds.origin.x + _lastBounds.size.width + SLIDER_X_BOUND))
            && (point.y >= -SLIDER_Y_BOUND) && (point.y < (_lastBounds.size.height + SLIDER_Y_BOUND)))  {
            // 在扩充范围内，返回YES
            result = YES;
        }
    }
    return result;
}

@end
