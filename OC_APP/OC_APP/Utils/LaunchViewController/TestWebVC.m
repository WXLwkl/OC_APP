//
//  TestWebVC.m
//  广告启动页Demo
//
//  Created by xingl on 2016/9/28.
//  Copyright © 2016年 yjpal. All rights reserved.
//

#import "TestWebVC.h"

@interface TestWebVC ()


@end

@implementation TestWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self loadUrlString:self.url];
}



@end



@implementation UIViewController (Public)
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
@end




