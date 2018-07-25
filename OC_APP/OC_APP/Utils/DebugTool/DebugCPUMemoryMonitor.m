//
//  DebugCPUMemoryMonitor.m
//  OC_APP
//
//  Created by xingl on 2018/7/24.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "DebugCPUMemoryMonitor.h"
#import <sys/sysctl.h>
#import <mach/mach.h>

@interface DebugCPUMemoryMonitor (){
    NSTimer *_timer;
}
@end

@implementation DebugCPUMemoryMonitor

SingletonImplementation(Instance);

- (void)startMonitoring {
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateMemory) userInfo:nil repeats:YES];
    [_timer fire];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)stopMonitoring {
    [_timer invalidate];
    _timer = nil;
}

- (void)updateMemory {
    
    float usedValue = [self getUsedMemory];
    if (self.memoryBlock) {
        self.memoryBlock(usedValue);
    }
    if (self.cpuBlock) {
        self.cpuBlock(cup_usage());
    }
}

- (float)getUsedMemory {
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&taskInfo, &infoCount);
    if (kernReturn != KERN_SUCCESS) return NSNotFound;
    return taskInfo.resident_size/1024.0/1024.0;
}

float cup_usage() {
    kern_return_t kernReturn;
    task_info_data_t taskInfo;
    mach_msg_type_number_t infoCount;
    
    infoCount = TASK_INFO_MAX;
    kernReturn = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)taskInfo, &infoCount);
    if (kernReturn != KERN_SUCCESS) return -1;
    
    task_basic_info_t basicInfo;
    thread_array_t threadArray;
    mach_msg_type_number_t threadCount;
    
    thread_info_data_t threadInfo;
    mach_msg_type_number_t threadInfoCount;
    
    thread_basic_info_t threadBasicInfo;
    uint32_t statThread = 0;
    
    basicInfo = (task_basic_info_t)threadInfo;
    
    kernReturn = task_threads(mach_task_self(), &threadArray, &threadCount);
    if (kernReturn != KERN_SUCCESS) return -1;
    if (threadCount > 0) {
        statThread += threadCount;
    }
    long totalSec = 0;
    long totalUsec = 0;
    float totalCup= 0;
    
    for (int i = 0; i < threadCount; i++) {
        threadInfoCount = THREAD_INFO_MAX;
        kernReturn = thread_info(threadArray[i], THREAD_BASIC_INFO, (thread_info_t)threadInfo, &threadInfoCount);
        if (kernReturn != KERN_SUCCESS) return -1;
        
        threadBasicInfo = (thread_basic_info_t)threadInfo;
        if (!(threadBasicInfo->flags & TH_FLAGS_IDLE)) {
            totalSec = totalSec + threadBasicInfo->user_time.seconds + threadBasicInfo->system_time.seconds;
            totalUsec = totalUsec + threadBasicInfo->user_time.microseconds + threadBasicInfo->system_time.microseconds;
            totalCup = totalCup + threadBasicInfo->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
    }
    kernReturn = vm_deallocate(mach_task_self(), (vm_offset_t)threadArray, threadCount * sizeof(thread_t));
    assert(kernReturn == KERN_SUCCESS);
    return totalCup;
}

@end
