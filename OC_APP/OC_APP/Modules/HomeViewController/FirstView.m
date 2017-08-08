//
//  FirstView.m
//  OC_APP
//
//  Created by xingl on 2017/6/7.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "FirstView.h"

#import "ViewController.h"

@implementation FirstView


-(void)singleTap{
    
    NSLog(@"Tap 1 time");
    
}

-(void)doubleTap{
    
    NSLog(@"Tap 2 time");
    ViewController *vc = [[ViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    NSLog(@"FLFirstView---%@",self.xl_viewController);
//    [self.xl_viewController.navigationController pushViewController:vc animated:YES];
    [self.xl_viewController presentViewController:nav animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    NSTimeInterval delaytime = 0.4;//自己根据需要调整
    
    switch (touch.tapCount) {
            
        case 1:
            
            [self performSelector:@selector(singleTap) withObject:nil afterDelay:delaytime];
            
            break;
            
        case 2:{
            
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTap) object:nil];
            
            [self performSelector:@selector(doubleTap) withObject:nil afterDelay:delaytime];
            
        }
            
            break;
            
        default:
            
            break;
            
    }
    
}


@end
