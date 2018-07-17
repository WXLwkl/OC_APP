//
//  ThreadViewController.m
//  OC_APP
//
//  Created by xingl on 2018/7/4.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "ThreadViewController.h"
#import <pthread.h>

@interface ThreadViewController ()

@property (nonatomic, assign) NSInteger ticketSurplusCount;

@property (nonatomic, strong) NSThread *ticketSaleWindow1;
@property (nonatomic, strong) NSThread *ticketSaleWindow2;

@end

@implementation ThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self xl_setNavBackItem];
    
    

//    [self pthreadTest];
//    [self threadTest1];
    
    [self initTicketStatusSave];
}
#pragma mark - pthread
- (void)pthreadTest {
    
/**
 pthread
 使用 C 语言编写，需要程序员自己管理线程的生命周期，使用难度较大，我们在 iOS 开发中几乎不使用 pthread，
 
 */
    
    
// 1. 创建线程：定义一个pthread_t类型变量
    pthread_t thread;
// 2. 开启线程: 执行任务
    pthread_create(&thread, NULL, run, NULL);
// 3. 设置子线程的状态设置为 detached，该线程运行结束后会自动释放所有资源
    pthread_detach(thread);

/**
 
 pthread_create(&thread, NULL, run, NULL); 中各项参数含义：
 第一个参数&thread是线程对象，指向线程标识符的指针
 第二个是线程属性，可赋值NULL
 第三个run表示指向函数的指针(run对应函数里是需要在新线程中执行的任务)
 第四个是运行函数的参数，可赋值NULL
 
 */
    
/**
 
 pthread 其他相关方法
 pthread_create() 创建一个线程
 pthread_exit() 终止当前线程
 pthread_cancel() 中断另外一个线程的运行
 pthread_join() 阻塞当前的线程，直到另外一个线程运行结束
 pthread_attr_init() 初始化线程的属性
 pthread_attr_setdetachstate() 设置脱离状态的属性（决定这个线程在终止时是否可以被结合）
 pthread_attr_getdetachstate() 获取脱离状态的属性
 pthread_attr_destroy() 删除线程的属性
 pthread_kill() 向线程发送一个信号
 
 */
    
}
void * run(void *param)    // 新线程调用方法，里边为需要执行的任务
{
    NSLog(@"%@", [NSThread currentThread]);
    
    return NULL;
}

#pragma mark - NSThread
- (void)run2 {
    LogBool([NSThread isMainThread]);
    NSLog(@"%@", [NSThread currentThread]);
}

- (void)threadTest1 {
    // 创建线程
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run2) object:nil];
    // 启动线程
    [thread start];
    
    // 创建线程后 自动启动线程
    [NSThread detachNewThreadSelector:@selector(run2) toTarget:self withObject:nil];
}

/**

 // 获得主线程
 + (NSThread *)mainThread;
 
 // 判断是否为主线程(对象方法)
 - (BOOL)isMainThread;
 
 // 判断是否为主线程(类方法)
 + (BOOL)isMainThread;
 
 // 获得当前线程
 NSThread *current = [NSThread currentThread];
 
 // 线程的名字——setter方法
 - (void)setName:(NSString *)n;
 
 // 线程的名字——getter方法
 - (NSString *)name;
 
 
 // 线程进入就绪状态 -> 运行状态。当线程任务执行完毕，自动进入死亡状态
 - (void)start;

 // 线程进入阻塞状态
 + (void)sleepUntilDate:(NSDate *)date;
 + (void)sleepForTimeInterval:(NSTimeInterval)ti;
 
 // 线程进入死亡状态
 + (void)exit;
 */


/**

 线程直接的通信

 // 在主线程上执行操作
 - (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait;
 - (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait modes:(NSArray<NSString *> *)array;
 // equivalent to the first method with kCFRunLoopCommonModes
 
 // 在指定线程上执行操作
 - (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUntilDone:(BOOL)wait modes:(NSArray *)array NS_AVAILABLE(10_5, 2_0);
 - (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUntilDone:(BOOL)wait NS_AVAILABLE(10_5, 2_0);
 
 // 在当前线程上执行操作，调用 NSObject 的 performSelector:相关方法
 - (id)performSelector:(SEL)aSelector;
 - (id)performSelector:(SEL)aSelector withObject:(id)object;
 - (id)performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2;

 */




- (void)initTicketStatusSave {
    
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    self.ticketSurplusCount = 50;
    //2. 设置北京火车票售票窗口的线程
    self.ticketSaleWindow1 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicketSafe) object:nil];
    self.ticketSaleWindow1.name = @"北京火车票售票窗口";
    
    self.ticketSaleWindow2 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicketSafe) object:nil];
    self.ticketSaleWindow2.name = @"上海火车票售票窗口";
    
    [self.ticketSaleWindow1 start];
    [self.ticketSaleWindow2 start];
}
- (void)saleTicketSafe {
    while (1) {
        //互斥锁
        @synchronized (self) {
            if (self.ticketSurplusCount > 0) {
                self.ticketSurplusCount--;
                NSLog(@"%@",[NSString stringWithFormat:@"剩余票数： %ld 窗口：%@", (long)self.ticketSurplusCount, [NSThread currentThread]]);
//                [NSThread sleepForTimeInterval:1];
            } else {
                NSLog(@"票已售罄！");
                break;
            }
        }
    }
}
@end
