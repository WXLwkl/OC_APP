//
//  NSObject+Model.h
//  OC_APP
//
//  Created by xingl on 2018/8/2.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ModelDelegate <NSObject>
// 数组中都是什么类型的模型对象
+ (NSDictionary *)xl_arrayContainModelClass;

@end


@interface NSObject (Model)

+ (instancetype)xl_modelWithDict:(NSDictionary *)dict;

@end
