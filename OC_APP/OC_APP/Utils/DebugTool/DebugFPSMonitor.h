//
//  DebugFPSMonitor.h
//  OC_APP
//
//  Created by xingl on 2018/7/24.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FPSBlock)(float fps);

@interface DebugFPSMonitor : NSObject

@property (nonatomic, copy) FPSBlock fpsBlock;

SingletonInterface(Instance);
//+ (instancetype)sharedInstance;

- (void)startMonitoring;

- (void)stopMonitoring;

@end
