//
//  Person.m
//  OC_APP
//
//  Created by xingl on 2018/5/28.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "Person.h"
#import <objc/message.h>

@interface Person () <NSCoding>

@end

@implementation Person

CodingImplementation

//不需要归解档
- (NSArray *)ignoredNames {
    return @[@"_native", @"_education"];
}

//- (void)encodeWithCoder:(NSCoder *)aCoder {
//    unsigned int count;
//    // 获得指向当前类的所有属性的指针
//    objc_property_t *properties = class_copyPropertyList([self class], &count);
//    for (NSInteger i = 0; i < count; i++) {
//        // 获取指向当前类的一个属性的指针
//        objc_property_t property = properties[i];
//        // 获取C字符串属性名
//        const char *name = property_getName(property);
//        // C字符串转OC字符串
//        NSString *propertyName = [NSString stringWithUTF8String:name];
//        // 通过关键词取值
//        NSString *propertyValue = [self valueForKey:propertyName];
//        
//        
//        //编码属性
//        [aCoder encodeObject:propertyValue forKey:propertyName];
//    }
//    //释放
//    free(properties);
//}
//- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
//    unsigned int count;
//    objc_property_t *properties = class_copyPropertyList([self class], &count);
//    for (NSInteger i = 0; i < count; i++) {
//        objc_property_t property = properties[i];
//        const char *name = property_getName(property);
//        NSString *propertyName = [NSString stringWithUTF8String:name];
//        
//        
//        // 解码属性值
//        NSString *propertyValue = [aDecoder decodeObjectForKey:propertyName];
//        [self setValue:propertyValue forKey:propertyName];
//        // 这两步就相当于以前的 self.age = [aDecoder decodeObjectForKey:@"_age"];
//    }
//    free(properties);
//    return self;
//}

- (NSString *)description {
    return [self descriptionString];
}

- (NSString *)descriptionString {
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    unsigned int count;
    
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        
        objc_property_t property = properties[i];
        
        NSString *proName = @(property_getName(property));
        
        id value = [self valueForKey:proName]?:@"nil";
        
        [dictionary setObject:value forKey:proName];
        
    }
    
    free(properties);
    
    return [NSString stringWithFormat:@"<%@: %p> -- %@",[self class], self,dictionary];
}
// 当这个类内调用了一个没有实现的类方法
//+ (BOOL)resolveClassMethod:(SEL)sel

// 当这个类内调用了一个没有实现的实例方法
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSLog(@"-->%@", NSStringFromSelector(sel));
    
    class_addMethod([Person class], sel, (IMP)func, "v@:@");
    
    return [super resolveInstanceMethod:sel];
}
void func(id self, SEL _cmd, NSString *str) {
    NSLog(@"----动态添加的方法实现---%@-", str);
}

//- (void)eat {
//    NSLog(@"-- 吃 --");
//}
- (void)sleep{}
- (void)work:(NSString *)name time:(NSString *)time {}

@end
