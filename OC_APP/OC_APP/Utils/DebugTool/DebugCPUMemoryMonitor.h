//
//  DebugCPUMemoryMonitor.h
//  OC_APP
//
//  Created by xingl on 2018/7/24.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^MemoryBlock)(float memory);
typedef void(^CPUBlock)(float cpu);

@interface DebugCPUMemoryMonitor : NSObject

@property (nonatomic, copy) MemoryBlock memoryBlock;
@property (nonatomic, copy) CPUBlock cpuBlock;

SingletonInterface(Instance);
//+ (instancetype)sharedInstance;

- (void)startMonitoring;

- (void)stopMonitoring;

@end
