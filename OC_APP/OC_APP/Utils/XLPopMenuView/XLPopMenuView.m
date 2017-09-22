//
//  XLPopMenuView.m
//  OC_APP
//
//  Created by xingl on 2017/8/3.
//  Copyright © 2017年 兴林. All rights reserved.
//


#define Duration 0.5
#define KeyPath @"transform.scale"

#define SYSTEM_VERSION_LESS_THAN(v)                                            \
([[[UIDevice currentDevice] systemVersion] compare:v                         \
options:NSNumericSearch] ==       \
NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)                                \
([[[UIDevice currentDevice] systemVersion] compare:v                         \
options:NSNumericSearch] !=       \
NSOrderedDescending)

#import "XLPopMenuView.h"

#import <AudioToolbox/AudioToolbox.h>
#import <pop/POP.h>


@interface XLPopMenuView ()

@property (nonatomic, weak) UIView *superView;
@property (nonatomic, weak) UIView *backgroundView;
@property (nonatomic, weak) UIButton *disappearButton;
@property (nonatomic, weak) UIView *bottomView;

@property (nonatomic, assign) BOOL isOpen;

@end

@implementation XLPopMenuView

static XLPopMenuView *popMenuObject = nil;

static BOOL isAlpha = false;

+ (instancetype)allocWithZone:(struct _NSZone*)zone {
    
    return [XLPopMenuView sharedPopMenuManager];
}

+ (instancetype)sharedPopMenuManager {
    
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        
        popMenuObject = [[super allocWithZone:NULL]init];
        
    });
    return popMenuObject;
}
+(instancetype)alloc{
    
    return [XLPopMenuView sharedPopMenuManager];
}

- (id)copyWithZone:(NSZone*)zone {
    
    return [XLPopMenuView sharedPopMenuManager];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setFrame:[UIScreen mainScreen].bounds];
        _animationType = PopAnimationTypeSina;
        _backgroundType = PopBackgroundTypeLightBlur;
        _automaticIdentificationColor = false;
        _popMenuSpeed = 10.f;
    }
    return self;
}
NSString* const XLPopMenuViewWillShowNotification = @"XLPopMenuViewWillShowNotification";
NSString* const XLPopMenuViewDidShowNotification = @"XLPopMenuViewDidShowNotification";
NSString* const XLPopMenuViewWillHideNotification = @"XLPopMenuViewWillHideNotification";
NSString* const XLPopMenuViewDidHideNotification = @"XLPopMenuViewDidHideNotification";

- (void)initUIsize
{
//    [[UIButton appearance] setExclusiveTouch:true];
    UIView* bottomView = [_backgroundView viewWithTag:2];
    if (!bottomView) {
        bottomView = [UIView new];
        [_backgroundView addSubview:bottomView];
        UIView *superView = [UIView new];
        superView.frame = _backgroundView.frame;
        [_backgroundView addSubview:superView];
        _superView = superView;
        [bottomView setTag:2];
        _bottomView = bottomView;
    }
    bottomView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.bounds) - 52, kScreenWidth, 52);
    [bottomView setBackgroundColor:[UIColor colorWithWhite:1.f alpha:0.90f]];
    
    if (_backgroundType == PopBackgroundTypeDarkBlur || _backgroundType == PopBackgroundTypeDarkTranslucent || _backgroundType == PopBackgroundTypeGradient) {
        [bottomView setBackgroundColor:[UIColor colorWithRed:90.f / 225.f green:90.f / 225.f blue:90.f / 225.f alpha:0.9f]];
    }
    
    UIButton* disappearButton = [_backgroundView viewWithTag:3];
    if (!disappearButton) {
        disappearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        disappearButton.adjustsImageWhenHighlighted = NO;
        [_backgroundView addSubview:disappearButton];
        disappearButton.tag = 3;
        _disappearButton = disappearButton;
    }
    [disappearButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_background_icon_add"] forState:UIControlStateNormal];
    [disappearButton addTarget:self  action:@selector(closeMenu) forControlEvents:UIControlEventTouchUpInside];
    CGFloat CANCELw = 28;
    disappearButton.bounds = CGRectMake(0, 0, CANCELw, CANCELw);
    disappearButton.center = bottomView.center;
}

- (void)openMenu {
    [self addNotificationAtNotificationName:XLPopMenuViewWillShowNotification];
    UIView* backgroundView = [self effectsViewWithType:_backgroundType];
    _backgroundView = backgroundView;
    if (_topView) {
        [_backgroundView addSubview:_topView];
    }
    [self addSubview:_backgroundView];
    [self initUIsize];
    [self backgroundAnimate];
    [self show];
}
- (void)closeMenu
{
    //UIWindow *window = (id)[self getMainView];
    [self addNotificationAtNotificationName:XLPopMenuViewWillHideNotification];
    __weak XLPopMenuView* weakView = self;
    [self disappearPopMenuViewAnimate];
    [UIView animateWithDuration:0.3 animations:^{
        weakView.bottomView.backgroundColor = [UIColor clearColor];
        weakView.disappearButton.transform = CGAffineTransformMakeRotation(0);
        [weakView.disappearButton setAlpha:0.1f];
    }];
    double d = (weakView.items.count * 0.04) + 0.3;
    [UIView animateKeyframesWithDuration:Duration delay:d options:0 animations:^{
        if (isAlpha) {
            [weakView.backgroundView setAlpha:0];
        }else{
            UIVisualEffectView *effect = (id)_backgroundView;
            effect.effect = nil;
            _topView.alpha = 0;
        }
    }
                              completion:^(BOOL finished) {
                                  [weakView addNotificationAtNotificationName:XLPopMenuViewDidHideNotification];
                                  [weakView.backgroundView removeFromSuperview];
                                  weakView.isOpen = false;
                                  [self removeFromSuperview];
                              }];
}
- (void)backgroundAnimate
{
    _topView.alpha = 0.0f;
    __weak XLPopMenuView* weakView = self;
    if ([_backgroundView isKindOfClass:[UIVisualEffectView class]]) {
        UIVisualEffectView *effect = (id)_backgroundView;
        effect.effect = nil;
    }
    UIBlurEffect* effectBlur = nil;
    switch (_backgroundType) {
            case PopBackgroundTypeDarkBlur:
                effectBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
                break;
            case PopBackgroundTypeDarkTranslucent:
            
                break;
            case PopBackgroundTypeLightBlur:
                effectBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
                break;
            case PopBackgroundTypeGradient:
                break;
            case PopBackgroundTypeLightTranslucent:
                break;
    }
    [UIView animateWithDuration:Duration animations:^{
        if (isAlpha) {
            [weakView.backgroundView setAlpha:1];
        }else{
            UIVisualEffectView *effect = (id)_backgroundView;
            effect.effect = effectBlur;
            _topView.alpha = 1;
        }
        weakView.disappearButton.transform = CGAffineTransformMakeRotation((M_PI / 2) / 2);
    }];
    [self showItemAnimate];
}

- (void)showItemAnimate
{
    __weak XLPopMenuView* weakView = self;
    double d = (self.items.count * 0.04) + 0.3;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(d * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakView addNotificationAtNotificationName:XLPopMenuViewDidShowNotification];
    });
    [_items enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
        PopMenuModel* model = obj;
        model.automaticIdentificationColor = weakView.automaticIdentificationColor;
        [model.customView removeFromSuperview];
        model.customView.alpha = 0.0f;
        [weakView.superView addSubview:model.customView];
        
        CGRect toRect;
        CGRect fromRect;
        double dy = idx * 0.035f;
        CFTimeInterval delay = dy + CACurrentMediaTime();
        
        switch (_animationType) {
                case PopAnimationTypeSina:
                toRect = [weakView getFrameAtIndex:idx];
                fromRect = CGRectMake(CGRectGetMinX(toRect),
                                      CGRectGetMinY(toRect) + 130,
                                      toRect.size.width,
                                      toRect.size.height);
                break;
                case PopAnimationTypeCenter:
                toRect = [weakView getFrameAtIndex:idx];
                fromRect = CGRectMake(CGRectGetMidX(weakView.frame) - CGRectGetWidth(fromRect) / 2,
                                      (CGRectGetMinY(toRect) + (kScreenHeight - CGRectGetMinY(toRect))) - 25,
                                      toRect.size.width,
                                      toRect.size.height);
                break;
                case PopAnimationTypeViscous:
                toRect = [weakView getFrameAtIndex:idx];
                fromRect = CGRectMake(CGRectGetMinX(toRect),
                                      CGRectGetMinY(toRect) + (kScreenHeight - CGRectGetMinY(toRect)),
                                      toRect.size.width,
                                      toRect.size.height);
                break;
                case PopAnimationTypeLeftAndRight:
                toRect = [weakView getFrameAtIndex:idx];
                CGFloat d = (idx % 2) == 0 ? 0:CGRectGetWidth(toRect);
                CGFloat x = ((idx % 2) * kScreenHeight) - d;
                fromRect = CGRectMake(x,
                                      CGRectGetMinY(toRect) + (kScreenHeight - CGRectGetMinY(toRect)),
                                      toRect.size.width,
                                      toRect.size.height);
                break;
        }
        [self classAnimationWithfromRect:fromRect
                                  toRect:toRect
                                  deleay:delay
                                   views:model.customView
                                  isHidd:false];
        
        PopMenuButton* button = (id)model.customView;
        [button addTarget:self action:@selector(selectedFunc:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)classAnimationWithfromRect:(CGRect)age1
                            toRect:(CGRect)age2
                            deleay:(CFTimeInterval)age3
                             views:(UIView*)age4
                            isHidd:(BOOL)age5
{
    __weak XLPopMenuView* weakView = self;
    if (_animationType == PopAnimationTypeSina) {
        
        [self startSinaAnimationfromValue:age1
                                  toValue:age2
                                    delay:age3
                                   object:age4
                          completionBlock:^(BOOL CompletionBlock) {
                              [weakView addTap];
                          }
                              hideDisplay:age5];
    }
    else if (_animationType == PopAnimationTypeViscous) {
        
        [self startViscousAnimationFormValue:age1
                                     ToValue:age2
                                       Delay:age3
                                      Object:age4
                             CompletionBlock:^(BOOL CompletionBlock) {
                                 [weakView addTap];
                             }
                                 HideDisplay:age5];
    }
    else if (_animationType == PopAnimationTypeCenter) {
        
        [self startSinaAnimationfromValue:age1
                                  toValue:age2
                                    delay:age3
                                   object:age4
                          completionBlock:^(BOOL CompletionBlock) {
                              [weakView addTap];
                          }
                              hideDisplay:age5];
    } else if (_animationType == PopAnimationTypeLeftAndRight) {
        [self startSinaAnimationfromValue:age1
                                  toValue:age2
                                    delay:age3
                                   object:age4
                          completionBlock:^(BOOL CompletionBlock) {
                              [weakView addTap];
                          }
                              hideDisplay:age5];
    }
}

- (void)addTap
{
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(closeMenu)];
    [_backgroundView addGestureRecognizer:tap];
    _isOpen = true;
}

- (CGFloat)maxItemsMinY
{
    CGRect rect = [self getFrameAtIndex:0];
    return CGRectGetMinY(rect);
}

- (CGRect)getFrameAtIndex:(NSUInteger)index;
{
    NSInteger column = 3;
    CGFloat buttonViewWidth = MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) / column;
    CGFloat buttonViewHeight = (buttonViewWidth - 10);
    CGFloat margin = (self.frame.size.width - column * buttonViewWidth) / (column + 1);
    NSInteger colnumIndex = index % column;
    NSInteger rowIndex = index / column;
    NSUInteger toRows = (_items.count / column);
    
    CGFloat toHeight = toRows * buttonViewHeight;
    
    CGFloat buttonViewX = (colnumIndex + 1) * margin + colnumIndex * buttonViewWidth;
    CGFloat buttonViewY = ((rowIndex + 1) * margin + rowIndex * buttonViewHeight) + (kScreenHeight - toHeight) - 150;
    CGRect rect = CGRectMake(buttonViewX, buttonViewY, buttonViewWidth, buttonViewHeight);
    return rect;
}

- (void)disappearPopMenuViewAnimate
{
    __weak XLPopMenuView* weakView = self;
    [_items enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
        double d = weakView.items.count * 0.04;
        double dy = d - idx * 0.04;
        PopMenuModel* model = obj;
        CFTimeInterval delay = dy + CACurrentMediaTime();
        
        CGRect toRect = CGRectZero;
        CGRect fromRect;
        
        switch (_animationType) {
                case PopAnimationTypeSina:
                
                fromRect = [weakView getFrameAtIndex:idx];
                toRect = CGRectMake(CGRectGetMinX(fromRect),
                                    kScreenHeight,
                                    CGRectGetWidth(fromRect),
                                    CGRectGetHeight(fromRect));
                
                break;
                case PopAnimationTypeCenter:
                
                fromRect = [weakView getFrameAtIndex:idx];
                toRect = CGRectMake(CGRectGetMidX(weakView.frame) - CGRectGetWidth(fromRect) / 2,
                                    (CGRectGetMinY(toRect) + (kScreenHeight - CGRectGetMinY(toRect))) - 25,
                                    fromRect.size.width,
                                    fromRect.size.height);
                
                break;
                case PopAnimationTypeViscous:
                
                fromRect = [weakView getFrameAtIndex:idx];
                toRect = CGRectMake(CGRectGetMinX(fromRect),
                                    CGRectGetMinY(fromRect) + (kScreenHeight - CGRectGetMinY(fromRect)),
                                    fromRect.size.width,
                                    fromRect.size.height);
                
                break;
                case PopAnimationTypeLeftAndRight:
                fromRect = [weakView getFrameAtIndex:idx];
                CGFloat d = (idx % 2) == 0 ? 0:CGRectGetWidth(fromRect);
                CGFloat x = ((idx % 2) * kScreenWidth) - d;
                
                toRect = CGRectMake(x,
                                    CGRectGetMinY(fromRect) + (kScreenHeight - CGRectGetMinY(fromRect)),
                                    fromRect.size.width,
                                    fromRect.size.height);
                break;
        }
        [self classAnimationWithfromRect:fromRect
                                  toRect:toRect
                                  deleay:delay
                                   views:model.customView
                                  isHidd:true];
    }];
}

- (__kindof UIView*)effectsViewWithType:(PopBackgroundType)type {
    if (_backgroundView) {
        [_backgroundView removeFromSuperview];
        _backgroundView = nil;
    }
    isAlpha = true;
    UIView* effectView = nil;
    UIBlurEffect* effectBlur = nil;
    CAGradientLayer* gradientLayer = nil;
    switch (type) {
            case PopBackgroundTypeDarkBlur:
                effectBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
                break;
            case PopBackgroundTypeDarkTranslucent:
            
                break;
            case PopBackgroundTypeLightBlur:
                effectBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
                break;
            case PopBackgroundTypeLightTranslucent:
            
                break;
            case PopBackgroundTypeGradient:
                gradientLayer = [self gradientLayerWithColor1:[UIColor colorWithWhite:1 alpha:0.1f] AtColor2:[UIColor colorWithWhite:0.0f alpha:1.0f]];
                break;
    }
    
    if (effectBlur) {
        effectView = [[UIVisualEffectView alloc] initWithEffect:effectBlur];
        isAlpha = false;
    }
    else {
        effectView = [UIView new];
        if (gradientLayer) {
            [effectView.layer addSublayer:gradientLayer];
        }
        else {
            effectView.backgroundColor = [UIColor colorWithWhite:(CGFloat)(type == PopBackgroundTypeLightTranslucent) alpha:0.7];
        }
    }
    effectView.frame = self.bounds;
    if (isAlpha) effectView.alpha = 0.0f;
    _superView.frame = _backgroundView.bounds;
    return effectView;
}

- (CAGradientLayer*)gradientLayerWithColor1:(UIColor*)color1 AtColor2:(UIColor*)color2 {
    CAGradientLayer* layer = [CAGradientLayer new];
    layer.colors = @[ (__bridge id)color1.CGColor, (__bridge id)color2.CGColor ];
    layer.startPoint = CGPointMake(0.5f, -0.5);
    layer.endPoint = CGPointMake(0.5, 1);
    layer.frame = self.bounds;
    return layer;
}
- (void)selectedFunc:(PopMenuButton*)sender
{
    //    sender.layer.cornerRadius = CGRectGetWidth(sender.frame)/2;
    //    sender.backgroundColor = [UIColor redColor];
    //UIWindow *window = (id)[self getMainView];
    __weak XLPopMenuView* weakView = self;
    for (PopMenuModel *obj in _items) {
        PopMenuModel* model = obj;
        PopMenuButton* button = (id)model.customView;
        if (sender == button) {
            [sender selectdAnimation];
        }else{
            [button cancelAnimation];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [model performSelector:@selector(_obj)];
        });
    }
    
    NSUInteger idx = [_items indexOfObject:sender.model];
    
    if (sender.model.transitionType == PopMenuTransitionTypeCustomizeApi) {
        sender.block = ^(PopMenuButton *btn){
            //[self.backgroundView insertSubview:btn atIndex:[self.backgroundView subviews].count];
            if ([weakView.delegate respondsToSelector:@selector(popMenuView:didSelectItemAtIndex:)]) {
                [weakView.delegate popMenuView:weakView didSelectItemAtIndex:idx];
            }
            [weakView close];
        };
    }else{
        if ([weakView.delegate respondsToSelector:@selector(popMenuView:didSelectItemAtIndex:)]) {
            [weakView.delegate popMenuView:weakView didSelectItemAtIndex:idx];
        }
        [self close];
    }
}

- (void)close {
    __weak XLPopMenuView* weakView = self;
    [UIView animateWithDuration:0.5 delay:0.0 options:0 animations:^{
        _superView.alpha=0.0;
        if (isAlpha) {
            [weakView.backgroundView setAlpha:0];
        }else{
            UIVisualEffectView *effect = (id)_backgroundView;
            effect.effect = nil;
            _topView.alpha = 0;
        }
        weakView.bottomView.backgroundColor = [UIColor clearColor];
        weakView.disappearButton.transform = CGAffineTransformMakeRotation(0);
        [weakView.disappearButton setAlpha:0.1f];
    } completion:^(BOOL finished) {
        [weakView.backgroundView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)setDataSource:(NSArray*)dataSource
{
    NSMutableArray* tepmArr = [NSMutableArray arrayWithCapacity:MIN(9, dataSource.count)];
    [dataSource enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
        if (idx == 9) {
            *stop = true;
            return;
        }
        [tepmArr addObject:obj];
    }];
    _items = [NSArray arrayWithArray:tepmArr];
}

- (void)startViscousAnimationFormValue:(CGRect)fromValue
                               ToValue:(CGRect)toValue
                                 Delay:(CFTimeInterval)delay
                                Object:(UIView*)obj
                       CompletionBlock:(void (^)(BOOL CompletionBlock))completionBlock
                           HideDisplay:(BOOL)hideDisplay
{
    CGFloat toV, fromV;
    CGFloat springBounciness = 8.f;
    toV = !hideDisplay;
    fromV = hideDisplay;
    
    if (hideDisplay) {
        POPBasicAnimation* basicAnimationCenter = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        basicAnimationCenter.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(toValue), CGRectGetMidY(toValue))];
        basicAnimationCenter.fromValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(fromValue), CGRectGetMidY(fromValue))];
        basicAnimationCenter.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        basicAnimationCenter.beginTime = delay;
        basicAnimationCenter.duration = 0.18;
        [obj pop_addAnimation:basicAnimationCenter forKey:basicAnimationCenter.name];
        
        POPBasicAnimation* basicAnimationScale = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleX];
        basicAnimationScale.removedOnCompletion = YES;
        basicAnimationScale.beginTime = delay;
        basicAnimationScale.toValue = @(0.7);
        basicAnimationScale.fromValue = @(1);
        basicAnimationScale.duration = 0.18;
        basicAnimationScale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [obj.layer pop_addAnimation:basicAnimationScale forKey:basicAnimationScale.name];
    }
    else {
        POPSpringAnimation* basicAnimationCenter = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
        basicAnimationCenter.beginTime = delay;
        basicAnimationCenter.springSpeed = _popMenuSpeed;
        basicAnimationCenter.springBounciness = springBounciness;
        basicAnimationCenter.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(toValue), CGRectGetMidY(toValue))];
        basicAnimationCenter.fromValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(fromValue), CGRectGetMidY(fromValue))];
        
        POPBasicAnimation* basicAnimationScale = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleX];
        basicAnimationScale.beginTime = delay;
        basicAnimationScale.toValue = @(1);
        basicAnimationScale.fromValue = @(0.7);
        basicAnimationScale.duration = 0.3f;
        basicAnimationScale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [obj.layer pop_addAnimation:basicAnimationScale forKey:basicAnimationScale.name];
        
        POPBasicAnimation* basicAnimationAlpha = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
        basicAnimationAlpha.removedOnCompletion = YES;
        basicAnimationAlpha.duration = 0.1f;
        basicAnimationAlpha.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        basicAnimationAlpha.beginTime = delay;
        basicAnimationAlpha.toValue = @(toV);
        basicAnimationAlpha.fromValue = @(fromV);
        
        [obj pop_addAnimation:basicAnimationAlpha forKey:basicAnimationAlpha.name];
        [obj pop_addAnimation:basicAnimationCenter forKey:basicAnimationCenter.name];
        [basicAnimationCenter setCompletionBlock:^(POPAnimation* spring, BOOL Completion) {
            if (!completionBlock) {
                return;
            }
            if (Completion) {
                completionBlock(Completion);
            }
        }];
    }
}

- (void)startSinaAnimationfromValue:(CGRect)fromValue
                            toValue:(CGRect)toValue
                              delay:(CFTimeInterval)delay
                             object:(UIView*)obj
                    completionBlock:(void (^)(BOOL CompletionBlock))completionBlock
                        hideDisplay:(BOOL)hideDisplay
{
    
    CGFloat toV, fromV;
    CGFloat springBounciness = 10.f;
    toV = !hideDisplay;
    fromV = hideDisplay;
    
    if (hideDisplay) {
        POPBasicAnimation* basicAnimationCenter = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        basicAnimationCenter.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(toValue), CGRectGetMidY(toValue))];
        basicAnimationCenter.fromValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(fromValue), CGRectGetMidY(fromValue))];
        basicAnimationCenter.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        basicAnimationCenter.beginTime = delay;
        basicAnimationCenter.duration = 0.18;
        [obj pop_addAnimation:basicAnimationCenter forKey:basicAnimationCenter.name];
        
        POPBasicAnimation* basicAnimationScale = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        basicAnimationScale.removedOnCompletion = YES;
        basicAnimationScale.beginTime = delay;
        basicAnimationScale.toValue = [NSValue valueWithCGPoint:CGPointMake(0.7, 0.7)];
        basicAnimationScale.fromValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
        basicAnimationScale.duration = 0.18;
        basicAnimationScale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [obj.layer pop_addAnimation:basicAnimationScale forKey:basicAnimationScale.name];
        [basicAnimationScale setCompletionBlock:^(POPAnimation* s, BOOL b) {
            PopMenuButton* btn = (id)obj;
            [btn.model performSelector:@selector(_obj)];
        }];
    }
    else {
        POPSpringAnimation* springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
        springAnimation.removedOnCompletion = YES;
        springAnimation.beginTime = delay;
        springAnimation.springBounciness = springBounciness; // value between 0-20
        springAnimation.springSpeed = _popMenuSpeed; // value between 0-20
        springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(toValue), CGRectGetMidY(toValue))];
        springAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(fromValue), CGRectGetMidY(fromValue))];
        
        POPBasicAnimation* basicAnimationAlpha = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
        basicAnimationAlpha.removedOnCompletion = YES;
        basicAnimationAlpha.duration = 0.2;
        basicAnimationAlpha.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        basicAnimationAlpha.beginTime = delay;
        basicAnimationAlpha.toValue = @(toV);
        basicAnimationAlpha.fromValue = @(fromV);
        [obj pop_addAnimation:basicAnimationAlpha forKey:basicAnimationAlpha.name];
        [obj pop_addAnimation:springAnimation forKey:springAnimation.name];
        [springAnimation setCompletionBlock:^(POPAnimation* spring, BOOL Completion) {
            if (!completionBlock) {
                return;
            }
            if (Completion) {
                completionBlock(Completion);
            }
        }];
    }
}

- (void)animationDidStop:(CAAnimation*)anim finished:(BOOL)flag
{
    
    CABasicAnimation* cab = (CABasicAnimation*)anim;
    if ([cab.keyPath isEqualToString:@"transform.scale"]) {
    }
}

//- (void)playSoundName:(NSString*)name
//              ForType:(NSString*)type
//
//{
//    NSString* AudioName = [NSString stringWithFormat:@"%@.%@", name, type];
//    NSURL* url = [[NSBundle mainBundle] URLForResource:AudioName withExtension:nil];
//    
//    SystemSoundID soundID = 0;
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
//    AudioServicesPlaySystemSound(soundID);
//}

- (void)show
{
    UIWindow *window = (id)[self getMainView];
    if (!window) {
        window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    //    window.windowLevel = UIWindowLevelAlert;
    //    window.backgroundColor = [UIColor clearColor];
    //    window.alpha = 1;
    //    window.hidden = false;
    [window addSubview:self];
}

- (UIView *)getMainView {
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) { //8.0之前
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        if (!window)
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        return [window subviews].lastObject;
    } else { // 8.0之后
        UIWindow *window =[[UIApplication sharedApplication] keyWindow];
        if (window == nil)
        window = [[[UIApplication sharedApplication] delegate] window];//#14
        return window;
    }
}


- (BOOL)isOpenMenu
{
    return _isOpen;
}

- (void)setTopView:(UIView*)topView
{
    if (_topView) {
        [_topView removeFromSuperview];
    }
    _topView = topView;
}

- (void)dealloc {
}

- (void)_obj {}



- (void)addNotificationAtNotificationName:(NSString*)notificationNmae {
    
    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:notificationNmae object:self];
}

@end






