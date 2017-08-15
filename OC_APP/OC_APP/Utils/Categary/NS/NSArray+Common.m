//
//  NSArray+Common.m
//  OC_APP
//
//  Created by xingl on 2017/8/15.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "NSArray+Common.h"

@implementation NSArray (Common)




@end

BOOL XL_isEmptyArray(NSObject *obj){
    
    BOOL isEmpty = ![NSArray XL_isValidObj:obj];
    
    if (!isEmpty) {
        
        isEmpty = [(NSArray *)obj count] == 0;
    }
    
    return isEmpty;
}
