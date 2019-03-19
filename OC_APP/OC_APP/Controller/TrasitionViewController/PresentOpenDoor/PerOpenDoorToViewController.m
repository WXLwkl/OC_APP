//
//  PerOpenDoorToViewController.m
//  OC_APP
//
//  Created by xingl on 2019/3/11.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "PerOpenDoorToViewController.h"
#import "UIViewController+XLTransmition.h"
@interface PerOpenDoorToViewController ()

@end

@implementation PerOpenDoorToViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view.layer setContents:(id)[UIImage imageNamed:@"wbBG.png"].CGImage];
    
    __weak typeof(self)weakSelf = self;
    [self xl_registerBackInteractiveTransitionWithDirection:XLInteractiveTransitionGestureDirectionLeft eventBlock:^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
//        [weakSelf.navigationController popViewControllerAnimated:true];
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
