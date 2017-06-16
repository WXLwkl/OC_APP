//
//  AppManager.m
//  OC_APP
//
//  Created by xingl on 2017/6/8.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "AppManager.h"
#import "LaunchViewController.h"


@implementation AppManager

+ (UIViewController *)appStartWithMainViewController:(UIViewController *)mainVC guideImages:(NSArray *)array {
    
    UIViewController *vc = [[LaunchViewController alloc] initWithMainViewController:mainVC guideImages:array];
    
    return vc;
}

@end
