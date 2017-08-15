//
//  GroupModel.m
//  OC_APP
//
//  Created by xingl on 2017/8/11.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "GroupModel.h"

@implementation GroupModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    NSLog(@"KVC赋值防崩");
}

@end
