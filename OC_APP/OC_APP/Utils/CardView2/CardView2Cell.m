//
//  CardView2Cell.m
//  OC_APP
//
//  Created by xingl on 2018/4/12.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "CardView2Cell.h"

@interface CardView2Cell ()

@property (nonatomic, assign) CGPoint originalCenter;
@property (nonatomic, assign) CGFloat currentAngle;
@property (nonatomic, assign) BOOL isLeft;

@end

@implementation CardView2Cell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [self init];
    [self setValue:reuseIdentifier forKey:@"reuseIdentifier"];
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.originalCenter = CGPointMake(frame.size.width / 2.0, frame.size.height / 2.0);
}

- (void)initView {
    [self addPanGest];
    [self configLayer];
}

- (void)addPanGest {
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestHandle:)];
    [self addGestureRecognizer:pan];
}
- (void)configLayer {
    self.layer.cornerRadius = 8.0f;
    self.layer.masksToBounds = YES;
}

- (void)panGestHandle:(UIPanGestureRecognizer *)panGesture {
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint movePoint = [panGesture translationInView:self];
        _isLeft = movePoint.x < 0;
        self.center = CGPointMake(self.center.x + movePoint.x, self.center.y + movePoint.y);
        
        CGFloat angle = (self.center.x - self.frame.size.width / 2.0) / self.frame.size.width / 4.0;
        _currentAngle = angle;
        self.transform = CGAffineTransformMakeRotation(-angle);
        [panGesture setTranslation:CGPointZero inView:self];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(cardItemViewDidMoveRate:anmate:)]) {
            CGFloat rate = fabs(angle)/0.15 > 1 ? 1 :fabs(angle)/0.15;
            [self.delegate cardItemViewDidMoveRate:rate anmate:NO];
        }
    } else if (panGesture.state == UIGestureRecognizerStateEnded) {
        CGPoint vel = [panGesture velocityInView:self];
        if (vel.x > 800 || vel.x < -800) {
            [self remove];
            return;
        }
        if (self.frame.origin.x + self.frame.size.width > 150 && self.frame.origin.x < self.frame.size.width - 150) {
            [UIView animateWithDuration:0.5 animations:^{
                self.center = _originalCenter;
                self.transform = CGAffineTransformMakeRotation(0);
                if ([self.delegate respondsToSelector:@selector(cardItemViewDidMoveRate:anmate:)]) {
                    [self.delegate cardItemViewDidMoveRate:0 anmate:YES];
                }
            }];
        } else {
            [self remove];
        }
    }
}


- (void)remove {
    [self removeWithLeft:_isLeft];
}
- (void)removeWithLeft:(BOOL)left {
    if ([self.delegate respondsToSelector:@selector(cardItemViewDidMoveRate:anmate:)]) {
        [self.delegate cardItemViewDidMoveRate:1 anmate:YES];
    }
    [UIView animateWithDuration:0.2 animations:^{
        if (!left) {
            self.center = CGPointMake([UIScreen mainScreen].bounds.size.width+self.frame.size.width, self.center.y + _currentAngle *self.frame.size.height + (_currentAngle == 0 ? 100 : 0));
        } else {
            self.center = CGPointMake(-self.frame.size.width, self.center.y - _currentAngle * self.frame.size.height + (_currentAngle == 0 ? 100 : 0));
        }
    } completion:^(BOOL finished) {
        if (finished) {
            if ([self.delegate respondsToSelector:@selector(cardItemViewDidRemoveFromSuperView:)]) {
                [self.delegate cardItemViewDidRemoveFromSuperView:self];
            }
        }
    }];
}
@end
