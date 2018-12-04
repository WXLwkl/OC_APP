//
//  UIViewController+Router.h
//  OC_APP
//
//  Created by xingl on 2018/12/4.
//  Copyright © 2018 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Router)

/** 跳转后控制器能拿到的url */
@property (nonatomic, strong) NSURL *originUrl;

/** 跳转后控制器能拿到的参数 */
@property (nonatomic, strong) NSDictionary *params;

/** 回调block */
@property (nonatomic, strong) void(^valueBlock)(id value);

/**
 根据参数创建控制器

 @param urlString 自定义url 可以带参数，但要保证query无值，否则会被取代
 @param query 参数
 @return 控制器
 */
+ (UIViewController *)initFromString:(NSString *)urlString withQuery:(NSDictionary *)query;

@end
