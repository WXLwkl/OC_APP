//
//  AppDelegate.m
//  Demo
//
//  Created by 兴林 on 2016/10/12.
//  Copyright © 2016年 兴林. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+AppService.h"

#import "MainNavigationController.h"
#import "HomeViewController.h"

#import "RequestManager.h"

@interface AppDelegate () {
    NSInteger count;
}
@property(strong, nonatomic)NSTimer *mTimer;
@property(assign, nonatomic)UIBackgroundTaskIdentifier backIden;
@property (nonatomic, strong, nullable) UIVisualEffectView *visualEffectView;
@end

@implementation AppDelegate

extern CFAbsoluteTime startTime;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSLog(@"Launched time = %f 秒", (CFAbsoluteTimeGetCurrent()) - startTime);
    
    //初始化window
    [self initWindowWithGuideOrAD];
    
    count = 0;
    
    NSLog(@"----------");
    return YES;
}





- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.visualEffectView.alpha = 0;
    self.visualEffectView.frame = self.window.frame;
    [self.window addSubview:self.visualEffectView];
    [UIView animateWithDuration:0.25 animations:^{
        self.visualEffectView.alpha = 1;
    }];
    

}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    if (!_mTimer) {
        _mTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_mTimer forMode:NSDefaultRunLoopMode];
    }
    [self beginTask];
}
//计时
-(void)countAction{
    NSLog(@"%li",(long)count++);
}
//申请后台
-(void)beginTask
{
    NSLog(@"begin=============");
    _backIden = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        //在时间到之前会进入这个block，一般是iOS7及以上是3分钟。按照规范，在这里要手动结束后台，你不写也是会结束的（据说会crash）
        NSLog(@"将要挂起=============");
        [self endBack];
    }];
}
//注销后台
-(void)endBack
{
    NSLog(@"end=============");
    [[UIApplication sharedApplication] endBackgroundTask:_backIden];
    _backIden = UIBackgroundTaskInvalid;
    [_mTimer invalidate];
    _mTimer = nil;
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    NSLog(@"进入前台");
    [self endBack];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UIView animateWithDuration:0.25 animations:^{
        self.visualEffectView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.visualEffectView removeFromSuperview];
    }];
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    NSLog(@"applicationWillTerminate");
}


@end
