//
//  GCDViewController.m
//  OC_APP
//
//  Created by xingl on 2018/6/11.
//  Copyright © 2018年 兴林. All rights reserved.
//

/**

  同步和异步 针对的是线程
  串行和并发 针对的是队列
 */

#import "GCDViewController.h"

@interface GCDViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    dispatch_source_t timer;
}

/**
 atomic 原子 不可再划分，已经是最小的一个操作单位 （内存读写） set枷锁
 场景：最简单的set/get 如果不只是set/get 就用nonatomic
 nonatomic UIKit的类
 */

@property (nonatomic, assign) NSInteger ticketSurplusCount;

@property (nonatomic, strong) dispatch_semaphore_t semaphoreLock;

@property (nonatomic, strong) NSMutableArray *masonryViewArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *dataArray;

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"GCD";
    [self xl_setNavBackItem];
    
    
//    [self test1]; //死锁测试
//    [self syncConcurrent]; // 同步并发
//    [self test_masonry_vertical_fixSpace];
    
    NSDictionary *dic1 = @{@"title":@"基本用法",
                           @"data":@[@{@"title":@"同步执行 + 串行队列", @"sel":@"syncSerial"},
                                     @{@"title":@"同步执行 + 并发队列", @"sel":@"syncConcurrent"},
                                     @{@"title":@"异步执行 + 串行队列", @"sel":@"asyncSerial"},
                                     @{@"title":@"异步执行 + 并发队列", @"sel":@"asyncConcurrent"},
                                     @{@"title":@"同步执行 + 主队列", @"sel":@"syncMain"},
                                     @{@"title":@"异步执行 + 主队列", @"sel":@"asyncMain"}]};
    NSDictionary *dic2 = @{@"title":@"嵌套",
                           @"data":@[@{@"title":@"同步并发嵌套(异步)", @"sel":@"syncConcurrentAsync"},
                                     @{@"title":@"同步并发嵌套(同步)", @"sel":@"syncConcurrentSync"},
                                     @{@"title":@"同步串行嵌套(异步)", @"sel":@"syncSerialAsync"},
                                     @{@"title":@"异步串行嵌套(异步)", @"sel":@"asyncSerialAsync"},
                                     @{@"title":@"异步串行嵌套(同步)", @"sel":@"asyncSerialSync"}]};
    NSDictionary *dic3 = @{@"title":@"队列组",
                           @"data":@[@{@"title":@"dispatch_group_notify", @"sel":@"groupNotify"},
                                     @{@"title":@"dispatch_group_wait", @"sel":@"groupWait"},
                                     @{@"title":@"dispatch_group_enter、dispatch_group_leave", @"sel":@"groupEnterAndLeave"}]};
    NSDictionary *dic4 = @{@"title":@"信号量",
                           @"data":@[@{@"title":@"线程安全", @"sel":@"semaphoreSync"},
                                     @{@"title":@"卖票案例线程不安全", @"sel":@"initTicketStatusNotSave"},
                                     @{@"title":@"卖票案例线程安全", @"sel":@"initTicketStatusSave"}]};
    NSDictionary *dic5 = @{@"title":@"其他用法",
                           @"data":@[@{@"title":@"暂停和恢复", @"sel":@"suspendAndResume"},
                                     @{@"title":@"栅栏方法", @"sel":@"barrier"},
                                     @{@"title":@"延时执行方法", @"sel":@"after"},
                                     @{@"title":@"一次性代码", @"sel":@"once"},
                                     @{@"title":@"快速迭代方法", @"sel":@"apply"},
                                     @{@"title":@"source定时器", @"sel":@"timer"},
                                     @{@"title":@"优先级", @"sel":@"priority"},
                                     @{@"title":@"semaphore锁", @"sel":@"semaphore"},
                                     @{@"title":@"synchronized锁", @"sel":@"synchronized"},
                                     @{@"title":@"优先级", @"sel":@"priority"}]};
    _dataArray = @[dic1, dic2, dic3, dic4, dic5];
    [self.view addSubview:self.tableView];
}
#pragma mark - other

// 死锁
- (void)syncMain2 {
    // 因为dispatch_apply会卡住当前线程，内部的dispatch_apply会等待外部，外部的等待内部，所以死锁。
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    dispatch_apply(4, queue, ^(size_t index) {
        NSLog(@"download1--%zd--%@",index,[NSThread currentThread]);
        NSLog(@"+++++++++++++++");
        dispatch_apply(4, queue, ^(size_t index) {
            NSLog(@"download2--%zd--%@",index,[NSThread currentThread]);
        });
    });
}

- (void)test1 {
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        NSLog(@"2");
//    });
//    NSLog(@"3");

//    NSLog(@"1");
//    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//
//        NSLog(@"2");
//    });
//    NSLog(@"3");

//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"1"); // 任务1
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            NSLog(@"2"); // 任务2
//        });
//        NSLog(@"3"); // 任务3
//    });
//    NSLog(@"4"); // 任务4
//    while (1) {
//    }
//    NSLog(@"5"); // 任务5
}

// 垂直方向排列、固定控件间隔、控件高度不定
- (void)test_masonry_vertical_fixSpace {
    
    // 实现masonry垂直固定控件高度方法
    [self.masonryViewArray mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:20 leadSpacing:30 tailSpacing:30];
    
    // 设置array的水平方向的约束
    [self.masonryViewArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerX.mas_equalTo(self.view);
    }];
}

#pragma mark - GCD的基本方法
/**
 同步执行 + 串行队列
 特点：不开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务。
 */
- (void)syncSerial {
    NSLog(@"currentThread--%@", [NSThread currentThread]);
    NSLog(@"--begin--");
    dispatch_queue_t queue =dispatch_queue_create("com.xingl.serial", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--1--%@", [NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--2--%@", [NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--3--%@", [NSThread currentThread]);
        }
    });
    NSLog(@"--end--");
}

/**
 同步执行 + 并发队列
 特点：不会开启新线程，在当前线程中执行任务，执行完一个任务，再执行下一个任务
 */
- (void)syncConcurrent {
    NSLog(@"currentThread--%@", [NSThread currentThread]);
    NSLog(@"--begin--");
    dispatch_queue_t queue = dispatch_queue_create("com.xingl.concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--1--%@", [NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--2--%@", [NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--3--%@", [NSThread currentThread]);
        }
    });
    NSLog(@"--end--");
}

/**
 异步执行 + 串行队列
 特点：会开启新线程，但是因为任务是串行，执行完一个任务，再执行下一个任务。
 */
- (void)asyncSerial {
    
    NSLog(@"currentThread--%@", [NSThread currentThread]);
    NSLog(@"--begin--");
    dispatch_queue_t queue = dispatch_queue_create("com.xingl.serial", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--1--%@", [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--2--%@", [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--3--%@", [NSThread currentThread]);
        }
    });
    NSLog(@"--end--");
}

/**
 异步执行 + 并发队列
 特点：可以开启多个线程，任务交替（同时）执行。
 */
- (void)asyncConcurrent {
    NSLog(@"currentThread--%@", [NSThread currentThread]);
    NSLog(@"--begin--");
    dispatch_queue_t queue = dispatch_queue_create("com.xingl.concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--1--%@", [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--2--%@", [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--3--%@", [NSThread currentThread]);
        }
    });
    NSLog(@"--end--");
}

/**
 同步执行 + 主队列
 特点：(主线程调用) 互等死锁不执行
      (其他线程调用) 不会开启新线程，执行完一个任务，再执行下一个任务。
 */
- (void)syncMain {
    
//    (其他线程调用) 不会开启新线程，执行完一个任务，再执行下一个任务。
//    [NSThread detachNewThreadSelector:@selector(syncMain) toTarget:self withObject:nil];
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);
    NSLog(@"--begin--");
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--1--%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--2--%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--3--%@",[NSThread currentThread]);
        }
    });
    NSLog(@"--end--");
    
}

/**
 异步执行 + 主队列
 特点：只在主线程中执行任务，执行完一个任务，在执行下一个任务。
 */
- (void)asyncMain {
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);
    NSLog(@"--begin--");
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--1--%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--2--%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--3--%@",[NSThread currentThread]);
        }
    });
    NSLog(@"--end--");
}

#pragma mark - 嵌套

/**
 同步并发嵌套(异步)
 */
- (void)syncConcurrentAsync {
    NSLog(@"--begin--");
    dispatch_queue_t queue = dispatch_queue_create("com.gcd.nesting", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        NSLog(@"--1--");
        dispatch_async(queue, ^{
//            sleep(2);
            NSLog(@"--2--");
        });
//        sleep(1);
        NSLog(@"--3--");
    });
    NSLog(@"--end--");
}

/**
 同步并发嵌套(同步)
 */
- (void)syncConcurrentSync {
    NSLog(@"--begin--");
    dispatch_queue_t queue = dispatch_queue_create("com.gcd.nesting", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        NSLog(@"--1--");
        dispatch_sync(queue, ^{
            sleep(1);
            NSLog(@"--2--");
        });
        NSLog(@"--3--");
    });
    NSLog(@"--end--");
    
    //  1 --> 2 --> 3
}

/**

 任务 & 队列
 
 任务
    同步执行 & 异步执行
 队列
    串行队列 & 并发队列

 */


/**
 同步串行嵌套(异步)
 */
- (void)syncSerialAsync {
    NSLog(@"--begin--");
    dispatch_queue_t queue = dispatch_queue_create("com.gcd.nesting", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        NSLog(@"--1--");
        dispatch_async(queue, ^{
            NSLog(@"--2--");
        });
        sleep(2);
        NSLog(@"--3--");
    });
    NSLog(@"--end--");
    
    //   1 --> 3--> 2
}

/**
 异步串行嵌套(异步)
 */
- (void)asyncSerialAsync {
    NSLog(@"--begin--");
    dispatch_queue_t queue = dispatch_queue_create("com.gcd.nesting", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSLog(@"--1--");
        dispatch_async(queue, ^{
            NSLog(@"--2--");
        });
        sleep(2);
        NSLog(@"--3--");
    });
    NSLog(@"--end--");
    
    //   1 --> 3--> 2
}
/**
 异步串行嵌套(同步)
 */
- (void)asyncSerialSync {
    NSLog(@"--begin--");
    dispatch_queue_t queue = dispatch_queue_create("com.gcd.nesting", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSLog(@"--1--");
        dispatch_sync(queue, ^{
            NSLog(@"--2--");
        });
        sleep(2);
        NSLog(@"--3--");
    });
    NSLog(@"--end--");
    // 死锁
}
#pragma mark - GCD 的队列组：dispatch_group
- (void)groupNotify {
    NSLog(@"currentThread--%@", [NSThread currentThread]);
    NSLog(@"--begin--");
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--1--%@", [NSThread currentThread]);
        }
    });
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--2--%@", [NSThread currentThread]);
        }
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--3--%@", [NSThread currentThread]);
        }
        NSLog(@"--end--");
    });
}

/**
 暂停当前线程（阻塞当前线程），等待指定的 group 中的任务执行完成后，才会往下继续执行。
 */
- (void)groupWait {
    NSLog(@"currentThread--%@", [NSThread currentThread]);
    NSLog(@"--begin--");
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--1--%@", [NSThread currentThread]);
        }
    });
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--2--%@", [NSThread currentThread]);
        }
    });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"--end--");
}

/**
 * dispatch_group_enter、dispatch_group_leave
 * 从dispatch_group_enter、dispatch_group_leave相关代码运行结果中可以看出：当所有任务执行完成之后，才执行 dispatch_group_notify 中的任务。这里的dispatch_group_enter、dispatch_group_leave组合，其实等同于dispatch_group_async。
 */
- (void)groupEnterAndLeave {
    NSLog(@"currentThread--%@", [NSThread currentThread]);
    NSLog(@"--begin--");
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--1--%@", [NSThread currentThread]);
        }
        dispatch_group_leave(group);
    });
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--2--%@", [NSThread currentThread]);
        }
        dispatch_group_leave(group);
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--3--%@", [NSThread currentThread]);
        }
        NSLog(@"--end--");
    });
}
#pragma mark - GCD信号量：dispatch_semaphore

/**
 semaphore 线程同步
 */
- (void)semaphoreSync {
    NSLog(@"currentThread--%@", [NSThread currentThread]);
    NSLog(@"--begin--");
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block int number = 0;
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"--1--%@", [NSThread currentThread]);
        dispatch_semaphore_signal(semaphore);
        [NSThread sleepForTimeInterval:1];
        number = 100;
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"--end--number=%d", number);
}


//  Dispatch Semaphore 线程安全和线程同步（为线程加锁）
/**
 非线程安全：不是用Semaphore
 初始化火车票数量，卖票窗口（非线程安全），开始买票
 */
- (void)initTicketStatusNotSave {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    self.ticketSurplusCount = 50;
    
    // queue1 代表北京火车票售卖窗口
    dispatch_queue_t queue1 = dispatch_queue_create("net.bujige.testQueue1", DISPATCH_QUEUE_SERIAL);
    // queue2 代表上海火车票售卖窗口
    dispatch_queue_t queue2 = dispatch_queue_create("net.bujige.testQueue2", DISPATCH_QUEUE_SERIAL);
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(queue1, ^{
        [weakSelf saleTicketNotSafe];
    });
    
    dispatch_async(queue2, ^{
        [weakSelf saleTicketNotSafe];
    });
}


/**
 * 售卖火车票(非线程安全)
 */
- (void)saleTicketNotSafe {
    while (1) {
        
        if (self.ticketSurplusCount > 0) {  //如果还有票，继续售卖
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%ld 窗口：%@", (long)self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        } else { //如果已卖完，关闭售票窗口
            NSLog(@"所有火车票均已售完");
            break;
        }
        
    }
}


/**
 * 线程安全：使用 semaphore 加锁
 * 初始化火车票数量、卖票窗口(线程安全)、并开始卖票
 */
- (void)initTicketStatusSave {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    self.semaphoreLock = dispatch_semaphore_create(1);
    
    self.ticketSurplusCount = 50;
    
    // queue1 代表北京火车票售卖窗口
    dispatch_queue_t queue1 = dispatch_queue_create("com.xingl.semaphore1", DISPATCH_QUEUE_SERIAL);
    // queue2 代表上海火车票售卖窗口
    dispatch_queue_t queue2 = dispatch_queue_create("com.xingl.semaphore2", DISPATCH_QUEUE_SERIAL);
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(queue1, ^{
        [weakSelf saleTicketSafe];
    });
    
    dispatch_async(queue2, ^{
        [weakSelf saleTicketSafe];
    });
}

/**
 * 售卖火车票(线程安全)
 */
- (void)saleTicketSafe {
    while (1) {
        // 相当于加锁
        dispatch_semaphore_wait(self.semaphoreLock, DISPATCH_TIME_FOREVER);
        
        if (self.ticketSurplusCount > 0) {  //如果还有票，继续售卖
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%ld 窗口：%@", (long)self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        } else { //如果已卖完，关闭售票窗口
            NSLog(@"所有火车票均已售完");
            
            // 相当于解锁
            dispatch_semaphore_signal(self.semaphoreLock);
            break;
        }
        
        // 相当于解锁
        dispatch_semaphore_signal(self.semaphoreLock);
    }
}


#pragma mark - GCD的其他方法
/**
 暂停(挂起)队列和恢复队列
 使用方法:
 dispatch_queue_t queue = dispatch_get_main_queue();
 dispatch_suspend(queue); //暂停队列
 dispatch_resume(queue);  //恢复队列
 */
- (void)suspendAndResume {
    dispatch_queue_t queue = dispatch_queue_create("GCD", DISPATCH_QUEUE_SERIAL);
    // 提交第一个block，延时2秒打印
    dispatch_async(queue, ^{
        sleep(5);
        NSLog(@"After 5 seconds...");
    });
    // 提交第二个block，延时2秒打印
    dispatch_async(queue, ^{
        sleep(5);
        NSLog(@"After 5 seconds...");
    });
    NSLog(@"sleep 1 second");
    sleep(1);
    //挂起队列
    NSLog(@"suspend...");
    dispatch_suspend(queue);
    // 延时10秒
    NSLog(@"sleep 10 seconds...");
    sleep(10);
    //恢复队列
    NSLog(@"resume...");
    dispatch_resume(queue);
}

/**
 栅栏方法
 在执行完栅栏前面的操作之后，才执行栅栏操作，最后再执行栅栏后边的操作。
 常用于数据库文件的读写
 */
- (void)barrier {
    //注意：栅栏函数不能使用全局并发队列
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    /** 官方文档
     The queue you specify should be a concurrent queue that you create yourself using the dispatch_queue_create function. If the queue you pass to this function is a serial queue or one of the global concurrent queues, this function behaves like the dispatch_async function.
     看出 在 dispatch_get_global_queue 里  dispatch_barrier_async 就相当于 dispatch_async。
     所以顺序是随机的。
     */
    dispatch_queue_t queue = dispatch_queue_create("com.xingl.barrier", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--1--%@", [NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--2--%@", [NSThread currentThread]);
        }
    });
    
    dispatch_barrier_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"--barrier--%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--3--%@", [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--end--%@", [NSThread currentThread]);
        }
    });
}

/**
 延时执行方法 dispatch_after
 */
- (void)after {
    NSLog(@"currentThread--%@", [NSThread currentThread]);
    NSLog(@"--begin--");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"after--%@", [NSThread currentThread]);
    });
}

/**
 一次性代码 dispatch_once
 */
- (void)once {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //值执行一次的代码（这里默认是线程安全的）
        NSLog(@"--once--");
    });
}

/**
 快速迭代方法 dispatch_apply
 */
- (void)apply {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSLog(@"--begin--");
    dispatch_apply(6, queue, ^(size_t index) {
        NSLog(@"%zd--%@", index, [NSThread currentThread]);
    });
    NSLog(@"--end--");
}

/**
 优先级
 */
- (void)priority {
    dispatch_queue_t queue1 = dispatch_queue_create("com.priority1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("com.priority2", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue3 = dispatch_queue_create("com.priority3", DISPATCH_QUEUE_SERIAL);
    dispatch_set_target_queue(queue1, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0));
    dispatch_async(queue1, ^{
        NSLog(@"1");
    });
    dispatch_async(queue2, ^{
        NSLog(@"2");
    });
    dispatch_async(queue3, ^{
        sleep(1);
        NSLog(@"3");
    });
}

- (void)timer {
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"--GCD-timer");
    });
    dispatch_resume(timer);
}
/**
 semaphore：自旋锁 其他线程正在执行我们的锁代码，其他线程就会进入死循环等地啊
 synchronized: 互斥锁 其他线程正在执行我们的锁代码，其他线程就会进入休眠

 */
- (void)semaphore {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); // 信号量 -1
        NSLog(@"1");
        sleep(2);
        NSLog(@"1 ok");
        dispatch_semaphore_signal(semaphore);// 信号量 +1
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"2");
        sleep(2);
        NSLog(@"2 ok");
        dispatch_semaphore_signal(semaphore);
    });
}
- (void)synchronized {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @synchronized(self) {
            NSLog(@"1");
            sleep(2);
            NSLog(@"1 ok");
        }
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @synchronized(self) {
            NSLog(@"2");
            sleep(2);
            NSLog(@"2 ok");
        }
    });
}
#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSDictionary *dic = self.dataArray[section];
    NSArray *arr = [dic objectForKey:@"data"];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"id";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    // cell ...
//    NSArray *titleArray = @[@"同步执行 + 串行队列", @"同步执行 + 并发队列", @"异步执行+ 串行", @"异步执行 + 并发队列", @"同步执行 + 主队列", @" 异步执行 + 主队列", @"栅栏方法", @"延时执行方法", @"一次性代码", @"快速迭代方法", @"GCD 的队列组：dispatch_group_notify", @"GCD 的队列组：dispatch_group_wait", @"GCD 的队列组：dispatch_group_enter、dispatch_group_leave"];
//    cell.textLabel.text = titleArray[indexPath.row];
    
    NSDictionary *dic = self.dataArray[indexPath.section];
    NSArray *arr = [dic objectForKey:@"data"];
    NSDictionary *subDic = [arr objectAtIndex:indexPath.row];
    cell.textLabel.text = subDic[@"title"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = self.dataArray[indexPath.section];
    NSArray *arr = [dic objectForKey:@"data"];
    NSDictionary *subDic = [arr objectAtIndex:indexPath.row];
    SEL sel = NSSelectorFromString(subDic[@"sel"]);
    
    [self performSelectorOnMainThread:sel withObject:nil waitUntilDone:YES];
}
/*设置标题头的名称*/
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *dic = self.dataArray[section];
    return dic[@"title"];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style: UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}

- (NSMutableArray *)masonryViewArray {
    
    if (!_masonryViewArray) {
        
        NSArray *titleArray = @[@"同步执行 + 串行队列", @"同步执行 + 并发队列", @"异步执行+ 串行", @"异步执行 + 并发队列", @"同步执行 + 主队列", @" 异步执行 + 主队列", @"栅栏方法", @"延时执行方法", @"一次性代码", @"快速迭代方法", @"GCD 的队列组：dispatch_group_notify", @"GCD 的队列组：dispatch_group_wait", @"GCD 的队列组：dispatch_group_enter、dispatch_group_leave"];
        
        NSArray *selArray = @[@"syncSerial", @"syncConcurrent", @"asyncSerial", @"asyncConcurrent",@"syncMain", @"asyncMain", @"barrier", @"after", @"once", @"apply", @"groupNotify", @"groupWait", @"groupEnterAndLeave"];
        
        _masonryViewArray = [NSMutableArray array];
        for (int i = 0; i < titleArray.count; i++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:titleArray[i] forState:(UIControlStateNormal)];
            btn.backgroundColor = RandomColor;
            SEL sel = NSSelectorFromString(selArray[i]);
            [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btn];
            [_masonryViewArray addObject:btn];
        }
    }
    return _masonryViewArray;
}

@end
