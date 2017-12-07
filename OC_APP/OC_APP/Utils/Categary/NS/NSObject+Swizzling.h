//
//  NSObject+Swizzling.h
//  OC_APP
//
//  Created by xingl on 2017/11/21.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzling)

/**
 方法转换

 @param originalSelector 系统原有方法
 @param swizzledSelector 转换后的方法
 */
+ (void)xl_methodSwizzlingWithOriginalSelector:(SEL)originalSelector
                         bySwizzledSelector:(SEL)swizzledSelector;

@end
