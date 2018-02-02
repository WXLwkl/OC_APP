//
//  MainNavigationController.m
//  OC_APP
//
//  Created by xingl on 2017/6/7.
//  Copyright © 2017年 兴林. All rights reserved.
//

static CGFloat kNavigationBackgroundAlpha = 0.8f;

#import "MainNavigationController.h"

@interface MainNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

//@property(nonatomic, strong) NSMutableArray *screenSnapImgsArray;
//@property(nonatomic, weak) UIImageView *screeenImgView;
//@property(nonatomic, weak) UIView *screenCoverView;

@end

@implementation MainNavigationController

/*

#pragma mark - LazyLoading
- (NSMutableArray *)screenSnapImgsArray{
    if (_screenSnapImgsArray == nil) {
        _screenSnapImgsArray = [NSMutableArray array];
    }
    return _screenSnapImgsArray;
}

- (UIImageView *)screeenImgView{
    
    if (_screeenImgView == nil) {
        UIImageView * imgView = [[UIImageView alloc]init];
        imgView.frame = self.view.bounds;
        [[UIApplication sharedApplication].keyWindow addSubview:imgView];
        [[UIApplication sharedApplication].keyWindow insertSubview:imgView atIndex:0];
        [[UIApplication sharedApplication].keyWindow insertSubview:self.screenCoverView atIndex:1];
        
        _screeenImgView = imgView;
    }
    return _screeenImgView;
}

- (UIView *)screenCoverView{
    if (_screenCoverView == nil) {
        UIView * view = [[UIView alloc]init];
        view.frame = self.view.bounds;
        view.backgroundColor = [UIColor blackColor];
        view.alpha = kNavigationBackgroundAlpha;
        [[UIApplication sharedApplication].keyWindow addSubview:view];
        _screenCoverView = view;
    }
    return _screenCoverView;
    
}
*/

#pragma mark - life
//APP生命周期中 只会执行一次
+ (void)initialize {
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    [navBar setTintColor:[UIColor whiteColor]];
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName: [UIFont systemFontOfSize:18]}];
    
    [navBar setBackgroundImage:[UIImage xl_imageWithColor:THEME_color] forBarMetrics:UIBarMetricsDefault];
    
    navBar.shadowImage = [[UIImage alloc] init];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
//    if (animated) {
//        CATransition *animation = [CATransition animation];
//        //动画时间
//        animation.duration = 1.0f;
//        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        //过渡效果
//        animation.type = @"cube";
//        //过渡方向
//        animation.subtype = kCATransitionFromRight;
//        [self.view.layer addAnimation:animation forKey:nil];
//    }
//    [self makeScreenSnap];
    [super pushViewController:viewController animated:animated];
    
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
//    if (animated) {
//        CATransition *animation = [CATransition animation];
//        //动画时间
//        animation.duration = 1.0f;
//        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        //过渡效果
//        animation.type = @"cube";
//        //过渡方向
//        animation.subtype = kCATransitionFromLeft;
//        [self.view.layer addAnimation:animation forKey:nil];
//    }
//    [self.screenSnapImgsArray removeLastObject];
    return [super popViewControllerAnimated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = (id)self;
    self.delegate = self;
//    self.interactivePopGestureRecognizer.enabled = NO;
//    [self addPanScreenGesture];
}
#pragma mark - <UIGestureRecognizerDelegate>
/**
 * 每当用户触发[返回手势]时都会调用一次这个方法
 * 返回值:返回YES,手势有效; 返回NO,手势失效
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 如果当前显示的是第一个子控制器,就应该禁止掉[返回手势]
    //    if (self.childViewControllers.count == 1) return NO;
    //    return YES;
    return self.childViewControllers.count > 1; // 处理后，就不会出现黑边效果的bug了。
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)addPanScreenGesture{
//    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
//    pan.delegate = self;
//    [self.view addGestureRecognizer:pan];
//}


//- (void)pan:(UIPanGestureRecognizer*)pan{
//
//    CGPoint transP = [pan translationInView:self.view];
//
//    if (transP.x>0) {
//        self.view.transform = CGAffineTransformMakeTranslation(transP.x,0);
//        self.screeenImgView.image = [self.screenSnapImgsArray lastObject];
//        self.screenCoverView.alpha = 1-kNavigationBackgroundAlpha *transP.x / (self.view.bounds.size.width/2.0);
//
//        if (pan.state == UIGestureRecognizerStateEnded) {
//            if (transP.x >= self.view.bounds.size.width/3.0) {
//                [UIView animateWithDuration:0.35 animations:^{
//                    self.screenCoverView.alpha = 0.0;
//                    self.view.transform = CGAffineTransformMakeTranslation(self.view.bounds.size.width,0);
//                } completion:^(BOOL finished) {
//                    self.view.transform = CGAffineTransformIdentity;
//                    [super popViewControllerAnimated:NO];
//                    [self.screeenImgView removeFromSuperview];
//                    [self.screenSnapImgsArray removeLastObject];
//                    [self.screenCoverView removeFromSuperview];
//                }];
//            }else{
//                [UIView animateWithDuration:0.35 animations:^{
//                    self.screenCoverView.alpha = kNavigationBackgroundAlpha;
//                    self.view.transform = CGAffineTransformIdentity;
//                } completion:^(BOOL finished) {
//                    [self.screeenImgView removeFromSuperview];
//                    [self.screenCoverView removeFromSuperview];
//                }];
//            }
//        }
//    }
//}
//
//#pragma mark - 私有
//- (void)makeScreenSnap{
//    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size,NO,0);
//    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage * newScreenSnapImg = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    [self.screenSnapImgsArray addObject:newScreenSnapImg];
//}








#pragma mark - StatusBar
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}

#pragma mark -Autorotate
- (BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}
@end
