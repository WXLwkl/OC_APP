//
//  TableViewInterceptor.m
//  OC_APP
//
//  Created by xingl on 2017/12/14.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "TableViewInterceptor.h"

@implementation TableViewInterceptor

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.middleMan respondsToSelector:aSelector]) return self.middleMan;
    if ([self.receiver respondsToSelector:aSelector]) return self.receiver;
    return [super forwardingTargetForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([self.middleMan respondsToSelector:aSelector]) return YES;
    if ([self.receiver respondsToSelector:aSelector]) return YES;
    return [super respondsToSelector:aSelector];
}

@end
