//
//  NSObject+Common.h
//  OC_APP
//
//  Created by xingl on 2017/8/15.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Common)

- (NSDictionary *)propertyDictionary;

+ (BOOL)XL_isValidObj:(NSObject *)obj;

@end
