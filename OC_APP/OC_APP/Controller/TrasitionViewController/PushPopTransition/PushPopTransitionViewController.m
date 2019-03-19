//
//  PushPopTransitionViewController.m
//  OC_APP
//
//  Created by xingl on 2019/3/7.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "PushPopTransitionViewController.h"
#import "PushPopTransitionAnimatior.h"
#import "PushPopTransitionInteractive.h"

@interface PushPopTransitionViewController ()

@property (nonatomic, strong) PushPopTransitionAnimatior *transitionAnimatior;
@property (nonatomic, strong) PushPopTransitionInteractive *transitionInteractive;


@end

@implementation PushPopTransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.titleLabel];
    
    self.transitionAnimatior.transitionType = PushPopAnimationTypePush;
    self.transitionInteractive.interactiveType = PushPopInteractiveTypePop;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.delegate = nil;
}


- (void)tapClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- Getter
- (UIImageView *)imageView {
    
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/2)];
        _imageView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
        _imageView.image = [UIImage imageNamed:@"piao"];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked)];
        _imageView.userInteractionEnabled = YES;
        [_imageView addGestureRecognizer:tap];
    }
    return _imageView;
}

- (UILabel *)titleLabel{
    
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,kScreenHeight - kNavHeight - 30, kScreenWidth, 40)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.text = @"手势过渡动画";
    }
    return _titleLabel;
}
- (PushPopTransitionAnimatior *)transitionAnimatior {
    if (_transitionAnimatior == nil) {
        _transitionAnimatior = [[PushPopTransitionAnimatior alloc] init];
    }
    return _transitionAnimatior;
}

- (PushPopTransitionInteractive *)transitionInteractive {
    if (!_transitionInteractive) {
        _transitionInteractive = [[PushPopTransitionInteractive alloc] init];
        [_transitionInteractive addPanGestureForViewController:self];
    }
    return _transitionInteractive;
}
#pragma mark -- UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        self.transitionAnimatior.transitionType = PushPopAnimationTypePush;
    } else if (operation == UINavigationControllerOperationPop) {
        self.transitionAnimatior.transitionType = PushPopAnimationTypePop;
    }
    return self.transitionAnimatior;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if (self.transitionAnimatior.transitionType == PushPopAnimationTypePop) {
        return self.transitionInteractive.isInteractive == YES ? self.transitionInteractive : nil;
    }
    return nil;
}

@end
