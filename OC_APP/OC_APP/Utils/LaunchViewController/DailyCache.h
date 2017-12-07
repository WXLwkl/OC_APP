//
//  DailyCache.h
//  OC_APP
//
//  Created by xingl on 2017/12/6.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyCache : NSObject

+ (instancetype)shareInstance;

/**
 传入时间判断是否能够显示广告

 @param time 当前时间
 @return 是否可以显示广告
 */
- (BOOL)judgeWhetherShowAd:(NSString *)time;

/**
 往NSUserDefaults里写数据
 */
- (void)writeWithKey:(NSString *)key value:(id)value;

@end
