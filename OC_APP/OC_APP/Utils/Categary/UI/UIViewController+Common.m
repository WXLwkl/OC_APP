//
//  UIViewController+Common.m
//  OC_APP
//
//  Created by xingl on 2017/8/1.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "UIViewController+Common.h"

@implementation UIViewController (Common)

- (void)xl_setNavBackItem {
    [self xl_setNavBackItemWithImage:@"nav_back"];
}

- (void)xl_setNavBackItemWithImage:(NSString *)imageName {
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName]
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(xl_closeSelfAction)];

}

- (void)xl_setLeftBarButtonItemWithTitle:(NSString *)title action:(void(^)())block {
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    btn.backgroundColor = [UIColor clearColor];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btn xl_addActionHandler:block];
    [btn sizeToFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;

}
- (void)xl_closeSelfAction {
    
    NSArray *viewcontrollers=self.navigationController.viewControllers;
    
    if (viewcontrollers.count > 1)
    {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count - 1] == self) {
            //push方式
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        //present方式
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - -----

+ (UIViewController *)getVisibleViewControllerFrom:(UIViewController*)vc {
    
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getVisibleViewControllerFrom:[((UINavigationController*) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        return [self getVisibleViewControllerFrom:[((UISplitViewController*) vc) viewControllers].lastObject];
    } else if ([vc isKindOfClass:[UITabBarController class]]){
        return [self getVisibleViewControllerFrom:[((UITabBarController*) vc) selectedViewController]];
    } else if(vc.presentedViewController) {
        
        return [self getVisibleViewControllerFrom:vc.presentedViewController];
    } else {
        
        return vc;
    }
}

- (UINavigationController*)xl_navigationController {

    UINavigationController* nav = nil;
    if ([self isKindOfClass:[UINavigationController class]]) {
        nav = (id)self;
    }
    else {
        if ([self isKindOfClass:[UITabBarController class]]) {
            nav = [((UITabBarController*)self).selectedViewController xl_navigationController];
        }
        else {
            nav = self.navigationController;
        }
    }
    return nav;
}


+ (UIViewController *)xl_currentViewController {
    UIViewController *viewController = [[UIApplication sharedApplication].delegate window].rootViewController;
    
    return [UIViewController getVisibleViewControllerFrom:viewController];
}
+ (UINavigationController *)xl_currentNavigatonController {
    
    UIViewController * currentViewController =  [UIViewController xl_currentViewController];
    
    return currentViewController.navigationController;
}



@end
