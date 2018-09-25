//
//  main.m
//  Demo
//
//  Created by 兴林 on 2016/10/12.
//  Copyright © 2016年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

CFAbsoluteTime startTime;

int main(int argc, char * argv[]) {
    @autoreleasepool {
        startTime = CFAbsoluteTimeGetCurrent();
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
