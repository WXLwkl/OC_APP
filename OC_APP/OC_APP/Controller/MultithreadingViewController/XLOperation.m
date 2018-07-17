//
//  XLOperation.m
//  OC_APP
//
//  Created by xingl on 2018/7/10.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "XLOperation.h"

@implementation XLOperation

- (void)main {
    if (!self.isCancelled) {
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--1--%@", [NSThread currentThread]);
        }
    }
}

@end
