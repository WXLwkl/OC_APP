//
//  RunloopViewController.m
//  OC_APP
//
//  Created by xingl on 2018/7/17.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "RunloopViewController.h"

@interface RunloopViewController ()

@property (nonatomic, assign) BOOL stopLoopRunning;
@property (nonatomic, strong) NSRunLoop *threadRunLoop;
@property (nonatomic, strong) NSPort *threadPort;

@end

@implementation RunloopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"常驻线程";
    
    [self permanentThread];
    
    // 子线程runloop默认不开启
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"----begin");
//        [self performSelector:@selector(test) withObject:nil afterDelay:0];
//        [self performSelector:@selector(test) withObject:nil];
//        NSLog(@"----end");
//    });
}

- (void)test {
    NSLog(@"---%@", [NSThread currentThread]);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 取消线程
    BOOL canCancel = YES;
    if (canCancel) {
        [[self permanentThread] cancel];
    }
    
    // 停止常驻线程
    {
        self.stopLoopRunning = YES;
        
        // 移除 port
        // 如果是用 timer 的方式的常驻线程, 可以 invalid 对应的 timer
        [self.threadRunLoop removePort:self.threadPort forMode:NSRunLoopCommonModes];
        
        // 停止 RunLoop
        if (nil != self.threadRunLoop) {
            CFRunLoopStop([self.threadRunLoop getCFRunLoop]);
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    SEL seltor = NSSelectorFromString(@"runAnyTime");
    [self performSelector:seltor onThread:[self permanentThread] withObject:nil waitUntilDone:NO];
}


- (NSThread *)permanentThread {
    static NSThread *thread = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        thread = [[NSThread alloc] initWithTarget:self selector:@selector(asyncRun) object:nil];
        [thread setName:@"veryitman-thread"];
        [thread start];
    });
    return thread;
}

- (void)asyncRun {
    @autoreleasepool {
        NSLog(@"veryitman--asyncRun. Current Thread: %@", [NSThread currentThread]);
        _threadRunLoop = [NSRunLoop currentRunLoop];
        // 添加 source
        _threadPort = [NSMachPort port];
        [_threadRunLoop addPort:_threadPort forMode:NSRunLoopCommonModes];
        NSLog(@"veryitman--asyncRun. Current RunLoop: %@", _threadRunLoop);
//        [_threadRunLoop run];
        
        while (!self.stopLoopRunning && [_threadRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantPast]]) {
            
            // 这里是为了验证常驻线程是否已经退出
            NSLog(@"--- asyncRun ----");
            
            // 实际业务中, 建议使用空语句实现
            ; //实现为空语句
        }
        
        NSLog(@"veryitman--asyncRun. End Run.");
    }
}

- (void)runAnyTime {
    
    NSLog(@"veryitman--runAnyTime. Current Thread: %@", [NSThread currentThread]);
}

@end
