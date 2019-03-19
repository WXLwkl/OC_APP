//
//  ImageTransitionViewController.m
//  OC_APP
//
//  Created by xingl on 2019/3/6.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "ImageTransitionViewController.h"
#import "ImageTransitionAnimatior.h"

@interface ImageTransitionViewController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) ImageTransitionAnimatior *transitionAnimatior;

@end

@implementation ImageTransitionViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transitionAnimatior.transitionType = TransitionTypePresent;
        //设置了这个属性之后，在present转场动画处理时，转场前的视图fromVC的view一直都在管理转场动画视图的容器containerView中，会被转场后,后加入到containerView中视图toVC的View遮住，类似于入栈出栈的原理；如果没有设置的话，present转场时，fromVC.view就会先出栈从containerView移除，然后toVC.View入栈，那之后再进行disMiss转场返回时，需要重新把fromVC.view加入containerView中。
        //在push转场动画处理时,设置这个属性是没有效果的，也就是没用的。
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.imageView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.imageView addGestureRecognizer:pan];
}

- (void)handleGesture:(UIPanGestureRecognizer *)panGesture {
    CGPoint translation = [panGesture translationInView:self.imageView];
    CGFloat percentComplete = 0.0;
    
    self.imageView.center = CGPointMake(self.imageView.center.x + translation.x, self.imageView.center.y + translation.y);
    [panGesture setTranslation:CGPointZero inView:self.imageView];
    
    percentComplete = (self.imageView.center.y - self.view.frame.size.height/2) / (self.view.frame.size.height/2);
    percentComplete = fabs(percentComplete);
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            self.view.alpha = 1 - percentComplete;
            break;
        case UIGestureRecognizerStateEnded:{
            if (percentComplete > 0.5) {
                [self dismissViewControllerAnimated:true completion:nil];
            } else {
                self.imageView.center = CGPointMake(self.view.center.x, self.view.center.y);
                self.view.alpha = 1;
            }
        }
            break;
        default:
            break;
    }
    
}

- (void)tapClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getter
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

- (ImageTransitionAnimatior *)transitionAnimatior {
    if (!_transitionAnimatior) {
        _transitionAnimatior = [[ImageTransitionAnimatior alloc] init];
        self.transitioningDelegate = self;
    }
    return _transitionAnimatior;
}

#pragma mark - UIViewControllerTransitioningDelegate
//返回一个处理present动画过渡的对象
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.transitionAnimatior;
}
//返回一个处理dismiss动画过渡的对象
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.transitionAnimatior.transitionType = TransitionTypeDissmiss;
    return self.transitionAnimatior;
}
@end
