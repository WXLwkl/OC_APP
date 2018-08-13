//
//  DebugTool.m
//  OC_APP
//
//  Created by xingl on 2018/7/24.
//  Copyright © 2018年 兴林. All rights reserved.
//

#define kDebugLabelWidth 70
#define kDebugLabelHeight 20
#define KDebugMargin 20

#import "DebugTool.h"

#import "DebugConsoleLabel.h"
#import "DebugFPSMonitor.h"
#import "DebugCPUMemoryMonitor.h"

@interface DebugTool ()

@property (nonatomic, strong) DebugConsoleLabel *memoryLabel;

@property (nonatomic, strong) DebugConsoleLabel *fpsLabel;

@property (nonatomic, strong) DebugConsoleLabel *cpuLabel;

@property (nonatomic, assign) BOOL isShowing;

@property(nonatomic, strong) UIWindow *debugWindow;

@end

@implementation DebugTool

SingletonImplementation(DebugTool);

- (void)autoTypes:(DebugToolTypes)types {
    if (self.isShowing) {
        [self hideTypes:types];
    } else {
        [self showTypes:types];
    }
}
- (void)showTypes:(DebugToolTypes)types {
    [self deinitWindow];
    [self setDebugWindow];
    if (types & DebugToolTypeMemory ||
        types & DebugToolTypeCPU) {
        [[DebugCPUMemoryMonitor sharedInstance] startMonitoring];
    }
    
    if (types & DebugToolTypeFPS) {
        [self showFPS];
    }
    
    if (types & DebugToolTypeMemory) {
        [self showMemory];
    }
    
    if (types & DebugToolTypeCPU) {
        [self showCPU];
    }
}
- (void)hideTypes:(DebugToolTypes)types {
    
    if (types & DebugToolTypeFPS) {
        [self hideFPS];
    }
    
    if (types & DebugToolTypeMemory) {
        [self hideMemory];
    }
    
    if (types & DebugToolTypeCPU) {
        [self hideCPU];
    }
}

#pragma mark - Window
- (void)setDebugWindow {
    CGFloat debugWindowY = iPhoneX ? 30 : 0;
    self.debugWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, debugWindowY, kScreenWidth, kDebugLabelHeight)];
    self.debugWindow.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.debugWindow.windowLevel = UIWindowLevelAlert;
    self.debugWindow.rootViewController = [UIViewController new];
    self.debugWindow.hidden = NO;
    self.debugWindow.userInteractionEnabled = NO;
}

#pragma mark - show
- (void)showMemory {
    [DebugCPUMemoryMonitor sharedInstance].memoryBlock = ^(float memory) {
        [self.memoryLabel updateLabelWith:DebugToolLabelTypeMemory value:memory];
    };
    [self.debugWindow addSubview:self.memoryLabel];
    [UIView animateWithDuration:0.3 animations:^{
        self.memoryLabel.frame = CGRectMake(KDebugMargin, 0, kDebugLabelWidth, kDebugLabelHeight);
    }completion:^(BOOL finished) {
        self.isShowing = YES;
    }];
}

- (void)showCPU {
    [DebugCPUMemoryMonitor sharedInstance].cpuBlock = ^(float cpu) {
        [self.cpuLabel updateLabelWith:DebugToolLabelTypeCPU value:cpu];
    };
    [self.debugWindow addSubview:self.cpuLabel];
    [UIView animateWithDuration:0.3 animations:^{
        self.cpuLabel.frame = CGRectMake((kScreenWidth - kDebugLabelWidth) / 2, 0, kDebugLabelWidth, kDebugLabelHeight);
    }completion:^(BOOL finished) {
        self.isShowing = YES;
    }];
}

- (void)showFPS {
    [[DebugFPSMonitor sharedInstance] startMonitoring];
    [DebugFPSMonitor sharedInstance].fpsBlock = ^(float fps) {
        [self.fpsLabel updateLabelWith:DebugToolLabelTypeFPS value:fps];
    };
    [self.debugWindow addSubview:self.fpsLabel];
    [UIView animateWithDuration:0.3 animations:^{
        self.fpsLabel.frame = CGRectMake(kScreenWidth - kDebugLabelWidth - KDebugMargin, 0, kDebugLabelWidth, kDebugLabelHeight);
    }completion:^(BOOL finished) {
        self.isShowing = YES;
    }];
}

#pragma mark - hide
- (void)hideMemory {
    [UIView animateWithDuration:0.3 animations:^{
        [[DebugCPUMemoryMonitor sharedInstance] stopMonitoring];
        self.memoryLabel.frame = CGRectMake(-kDebugLabelWidth, 0, kDebugLabelWidth, kDebugLabelHeight);
    }completion:^(BOOL finished) {
        [self.memoryLabel removeFromSuperview];
        self.memoryLabel = nil;
        [self deinitWindow];
    }];
}

- (void)hideCPU {
    [UIView animateWithDuration:0.3 animations:^{
        [[DebugCPUMemoryMonitor sharedInstance] stopMonitoring];
        self.cpuLabel.frame = CGRectMake((kScreenWidth - kDebugLabelWidth) / 2, -kDebugLabelHeight, kDebugLabelWidth, kDebugLabelHeight);
    }completion:^(BOOL finished) {
        [self.cpuLabel removeFromSuperview];
        self.cpuLabel = nil;
        [self deinitWindow];
    }];
}

- (void)hideFPS {
    [UIView animateWithDuration:0.3 animations:^{
        [[DebugFPSMonitor sharedInstance] stopMonitoring];
        self.fpsLabel.frame = CGRectMake(kScreenWidth + kDebugLabelWidth, 0, kDebugLabelWidth, kDebugLabelHeight);
    }completion:^(BOOL finished) {
        [self.fpsLabel removeFromSuperview];
        self.fpsLabel = nil;
        [self deinitWindow];
    }];
}

- (void)deinitWindow {
    self.debugWindow = nil;
    self.isShowing = NO;
}

#pragma mark - getter
- (DebugConsoleLabel *)memoryLabel {
    if (!_memoryLabel) {
        _memoryLabel = [[DebugConsoleLabel alloc] initWithFrame:CGRectMake(-kDebugLabelWidth, 0, kDebugLabelWidth, kDebugLabelHeight)];
    }
    return _memoryLabel;
}

- (DebugConsoleLabel *)cpuLabel {
    if (!_cpuLabel) {
        _cpuLabel = [[DebugConsoleLabel alloc] initWithFrame:CGRectMake((kScreenWidth - kDebugLabelWidth) / 2, -kDebugLabelHeight, kDebugLabelWidth, kDebugLabelHeight)];
    }
    return _cpuLabel;
}

- (DebugConsoleLabel *)fpsLabel {
    if (!_fpsLabel) {
        _fpsLabel = [[DebugConsoleLabel alloc] initWithFrame:CGRectMake(kScreenWidth + kDebugLabelWidth, 0, kDebugLabelWidth, kDebugLabelHeight)];
    }
    return _fpsLabel;
}

@end
