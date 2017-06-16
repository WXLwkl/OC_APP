//
//  ClickTextView.m
//  OC_APP
//
//  Created by xingl on 2017/6/12.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "ClickTextView.h"

@interface ClickTextView ()
#define kCoverViewTag 111

@property (nonatomic, strong) NSMutableArray *rectsArray;
@property (nonatomic, strong) NSMutableAttributedString *content;

@end

@implementation ClickTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setEditable:NO];
        [self setScrollEnabled:NO];
    }
    return self;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    self.content = [[NSMutableAttributedString alloc] initWithString:text];
    [self.content addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, text.length)];
    if (self.textColor) {
        [self.content addAttribute:NSForegroundColorAttributeName value:self.textColor range:NSMakeRange(0, text.length)];
    }
}

- (void)setUnderlineTextWithUnderlineText:(NSString *)underlineText withUnderlineColor:(UIColor *)color withClickCoverColor:(UIColor *)coverColor withBlock:(ClickTextViewPartBlock)block {
    
    NSRange underlineTextRange = [self.text rangeOfString:underlineText];
    
    if (self.text.length < underlineTextRange.location+underlineTextRange.length) {
        return;
    }
//    设置下划线
    [self.content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:underlineTextRange];
//    设置文字颜色
    if (color) {
        [self.content addAttribute:NSForegroundColorAttributeName value:color range:underlineTextRange];
    }
    self.attributedText = self.content;
    
//    设置下划线文字的点击事件
    self.selectedRange = underlineTextRange;
//    获取选中范围内的矩形框
    NSArray *selectionRects = [self selectionRectsForRange:self.selectedTextRange];
//    清空选中范围
    self.selectedRange = NSMakeRange(0, 0);
//    可能会点击的范围的数组
    NSMutableArray *selectedArray = [NSMutableArray array];
    for (UITextSelectionRect *selectionRect in selectionRects) {
        CGRect rect = selectionRect.rect;
        if (rect.size.width == 0 || rect.size.height == 0) {
            continue;
        }
//        将有用的信息打包<存放到字典中>存储到数组中
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//        存储文字对应的frame，一段文字可能会有两个甚至多个frame，考虑到文字的换行文字
        [dic setObject:[NSValue valueWithCGRect:rect] forKey:@"rect"];
//        存储下划线对应的文字
        [dic setObject:[self.text substringWithRange:underlineTextRange] forKey:@"content"];
//        存储响应的回调block
        [dic setObject:block forKey:@"block"];
//        存储对应的点击效果背景颜色
        [dic setValue:coverColor forKey:@"coverColor"];
        [selectedArray addObject:dic];
    }
//    将可能点击的范围的数组存储到总的数组中
    [self.rectsArray addObject:selectedArray];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    获取触摸对象
    UITouch *touch = [touches anyObject];
//    触摸点
    CGPoint point = [touch locationInView:self];
    
    NSArray *selectedArray = [self touchingSpecialWithPoint:point];
    
    for (NSDictionary *dic in selectedArray) {
        if (dic && dic[@"coverColor"]) {
            UIView *cover = [[UIView alloc] init];
            cover.backgroundColor = dic[@"coverColor"];
            cover.frame = [dic[@"rect"] CGRectValue];
            cover.layer.cornerRadius = 5;
            cover.tag = kCoverViewTag;
            [self insertSubview:cover atIndex:0];
        }
    }
    if (selectedArray.count) {
//        如果说有点击效果的话，加个延时，展示一下点击效果，如果没有，直接回调
        NSDictionary *dic = [selectedArray firstObject];
        ClickTextViewPartBlock block = dic[@"block"];
        if (dic[@"coverColor"]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                block(dic[@"content"]);
            });
        } else {
            block(dic[@"content"]);
        }
    }
}

- (NSArray *)touchingSpecialWithPoint:(CGPoint)point {
    for (NSArray *selectedArray in self.rectsArray) {
        for (NSDictionary *dic in selectedArray) {
            CGRect myRect = [dic[@"rect"] CGRectValue];
            if (CGRectContainsPoint(myRect, point)) {
                return selectedArray;
            }
        }
    }
    return nil;
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (UIView *subView in self.subviews) {
            if (subView.tag == kCoverViewTag) {
                [subView removeFromSuperview];
            }
        }
    });
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    for (UIView *subView in self.subviews) {
        if (subView.tag == kCoverViewTag) {
            [subView removeFromSuperview];
        }
    }
}

- (NSMutableArray *)rectsArray
{
    if (_rectsArray == nil) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        _rectsArray = array;
    }
    return _rectsArray;
}

@end
