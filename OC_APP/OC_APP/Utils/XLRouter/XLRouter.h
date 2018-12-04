//
//  XLRouter.h
//  OC_APP
//
//  Created by xingl on 2018/11/29.
//  Copyright © 2018 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewController+Router.h"

@interface XLRouter : NSObject

/**
 进入控制器

 @param urlString 自定义url
 @return 进入的控制器
 */
+ (UIViewController *)openUrl:(NSString *)urlString;

/**
 进入控制器

 @param urlString 自定义url 如果有参数 会被query替代
 @param query 参数
 @return 将要进入的控制器
 */
+ (UIViewController *)openUrl:(NSString *)urlString query:(NSDictionary *)query;


/** 传入控制器名称,获取控制器实例 */
+ (UIViewController *)getControllerFromClassName:(NSString *)urlString;

@end

extern NSString * const kRouterSchemePresent;
extern NSString * const kRouterSchemePush;
