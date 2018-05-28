//
//  XLObserverInfo.m
//  OC_APP
//
//  Created by xingl on 2018/5/14.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "XLObserverInfo.h"

@implementation XLObserverInfo

- (instancetype)initWithObserver:(id)observer key:(NSString *)key callback:(XLKVOCallback)callback {
    
    if (self = [super init]) {
        _observer = observer;
        _key = key;
        _callback = callback;
    }
    return self;
}

@end
