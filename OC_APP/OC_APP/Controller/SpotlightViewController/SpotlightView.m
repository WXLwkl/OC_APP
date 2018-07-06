//
//  SpotlightView.m
//  OC_APP
//
//  Created by xingl on 2018/6/12.
//  Copyright © 2018年 兴林. All rights reserved.
//

//item初始大小
#define k_itemW 10

#import "SpotlightView.h"
@interface SpotlightView ()

@property (nonatomic,strong) UIImageView *centerImgView;
@end

@implementation SpotlightView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.contentView.frame = CGRectMake(0, 0, frame.size.width, frame.size.width);
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = self.contentView.frame.size.width/2;
        [self addSubview:self.contentView];
        
        self.centerImgView.frame = CGRectMake(0, 0, frame.size.width - k_itemW, frame.size.width - k_itemW);
        self.centerImgView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        self.centerImgView.layer.masksToBounds = YES;
        self.centerImgView.layer.cornerRadius = self.centerImgView.frame.size.width/2;
        self.centerImgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.centerImgView.layer.borderWidth = 2;
        [self addSubview:self.centerImgView];
        
        //默认
        self.startRadian = 0.00;
        self.endRadian = 2 * M_PI;
        self.radius = frame.size.width/2 - k_itemW/2;
        self.multiple = 5.0;
        self.isOpen = NO;
        
        //添加手势
        //单击张开收起
        self.centerImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(centerImgViewAction)];
        [self.centerImgView addGestureRecognizer:tap];
    }
    return self;
}
#pragma mark -重写frame 固定为正方形（据width而定）
-(void)setFrame:(CGRect)frame{
    CGRect newFrame = frame;
    newFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.width);
    [super setFrame:newFrame];
}

- (void)setup {
    self.centerImgView.image = [UIImage imageNamed:self.centerImageName];
    
    // 添加items
    if (self.radius > self.frame.size.width / 2 - k_itemW / 2) {
        self.radius = self.frame.size.width / 2 - k_itemW / 2;
    }
    CGFloat w = k_itemW;
    CGFloat h = k_itemW;
    double allRadian = ABS(self.endRadian - self.startRadian);
    for (NSInteger i = 0; i < self.sourceArray.count; i++) {
        UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
        double radian = 0.00;
        if (allRadian < 2 * M_PI) {
            radian = allRadian / (self.sourceArray.count - 1) * i + self.startRadian;
        } else {
            radian = 2 * M_PI / self.sourceArray.count * i + self.startRadian;
        }
        CGFloat x = self.radius * cos(radian) + self.frame.size.width / 2;
        CGFloat y = self.radius * sin(radian) + self.frame.size.width / 2;
        item.frame = CGRectMake(0, 0, w, h);
        item.center = CGPointMake(x, y);
        
        NSDictionary *dic = self.sourceArray[i];
        [item setImage:[UIImage imageNamed:dic[@"icon"]] forState:UIControlStateNormal];
        [item setTag:(100 + i)];
        [item addTarget:self action:@selector(clickItemAction:) forControlEvents:UIControlEventTouchUpInside];
        item.alpha = 0.0;
        [self.contentView addSubview:item];
        [self.itemsArray addObject:item];
    }
}

- (void)clickItemAction:(UIButton *)button {
    [self centerImgViewAction];
    if ([self.delegate respondsToSelector:@selector(didClickItem:atIndex:)]) {
        [self.delegate didClickItem:self atIndex:button.tag - 100];
    }
}

- (void)centerImgViewAction {
    self.isOpen = !self.isOpen;
    if (self.isOpen) {
        [self show];
    } else {
        [self hide];
    }
}

- (void)show {
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformScale(self.transform, self.multiple, self.multiple);
        self.centerImgView.transform = CGAffineTransformScale(self.centerImgView.transform, 1 / self.multiple, 1 / self.multiple);
        [self.itemsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *item = (UIButton *)obj;
            item.alpha = 1.0;
        }];
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformIdentity;
        self.centerImgView.transform = CGAffineTransformIdentity;
        [self.itemsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *item = (UIButton *)obj;
            item.alpha = 0.0;
        }];
    }];
}


#pragma mark - getter
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    }
    return _contentView;
}
- (UIImageView *)centerImgView {
    if (!_centerImgView) {
        _centerImgView = [[UIImageView alloc] init];
        _centerImgView.contentMode = UIViewContentModeCenter;
    }
    return _centerImgView;
}
- (NSMutableArray *)itemsArray {
    if (!_itemsArray) {
        _itemsArray = [NSMutableArray array];
    }
    return _itemsArray;
}
#pragma mark - touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.isOpen) return;
    CGPoint point =[[touches anyObject] locationInView:self];
    self.startPoint = point;
    
    [[self superview] bringSubviewToFront:self];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.isOpen) return;
    //计算位移
    CGPoint point = [[touches anyObject] locationInView:self];
    float dx = point.x - self.startPoint.x;
    float dy = point.y - self.startPoint.y;
    
    CGPoint newCenter = CGPointMake(self.center.x + dx, self.center.y + dy);
    float halfx = CGRectGetMidX(self.bounds);
    newCenter.x = MAX(halfx, newCenter.x);
    newCenter.x = MIN(self.superview.bounds.size.width - halfx, newCenter.x);
    
    
    float halfy = CGRectGetMidY(self.bounds);
    newCenter.y = MAX(halfy, newCenter.y);
    newCenter.y = MIN(self.superview.bounds.size.height - halfy, newCenter.y);
    
    self.center = newCenter;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.isOpen) return;
    
    CGPoint center = self.center;
    if (center.x < self.superview.frame.size.width / 2) {
        center.x = self.frame.size.width / 2;
    }
    if (center.x >= self.superview.frame.size.width / 2) {
        center.x = self.superview.frame.size.width - self.frame.size.width / 2;
    }
    if (center.y < self.frame.size.height / 2) {
        center.y = self.frame.size.height / 2;
    }
    if (center.y >= self.superview.frame.size.height - self.frame.size.height / 2) {
        center.y = self.superview.frame.size.height - self.frame.size.height/2;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.center = center;
    }];
    //调整item的位置
    if (self.center.x < self.superview.frame.size.width/2) {
        [self changeItemsFrameWithSide:@"left"];
    }else{
        [self changeItemsFrameWithSide:@"right"];
    }
}

- (void)changeItemsFrameWithSide:(NSString *)side {
    if ([side isEqualToString:@"left"]) {
        self.startRadian = -M_PI / 2;
        self.endRadian = M_PI / 2;
    } else if ([side isEqualToString:@"right"]) {
        self.startRadian = M_PI / 2;
        self.endRadian = M_PI / 2 * 3;
    }
    
    if (self.radius > self.frame.size.width / 2 - k_itemW / 2) {
        self.radius = self.frame.size.width / 2 - k_itemW / 2;
    }
    CGFloat w = k_itemW;
    CGFloat h = k_itemW;
    double allRadian = ABS(self.endRadian - self.startRadian);
    for (NSInteger i = 0; i < self.itemsArray.count; i++) {
        UIButton *item;
        if ([side isEqualToString:@"left"]) {
            item = [self.contentView viewWithTag:(i + 100)];
        } else if ([side isEqualToString:@"right"]) {
            item = [self.contentView viewWithTag:(100 + self.itemsArray.count - 1 - i)];
        }
        double radian = 0.00;
        if (allRadian < 2 * M_PI) {
            radian = allRadian / (self.itemsArray.count - 1) * i + self.startRadian;
        } else {
            radian = 2 * M_PI / self.itemsArray.count * i + self.startRadian;
        }
        CGFloat x = self.radius * cos(radian) + self.frame.size.width/2;
        CGFloat y = self.radius * sin(radian) + self.frame.size.width/2;
        item.frame = CGRectMake(0, 0, w, h);
        item.center = CGPointMake(x, y);
    }
}

@end
