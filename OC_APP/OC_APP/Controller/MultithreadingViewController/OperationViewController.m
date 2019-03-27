//
//  OperationViewController.m
//  OC_APP
//
//  Created by xingl on 2018/7/10.
//  Copyright © 2018年 兴林. All rights reserved.
//

/**
 
 NSOperation、NSOperationQueue是苹果提供的一套多线程解决方案。实际上NSOperation、NSOperationQueue是基于GCD更高一层的封装，完全面向对象。但是比GCD更简单易用、代码可读性也更高。
 NSOperation、NSOperationQueue的优势：
 1、可添加完成的代码块，在操作完成后执行。
 2、添加操作之间的依赖关系，方便控制执行顺序。
 3、设定操作执行的优先级。
 4、可以很方便的取消一个操作的执行。
 5、使用KVO观察对操作执行状态的更改：isExecuteing、isFinished、isCancelled。
 
 */


#import "OperationViewController.h"
#import "XLOperation.h"

@interface OperationViewController ()

@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, assign) NSInteger ticketSurplusCount;
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) NSMutableArray *masonryViewArray;

@end

@implementation OperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Operation";
    [self xl_setNavBackItem];
    
    [self test_masonry_vertical_fixSpace];
    
    
    XLLog(@"------");

}

// 垂直方向排列、固定控件间隔、控件高度不定
- (void)test_masonry_vertical_fixSpace {
    
    // 实现masonry垂直固定控件高度方法
    [self.masonryViewArray mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:20 leadSpacing:30+kNavHeight tailSpacing:30];
    
    // 设置array的水平方向的约束
    [self.masonryViewArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerX.mas_equalTo(self.view);
    }];
}


#pragma mark - NSOperation、NSOperationQueue 基本使用
/**
 NSOperation是个抽象类，不能直接用，只能使用它的子类。
    1、使用子类 NSInvocationOperation
    2、使用子类 NSBlockOperation
    3、自定义继承 NSOperation的子类，通过实现内部响应的方法类封装操作。
 */
/**
 使用子类 NSInvocationOperation
 在没有使用 NSOperationQueue、在主线程中单独使用使用子类 NSInvocationOperation 执行一个操作的情况下，
 操作是在当前线程执行的，并没有开启新线程。
 
 如果在其他线程中执行操作，则打印结果为其他线程。
 [NSThread detachNewThreadSelector:@selector(useInvocationOperation) toTarget:self withObject:nil];
 */
- (void)useInvocationOperation {
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    [op start];
}
- (void)task1 {
    for (int i = 0; i < 2; i++) {
        [NSThread sleepForTimeInterval:1];
        NSLog(@"--1--%@", [NSThread currentThread]);
    }
}


/**
 使用子类 NSBlockOperation
 同 NSInvocationOperation 一样
 */
- (void)useBlockOperation {
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--1--%@", [NSThread currentThread]);
        }
    }];
    [op start];
}
/**
 使用子类 NSBlockOperation
 调用方法 AddExecutionBlock:
 通过 addExecutionBlock: 就可以为 NSBlockOperation 添加额外的操作。这些操作（包括 blockOperationWithBlock 中的操作）可以在不同的线程中同时（并发）执行。只有当所有相关的操作已经完成执行时，才视为完成。
 如果添加的操作多的话，blockOperationWithBlock: 中的操作也可能会在其他线程（非当前线程）中执行，这是由系统决定的，并不是说添加到 blockOperationWithBlock: 中的操作一定会在当前线程中执行。（可以使用 addExecutionBlock: 多添加几个操作试试）。
 
 一般情况下，如果一个 NSBlockOperation 对象封装了多个操作。NSBlockOperation 是否开启新线程，取决于操作的个数。如果添加的操作的个数多，就会自动开启新线程。当然开启的线程数是由系统来决定的。
 */
- (void)useBlockOperationAddExecutionBlock {
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--1--%@", [NSThread currentThread]);
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--2--%@", [NSThread currentThread]);
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--3--%@", [NSThread currentThread]);
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--4--%@", [NSThread currentThread]);
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--5--%@", [NSThread currentThread]);
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--6--%@", [NSThread currentThread]);
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--7--%@", [NSThread currentThread]);
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--8--%@", [NSThread currentThread]);
        }
    }];
    [op start];
}

/**
 使用自定义继承NSOperation的子类
 在没有使用 NSOperationQueue、在主线程单独使用自定义继承自 NSOperation 的子类的情况下，是在主线程执行操作，并没有开启新线程。
 */
- (void)useCustomOpetation {
    XLOperation *op = [[XLOperation alloc] init];
    [op start];
}

#pragma mark - NSOperation加入NSOperationQueue队列中
/**
 NSOperationQueue 一共有两种队列：主队列、自定义队列。其中自定义队列同时包含 串行、并发功能。
 主队列： NSOperationQueue *queue = [NSOperationQueue mainQueue];
   凡是添加到主队列中的操作，都会放到主线程中执行。
 
 自定义：NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    添加到这种队列中的操作，就会自动放到子线程中执行。
    同时包含了：串行、并发功能。
 */

/**
 使用 addOperation: 将操作加入到操作队列中
 使用 addOperationWithBlock: 将操作加入到操作队列后能够开启新线程，进行并发执行。
 */
- (void)addOperationToQueue {
    // 创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 创建操作
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task2) object:nil];
    
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--3--%@", [NSThread currentThread]);
        }
    }];
    [op3 addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--4--%@", [NSThread currentThread]);
        }
    }];
    // 添加所有操作到队列中
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
}
- (void)task2 {
    for (int i = 0; i < 2; i++) {
        [NSThread sleepForTimeInterval:1];
        NSLog(@"--2--%@", [NSThread currentThread]);
    }
}

#pragma mark - NSOperationQueue 控制串行执行、并发执行
/**
 maxConcurrentOperationCount，叫做最大并发操作数
 maxConcurrentOperationCount 控制的不是并发线程的数量，而是一个队列中同时能并发执行的最大操作数。
 而且一个操作也并非只能在一个线程中运行。开辟新线程。
 */
/** 设置 MaxConcurrentOperationCount（最大并发操作数） */
- (void)setMaxConcurrentOperationCount {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 设置最大并发操作数
    queue.maxConcurrentOperationCount = 2;
    NSLog(@"--1--%@---%d", [NSThread currentThread], [NSThread isMainThread]);
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--1--%@", [NSThread currentThread]);
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--2--%@", [NSThread currentThread]);
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--3--%@", [NSThread currentThread]);
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--4--%@", [NSThread currentThread]);
        }
    }];
}

#pragma mark - NSOperation 操作依赖
- (void)addDependency {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--1--%@", [NSThread currentThread]);
        }
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"--2--%@", [NSThread currentThread]);
        }
    }];
    // 添加依赖
    [op2 addDependency:op1]; // 让op2依赖于op1，则先执行op1 再执行op2
    [queue addOperation:op1];
    [queue addOperation:op2];
}
#pragma mark - NSOperation 优先级
// queuePriority属性
// 对于添加到队列中的操作，首先进入准备就绪的状态（就绪状态取决于操作之间的依赖关系），然后进入就绪状态的操作的开始执行顺序（非结束执行顺序）由操作之间相对的优先级决定（优先级是操作对象自身的属性）
#pragma mark - NSOperation NSOperationQueue 线程间的通信
// 通过线程间的通信，先在其他线程中执行操作，等操作执行完了之后再回到主线程执行主线程的相应操作。
- (void)communication {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"--1--%@", [NSThread currentThread]);
        }
        // 回到主线程
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            for (int i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:1];
                NSLog(@"--2--%@", [NSThread currentThread]);
            }
        }];
    }];
}

#pragma mark - 线程同步和线程安全
- (void)initTicketStatusNotSave {
    NSLog(@"currentThread--%@", [NSThread currentThread]);
    self.ticketSurplusCount = 50;
    NSOperationQueue *queue1 = [[NSOperationQueue alloc] init];
    queue1.maxConcurrentOperationCount = 1;
    
    NSOperationQueue *queue2 = [[NSOperationQueue alloc] init];
    queue2.maxConcurrentOperationCount = 1;
    
    __weak typeof(self) weakSelf = self;
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf saleTicketNotSafe];
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf saleTicketNotSafe];
    }];
    
    [queue1 addOperation:op1];
    [queue2 addOperation:op2];
}

- (void)saleTicketNotSafe {
    while (1) {
        if (self.ticketSurplusCount > 0) {
            // 如果有票 继续出售
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%ld 窗口：%@", (long)self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:1];
        } else {
            NSLog(@"票售完了");
            break;
        }
    }
}

/**
 线程安全解决方案：可以给线程加锁，在一个线程执行该操作的时候，不允许其他线程进行操作。
    iOS 实现线程加锁有很多种方式：@synchronized、 NSLock、NSRecursiveLock、NSCondition、NSConditionLock、pthread_mutex、dispatch_semaphore、OSSpinLock、atomic(property) set/get等等各种方式。
 */
- (void)initTicketStatusSave {
    NSLog(@"currentThread--%@", [NSThread currentThread]);
    self.ticketSurplusCount = 50;
    self.lock = [[NSLock alloc] init];
    
    NSOperationQueue *queue1 = [[NSOperationQueue alloc] init];
    queue1.maxConcurrentOperationCount = 1;
    
    NSOperationQueue *queue2 = [[NSOperationQueue alloc] init];
    queue2.maxConcurrentOperationCount = 1;
    
    __weak typeof(self) weakSelf = self;
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf saleTicketSafe];
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf saleTicketSafe];
    }];
    [queue1 addOperation:op1];
    [queue2 addOperation:op2];
}
- (void)saleTicketSafe {
    while (1) {
        
        [self.lock lock];
        
        if (self.ticketSurplusCount > 0) {
            //如果还有票，继续售卖
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数:%ld 窗口:%@", (long)self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        }
        
        [self.lock unlock];
        
        if (self.ticketSurplusCount <= 0) {
            NSLog(@"票售完了");
            break;
        }
    }
}
#pragma mark - getter
- (NSMutableArray *)masonryViewArray {
    
    if (!_masonryViewArray) {
        
        NSArray *titleArray = @[@"子类 NSInvocationOperation", @"子类 NSBlockOperation", @"子类 NSBlockOperation + AddExecutionBlock", @"自定义继承NSOperation的子类", @"将操作加入到操作队列中",@"NSOperationQueue控制串行、并发", @"NSOperation 操作依赖", @"线程间通信", @"非线程安全", @"线程安全"];
        
        NSArray *selArray = @[@"useInvocationOperation", @"useBlockOperation",@"useBlockOperationAddExecutionBlock",@"useCustomOpetation", @"addOperationToQueue", @"setMaxConcurrentOperationCount", @"addDependency", @"communication", @"initTicketStatusNotSave", @"initTicketStatusSave"];
        
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
