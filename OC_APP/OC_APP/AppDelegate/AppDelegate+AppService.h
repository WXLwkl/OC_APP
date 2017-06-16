//
//  AppDelegate+AppService.h
//  OC_APP
//
//  Created by xingl on 2017/6/8.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "AppDelegate.h"
/**
 包含第三方 和 应用内业务的实现，减轻入口代码压力
 */
@interface AppDelegate (AppService)

//初始化window
- (void)initWindowWithGuideOrAD;


+ (AppDelegate *)shareAppDelegate;

/**
 当前顶层控制器
 */
- (UIViewController*)getCurrentVC;

- (UIViewController*)getCurrentUIVC;


@end
