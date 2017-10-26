//
//  InteractiveTransition.m
//  cehua
//
//  Created by xingl on 2017/10/25.
//  Copyright © 2017年 xingl. All rights reserved.
//

#import "InteractiveTransition.h"

@interface InteractiveTransition ()

@property (nonatomic, weak) UIViewController *weakVC;
@property (nonatomic, assign) DrawerTransitiontype type;

@property (nonatomic, assign) BOOL openEdgeGesture;

@property (nonatomic, assign) DrawerTransitionDirection direction;

@property (nonatomic, strong) CADisplayLink *link;

@property (nonatomic, copy) void(^transitionBlock)();

@end

@implementation InteractiveTransition
{
    CGFloat _percent;
    CGFloat _remaincount;
    BOOL _toFinish;
    CGFloat _oncePercent;
}

- (CADisplayLink *)link {
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(xl_update)];
        [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _link;
}

+ (instancetype)interactiveWithTransitiontype:(DrawerTransitiontype)type {
    return [[self alloc] initWithTransitiontype:type];
}

- (instancetype)initWithTransitiontype:(DrawerTransitiontype)type {
    self = [super init];
    if (self) {
        _type = type;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xl_singleTap) name:LateralSlideTapNotication object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xl_handleHiddenPan:) name:LateralSlidePanNotication object:nil];
    }
    return self;
}

- (void)addPanGestureForViewController:(UIViewController *)viewController {
    self.weakVC = viewController;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(xl_handleShowPan:)];
    [viewController.view addGestureRecognizer:pan];
}

#pragma mark -GestureRecognizer
- (void)xl_singleTap {
    [self.weakVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)xl_handleHiddenPan:(NSNotification *)note {
    
    if (_type == DrawerTransitiontypeShow) return;
    
    UIPanGestureRecognizer *pan = note.object;
    [self handleGesture:pan];
    
}
- (void)xl_handleShowPan:(UIPanGestureRecognizer *)pan {
    
    if (_type == DrawerTransitiontypeHidden) return;
    
    [self handleGesture:pan];
}

- (void)hiddenBeganTranslationX:(CGFloat)x {
    if ((x > 0 && _direction == DrawerTransitionDirectionLeft ) || (x < 0 && _direction == DrawerTransitionDirectionRight )) return;
    self.interacting = YES;
    [self.weakVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)showBeganTranslationX:(CGFloat)x gesture:(UIPanGestureRecognizer *)pan {
    if ((x < 0 && _direction == DrawerTransitionDirectionLeft) || (x > 0 && _direction == DrawerTransitionDirectionRight)) return;
    
    CGFloat locX = [pan locationInView:_weakVC.view].x;
    //    NSLog(@"locX: %f",locX);
    if (_openEdgeGesture && ((locX > 50 && _direction == DrawerTransitionDirectionLeft) || (locX < CGRectGetWidth(_weakVC.view.frame) - 50 && _direction == DrawerTransitionDirectionRight))) {
        return;
    }
    self.interacting = YES;
    if (_transitionBlock) {
        _transitionBlock();
    }
}
- (void)handleGesture:(UIPanGestureRecognizer *)pan  {
    
    CGFloat x = [pan translationInView:pan.view].x;
    
    _percent = 0;
    _percent = x / self.configuration.distance;
    
    if ((_direction == DrawerTransitionDirectionRight && _type == DrawerTransitiontypeShow) || (_direction == DrawerTransitionDirectionLeft && _type == DrawerTransitiontypeHidden)) {
        _percent = -_percent;
    }
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            if (_type == DrawerTransitiontypeShow) {
                [self showBeganTranslationX:x gesture:pan];
            }else {
                [self hiddenBeganTranslationX:x];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            _percent = fminf(fmaxf(_percent, 0.0), 1.0);
            [self updateInteractiveTransition:_percent];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            self.interacting = NO;
            if (_percent > 0.5) {
                [self startDisplayerLink:_percent toFinish:YES];
            }else {
                [self startDisplayerLink:_percent toFinish:NO];
            }
            break;
        }
        default:
            break;
    }
}

- (void)startDisplayerLink:(CGFloat)percent toFinish:(BOOL)finish{
    
    _toFinish = finish;
    CGFloat remainDuration = finish ? self.duration * (1 - percent) : self.duration * percent;
    _remaincount = 60 * remainDuration;
    _oncePercent = finish ? (1 - percent) / _remaincount : percent / _remaincount;
    
    [self starDisplayLink];
}
#pragma mark - displayerLink
- (void)starDisplayLink {
    [self link];
}

- (void)stopDisplayerLink {
    [self.link invalidate];
    self.link = nil;
}

- (void)xl_update {
    
    if (_percent >= 1 && _toFinish) {
        [self stopDisplayerLink];
        [self finishInteractiveTransition];
    } else if (_percent <= 0 && !_toFinish) {
        [self stopDisplayerLink];
        [self cancelInteractiveTransition];
    } else {
        if (_toFinish) {
            _percent += _oncePercent;
        }else {
            _percent -= _oncePercent;
        }
        _percent = fminf(fmaxf(_percent, 0.0), 1.0);
        [self updateInteractiveTransition:_percent];
    }
}
- (void)dealloc {
    //    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}@end
