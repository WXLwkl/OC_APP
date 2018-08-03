//
//  Cat.h
//  OC_APP
//
//  Created by xingl on 2018/8/2.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fish.h"

@interface Cat : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) double price;
// 属性是一个对象
@property (nonatomic,strong) Fish *fish;

@end
