//
//  NSObject+xl_KVO.h
//  OC_APP
//
//  Created by xingl on 2018/5/14.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLObserverInfo.h"

@interface NSObject (xl_KVO)

- (void)xl_addObserver:(id)observer key:(NSString *)key callback:(XLKVOCallback)callback;

- (void)xl_removeObserver:(id)observer key:(NSString *)key;

@end
