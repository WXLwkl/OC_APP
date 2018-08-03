//
//  User.h
//  OC_APP
//
//  Created by xingl on 2018/8/2.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cat.h"
#import "Book.h"
@interface User : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) double height;
@property (nonatomic,assign) int age;

// 属性是一个对象
@property (nonatomic,strong) Cat *cat;
// 属性是一个数组
@property (nonatomic,strong) NSArray *books;


@end
