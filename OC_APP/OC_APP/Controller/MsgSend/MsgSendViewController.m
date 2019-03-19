//
//  MsgSendViewController.m
//  OC_APP
//
//  Created by xingl on 2019/2/22.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "MsgSendViewController.h"
#import "Dog.h"

@interface MsgSendViewController ()

@end

@implementation MsgSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    Dog * p = [[Dog alloc] init];
    [p eat:@"学习！！"];
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
