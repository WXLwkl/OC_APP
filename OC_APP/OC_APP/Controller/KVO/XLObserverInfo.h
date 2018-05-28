//
//  XLObserverInfo.h
//  OC_APP
//
//  Created by xingl on 2018/5/14.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^XLKVOCallback)(id observer, NSString *key, id oldValue, id newValue);

@interface XLObserverInfo : NSObject

/** 监听者 */
@property (nonatomic, weak) id observer;

@property (nonatomic, copy) NSString *key;

@property (nonatomic, copy) XLKVOCallback callback;

- (instancetype)initWithObserver:(id)observer key:(NSString *)key callback:(XLKVOCallback)callback;

@end
