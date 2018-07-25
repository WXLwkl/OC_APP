//
//  DebugFPSMonitor.m
//  OC_APP
//
//  Created by xingl on 2018/7/24.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "DebugFPSMonitor.h"

@interface DebugFPSMonitor ()

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSTimeInterval lastTimestamp;
@property (nonatomic, assign) NSInteger performTimes;

@end

@implementation DebugFPSMonitor

SingletonImplementation(Instance);

- (void)startMonitoring {
    [self setDisplayLink];
}

- (void)stopMonitoring {
    [_displayLink invalidate];
}

- (void)setDisplayLink {
    [self stopMonitoring];
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTicks:)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}
- (void)displayLinkTicks:(CADisplayLink *)link {
    if (_lastTimestamp == 0) {
        _lastTimestamp = link.timestamp;
        return;
    }
    _performTimes++;
    NSTimeInterval interval = link.timestamp - _lastTimestamp;
    if (interval < 1) return;
    _lastTimestamp = link.timestamp;
    float fps = _performTimes / interval;
    _performTimes = 0;
    if (self.fpsBlock) {
        self.fpsBlock(fps);
    }
}

@end
