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
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
