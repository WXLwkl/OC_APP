//
//  TestWebVC.h
//  广告启动页Demo
//
//  Created by xingl on 2016/9/28.
//  Copyright © 2016年 yjpal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootWebViewController.h"

@interface TestWebVC : RootWebViewController

@property (nonatomic,copy) NSString * url;

@end


@interface UIViewController (Public)
///该vc的navigationController
- (UINavigationController*)xl_navigationController;
@end

