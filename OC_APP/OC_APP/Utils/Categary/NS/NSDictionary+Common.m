//
//  NSDictionary+Common.m
//  OC_APP
//
//  Created by xingl on 2017/8/15.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "NSDictionary+Common.h"

@implementation NSDictionary (Common)


- (NSString *)xl_getJSONStringForDictionary {
    NSData *paramsJSONData = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
    return [[NSString alloc] initWithData:paramsJSONData encoding:NSUTF8StringEncoding];
}


@end

BOOL XL_isEmptyDictionary(NSObject *obj){
    
    BOOL isEmpty = ![NSDictionary XL_isValidObj:obj];
    
    if (!isEmpty) {
        
        isEmpty = [(NSDictionary *)obj count] == 0;
    }
    
    return isEmpty;
}
