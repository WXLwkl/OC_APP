//
//  PerOpenDoorViewController.m
//  OC_APP
//
//  Created by xingl on 2019/3/7.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "PerOpenDoorViewController.h"
#import "PerOpenDoorToViewController.h"
#import "UIViewController+XLTransmition.h"
#import "OpenDoorAnimation.h"

@interface PerOpenDoorViewController ()
@property (nonatomic, strong) UIButton *animationButton;
@end

@implementation PerOpenDoorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view.layer setContents:(id)[UIImage imageNamed:@"01.png"].CGImage];
    
    [self.view addSubview:self.animationButton];
    
    __weak typeof(self)weakSelf = self;
    [self xl_registerToInteractiveTransitionWithDirection:XLInteractiveTransitionGestureDirectionRight eventBlock:^{
        OpenDoorAnimation *openDoorAnimation = [[OpenDoorAnimation alloc] init];
        openDoorAnimation.duration = 0.5;
        //
        PerOpenDoorToViewController *openDoorToVc = [[PerOpenDoorToViewController alloc] init];
        [weakSelf xl_presentViewController:openDoorToVc withAnimation:openDoorAnimation];
    }];
}

#pragma mark == event response
- (void)animationButtonClick:(UIButton *)sender {
    OpenDoorAnimation *openDoorAnimation = [[OpenDoorAnimation alloc] init];
    openDoorAnimation.duration = 0.5;
//
    PerOpenDoorToViewController *openDoorToVc = [[PerOpenDoorToViewController alloc] init];
    [self xl_presentViewController:openDoorToVc withAnimation:openDoorAnimation];
//    [self xl_pushViewController:openDoorToVc withAnimation:openDoorAnimation];
}

#pragma mark == 懒加载
- (UIButton *)animationButton {
    if (nil == _animationButton) {
        _animationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _animationButton.frame = CGRectMake(0, 0, 60, 60);
        _animationButton.center = self.view.center;
        _animationButton.layer.cornerRadius = 30;
        [_animationButton addTarget:self action:@selector(animationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_animationButton setImage:[UIImage imageNamed:@"userHead"] forState:UIControlStateNormal];
        _animationButton.adjustsImageWhenHighlighted = NO;
    }
    return _animationButton;
}


@end
