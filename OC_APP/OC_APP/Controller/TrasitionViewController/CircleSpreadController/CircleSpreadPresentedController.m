//
//  CircleSpreadPresentedController.m
//  OC_APP
//
//  Created by xingl on 2019/3/1.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "CircleSpreadPresentedController.h"
#import "XLInteractiveTransition.h"
#import "UIViewController+XLTransmition.h"
//#import "UIViewController+GLTransition.h"
//#import "GLTransitionManager.h"

@interface CircleSpreadPresentedController ()
@end

@implementation CircleSpreadPresentedController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wbBG.png"]];
    [self.view addSubview:imageView];
    imageView.frame = self.view.frame;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"点我或向下滑动dismiss" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 150, self.view.frame.size.width, 50);
    [self.view addSubview:button];
    
//    [self xl_registerBackInteractiveTransitionWithDirection:(XLInteractiveTransitionGestureDirectionLeft) eventBlock:^{
//        [self dismiss];
//    }];

    __weak typeof(self)weakSelf = self;
    [self xl_registerBackInteractiveTransitionWithDirection:XLInteractiveTransitionGestureDirectionLeft eventBlock:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
        //        [weakSelf dismissViewControllerAnimated:true completion:nil];
    }];
}

- (void)dismiss {
    [self.navigationController popViewControllerAnimated:true];
}

@end
