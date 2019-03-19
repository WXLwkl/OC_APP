//
//  Pop12ViewController.m
//  OC_APP
//
//  Created by xingl on 2019/3/8.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "Pop12ViewController.h"
#import "PopAnimatior.h"

@interface Pop12ViewController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) PopTransitionInteractive *interactiveDismiss;

@end

@implementation Pop12ViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.layer.cornerRadius = 10;
    self.view.layer.masksToBounds = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"点我或向下滑动dismiss" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(100);
    }];
    
    self.interactiveDismiss.interactiveType = PopInteractiveTypeDismiss;
}

- (void)dismiss {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - get
- (PopTransitionInteractive *)interactiveDismiss {
    if (!_interactiveDismiss) {
        _interactiveDismiss = [[PopTransitionInteractive alloc] init];
        [_interactiveDismiss addPanGestureForViewController:self];
    }
    return _interactiveDismiss;
}



#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[PopAnimatior alloc] initWithTransitionType:PopAnimationTypePresent];
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[PopAnimatior alloc] initWithTransitionType:PopAnimationTypeDismiss];
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
    return _interactiveDismiss.isInteractive ? _interactiveDismiss : nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator{
    return self.interactivePush.isInteractive ? self.interactivePush : nil;
}
@end
