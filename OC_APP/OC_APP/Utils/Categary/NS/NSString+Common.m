//
//  NSString+Common.m
//  OC_APP
//
//  Created by xingl on 2017/6/10.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "NSString+Common.h"

@implementation NSString (Common)


NSString *XL_FilterString(id obj){
    
    if (obj == nil) {
        
        return @"";
    }
    
    if ([obj isKindOfClass:[NSString class]]) {
        
        return [NSString stringWithFormat:@"%@",obj];
        
    }else if([obj isKindOfClass:[NSNumber class]]){
        
        return [NSString stringWithFormat:@"%@",obj];
    }
    return @"";
    
}

BOOL XL_IsEmptyString(NSObject *obj){
    
    BOOL isEmpty = YES;
    
    if (!obj || ![obj isKindOfClass:[NSString class]]) {
        
        isEmpty = YES;
    }
    else{
        
        isEmpty = NO;
    }
    
    if (!isEmpty) {
        
        NSString *string = (NSString *)obj;
        
        if ([string length] == 0
            || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
            
            isEmpty = YES;
        }
        else{
            
            isEmpty = NO;
        }
    }
    
    return isEmpty;
}


@end
