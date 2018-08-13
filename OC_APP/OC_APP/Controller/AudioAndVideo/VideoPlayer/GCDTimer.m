//
//  GCDTimer.m
//  OC_APP
//
//  Created by xingl on 2018/8/7.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "GCDTimer.h"

@interface GCDTimer ()

/** 响应 */
@property (nonatomic, strong) dispatch_block_t action;
/** 线程 */
@property (nonatomic, strong) dispatch_queue_t serialQueue;
/** 定时器名字 */
@property (nonatomic, copy) NSString *timerName;
/** 是否重复 */
@property (nonatomic, assign) BOOL repeats;
/** 执行时间 */
@property (nonatomic, assign) NSTimeInterval timeInterval;
/** 延迟时间 */
@property (nonatomic, assign) float delaySecs;
/** 是否正在运行 */
@property (nonatomic, assign) BOOL isRuning;
/** 定时器 */
@property (nonatomic, strong) dispatch_source_t timer;
/** 响应次数 */
@property (nonatomic, assign) NSInteger actionTimes;
@end

@implementation GCDTimer

- (void)dealloc {
    NSLog(@"%@ -- dealloc", self);
}

- (instancetype)initDispatchTimerWithInterval:(double)interval delaySecs:(float)delaySecs queue:(dispatch_queue_t)queue repeats:(BOOL)repeats action:(dispatch_block_t)action {
    if (self = [super init]) {
        self.timeInterval = interval;
        self.delaySecs = delaySecs;
        self.repeats = repeats;
        self.action = action;
        self.timerName = nil;
        self.isRuning = NO;
        self.serialQueue = dispatch_queue_create([[NSString stringWithFormat:@"GCDTimer.%p", self] cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_SERIAL);
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.serialQueue);
        dispatch_set_target_queue(self.serialQueue, queue);
    }
    return self;
}

- (void)startTimer {
    dispatch_async(self.serialQueue, ^{
        dispatch_source_set_timer(self.timer, dispatch_time(DISPATCH_TIME_NOW, (NSInteger)(self.delaySecs * NSEC_PER_SEC)), (NSInteger)(self.timeInterval * NSEC_PER_SEC), 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(self.timer, ^{
            if (self.action) {
                self.action();
                self.actionTimes += 1;
            }
            if (!self.repeats) {
                [self cancelTimer];
            }
        });
        [self resumeTimer];
    });
}

- (void)responseOnceTimer {
    self.isRuning = YES;
    if (self.action) {
        self.action();
        self.actionTimes += 1;
    }
    self.isRuning = NO;
}

- (void)cancelTimer {
    dispatch_async(self.serialQueue, ^{
        if (!self.isRuning) {
            [self resumeTimer];
        }
        dispatch_source_cancel(self.timer);
    });
}

- (void)suspendTimer {
    //拿到当前线程线程
    dispatch_async(self.serialQueue, ^{
        if (self.isRuning) {
            dispatch_suspend(self.timer);
            self.isRuning = NO;
        }
    });
}

- (void)resumeTimer {
    //拿到当前线程线程
    dispatch_async(self.serialQueue, ^{
        if (!self.isRuning) {
            dispatch_resume(self.timer);
            self.isRuning = YES;
        }
    });
}

- (void)replaceOldAction:(dispatch_block_t)action {
    self.action = action;
}

@end
