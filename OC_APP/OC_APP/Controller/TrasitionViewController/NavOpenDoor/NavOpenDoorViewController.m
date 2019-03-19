//
//  NavOpenDoorViewController.m
//  OC_APP
//
//  Created by xingl on 2019/3/7.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "NavOpenDoorViewController.h"
#import "NavOpenDoorTransitionAnimatior.h"
#import "NavOpenDoorTransitionInteractive.h"

@interface NavOpenDoorViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) NavOpenDoorTransitionAnimatior *transitionAnimatior;
@property (nonatomic, strong) NavOpenDoorTransitionInteractive *transitionInteractive;

@end

@implementation NavOpenDoorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"开门动画";
    
    self.transitionAnimatior.transitionType = NavOpenDoorAnimationTypePush;
    self.transitionInteractive.interactiveType = NavOpenDoorInteractiveTypePop;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
//    self.edgesForExtendedLayout = UIRectEdgeAll;
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
        _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _imageView.image = [UIImage imageNamed:@"01.png"];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked)];
        _imageView.userInteractionEnabled = YES;
        [_imageView addGestureRecognizer:tap];
    }
    return _imageView;
}

- (NavOpenDoorTransitionAnimatior *)transitionAnimatior {
    if (!_transitionAnimatior) {
        _transitionAnimatior = [[NavOpenDoorTransitionAnimatior alloc] init];
    }
    return _transitionAnimatior;
}

- (NavOpenDoorTransitionInteractive *)transitionInteractive {
    if (!_transitionInteractive) {
        _transitionInteractive = [[NavOpenDoorTransitionInteractive alloc] init];
        [_transitionInteractive addPanGestureForViewController:self];
    }
    return _transitionInteractive;
}

#pragma mark -- UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        self.transitionAnimatior.transitionType = NavOpenDoorAnimationTypePush;
    } else if (operation == UINavigationControllerOperationPop) {
        self.transitionAnimatior.transitionType = NavOpenDoorAnimationTypePop;
    }
    return self.transitionAnimatior;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if (self.transitionAnimatior.transitionType == NavOpenDoorAnimationTypePop) {
        return self.transitionInteractive.isInteractive == YES ? self.transitionInteractive : nil;
    }
    return nil;
}

@end
