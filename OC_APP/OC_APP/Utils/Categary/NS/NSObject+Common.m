//
//  NSObject+Common.m
//  OC_APP
//
//  Created by xingl on 2017/8/15.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "NSObject+Common.h"

@implementation NSObject (Common)


- (NSDictionary *)propertyDictionary {
    
    //创建可变字典
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int outCount;
    objc_property_t *propertys = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t prop = propertys[i];
        NSString *propName = [[NSString alloc] initWithCString:property_getName(prop) encoding:NSUTF8StringEncoding];
        id propValue = [self valueForKey:propName];
        if (propValue) {
            dic[propName] = propValue;
        }
    }
    free(propertys);
    return dic;
}

+ (BOOL)XL_isValidObj:(NSObject *)obj {
    if (!obj || ![obj isKindOfClass:[self class]]) {
        return NO;
    }
    return YES;
}
@end
