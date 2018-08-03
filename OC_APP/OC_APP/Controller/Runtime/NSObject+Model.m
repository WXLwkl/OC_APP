//
//  NSObject+Model.m
//  OC_APP
//
//  Created by xingl on 2018/8/2.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "NSObject+Model.h"

@implementation NSObject (Model)

+ (instancetype)xl_modelWithDict:(NSDictionary *)dict {
    
    id model = [[self alloc]init];
    
    // runtime:遍历模型中所有成员属性,去字典中查找
    // 属性定义在哪,定义在类,类里面有个属性列表(数组)
    
    // 遍历模型所有成员属性
    // ivar:成员属性
    // class_copyIvarList:把成员属性列表复制一份给你
    // Ivar *:指向Ivar指针
    // Ivar *:指向一个成员变量数组
    // class:获取哪个类的成员属性列表
    // count:成员属性总数
    
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList(self, &count);
    for (int i = 0; i < count; i++) {
        // 获取成员属性
        Ivar ivar = ivarList[i];
        // 获取成员名
        NSString *propertyName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        // 获取成员属性类型
        NSString *propertyType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        // 获取key
        NSString *key = [propertyName substringFromIndex:1];
        // 获取字典的value
        id value = dict[key];
        // 给模型的属性赋值
        // value:字典的值
        // key:属性名

// user:NSDictionary
        //** '二级转换'**
        // 值是字典,成员属性的类型不是字典,才需要转换成模型
        
        if ([value isKindOfClass:[NSDictionary class]] && ![propertyType containsString:@"NS"]) {
            // 需要字典转换成模型
            // 转换成哪个类型

            // @"Cat"
            NSRange range = [propertyType rangeOfString:@"\""];
            propertyType = [propertyType substringFromIndex:range.location + range.length];
            // Cat"
            range = [propertyType rangeOfString:@"\""];
            propertyType = [propertyType substringToIndex:range.location];
            // 字符串截取
            
            // 获取需要转换类的类对象
            Class modelClass = NSClassFromString(propertyType);
            if (modelClass) {
                value = [modelClass xl_modelWithDict:value];
            }
        }
// 三级转换：NSArray中也是字典，把数组中的字典转换成模型.
        // 判断值是否是数组
        if ([value isKindOfClass:[NSArray class]]) {
            if ([self respondsToSelector:@selector(xl_arrayContainModelClass)]) {
                id idSelf = self;
                // 获取数组中字段对应的模型
                NSString *type = [idSelf xl_arrayContainModelClass][key];
                // 生成模型
                Class classModel = NSClassFromString(type);
                NSMutableArray *mArr = [NSMutableArray array];
                // 遍历字段数组，生成模型数组
                for (NSDictionary *dict in value) {
                    id models = [classModel xl_modelWithDict:dict];
                    [mArr addObject:models];
                }
                // 把模型数组赋值给value
                value = mArr;
            }
        }
        
        if (value) {
            // kvc 赋值： 不能传空
            [model setValue:value forKey:key];
        }
    }
    
    return model;
}

@end
