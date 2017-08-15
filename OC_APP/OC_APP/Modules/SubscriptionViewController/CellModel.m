//
//  CellModel.m
//  OC_APP
//
//  Created by xingl on 2017/8/10.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "CellModel.h"

@implementation CellModel

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [CellModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"detailArray" : [CellModel class]
                     };
        }];
    }
    
    return self;
}


@end
