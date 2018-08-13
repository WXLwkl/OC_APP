//
//  GCDTimer.h
//  OC_APP
//
//  Created by xingl on 2018/8/7.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDTimer : NSObject
/** 响应次数 */
@property (nonatomic, assign, readonly) NSInteger actionTimes;

- (instancetype)initDispatchTimerWithInterval:(NSTimeInterval)interval delaySecs:(float)delaySecs queue:(dispatch_queue_t)queue repeats:(BOOL)repeats action:(dispatch_block_t)action;

/** 开启定时器 */
- (void)startTimer;
/** 执行一次定时器响应 */
- (void)responseOnceTimer;
/** 取消定时器 */
- (void)cancelTimer;
/** 暂停定时器 */
- (void)suspendTimer;
/** 恢复定时器 */
- (void)resumeTimer;
/** 替换旧的响应 */
- (void)replaceOldAction:(dispatch_block_t)action;
@end
