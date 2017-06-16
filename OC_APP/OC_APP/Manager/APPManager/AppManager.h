//
//  AppManager.h
//  OC_APP
//
//  Created by xingl on 2017/6/8.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 包含应用层的相关服务
 */
@interface AppManager : NSObject

#pragma mark - ——————— APP启动接口 ————————
+ (UIViewController *)appStartWithMainViewController:(UIViewController *)mainVC guideImages:(NSArray *)array;

@end
