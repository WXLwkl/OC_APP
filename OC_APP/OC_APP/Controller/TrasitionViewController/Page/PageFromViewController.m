//
//  PageFromViewController.m
//  OC_APP
//
//  Created by xingl on 2019/3/11.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "PageFromViewController.h"
#import "PageToViewController.h"

#import "UIViewController+XLTransmition.h"
#import "PageTurningAnimation.h"

@interface PageFromViewController ()

@end

@implementation PageFromViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view.layer setContents:(id)[UIImage imageNamed:@"01.png"].CGImage];
    
    __weak typeof(self)weakSelf = self;
    [self xl_registerToInteractiveTransitionWithDirection:XLInteractiveTransitionGestureDirectionRight eventBlock:^{
        
        PageTurningAnimation *middlePageAnimation = [[PageTurningAnimation alloc] init];
        middlePageAnimation.duration = 1;
        
        PageToViewController *middlePageToVc = [[PageToViewController alloc] init];
        
        [weakSelf xl_pushViewController:middlePageToVc withAnimation:middlePageAnimation];
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
