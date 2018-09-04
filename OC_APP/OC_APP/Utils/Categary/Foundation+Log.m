//
//  Foundation+Log.m
//  OC_APP
//
//  Created by xingl on 2017/5/26.
//  Copyright © 2017年 兴林. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@implementation UIView(Log)
+ (NSString *)searchAllSubviews:(UIView *)superview {
    NSMutableString *xml = [NSMutableString string];
    
    NSString *class = NSStringFromClass(superview.class);
    class = [class stringByReplacingOccurrencesOfString:@"_" withString:@""];
    [xml appendFormat:@"<%@ frame=\"%@\">\n", class, NSStringFromCGRect(superview.frame)];
    for (UIView *childView in superview.subviews) {
        NSString *subviewXml = [self searchAllSubviews:childView];
        [xml appendString:subviewXml];
    }
    [xml appendFormat:@"</%@>\n", class];
    return xml;
}

- (NSString *)description {
    return [UIView searchAllSubviews:self];
}
@end

@implementation NSDictionary (Log)
- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *str = [NSMutableString string];

    [str appendString:@"{\n"];

    // 遍历字典的所有键值对
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [str appendFormat:@"\t%@ = %@,\n", key, obj];
    }];

    [str appendString:@"}"];

    // 查出最后一个,的范围
    NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length) {
        // 删掉最后一个,
        [str deleteCharactersInRange:range];
    }

    return str;
}
//- (NSString *)descriptionWithLocale:(id)locale {
//    return self.debugDescription;
//}
//有些时候不走上面的方法，而是走这个方法
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    return self.debugDescription;
}
//用po打印调试信息时会调用该方法
- (NSString *)debugDescription {
    NSError *error = nil;
    //字典转成json
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted  error:&error];
    //如果报错了就按原先的格式输出
    if (error) {
        return [super debugDescription];
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end

@implementation NSArray (Log)
- (NSString *)descriptionWithLocale:(id)locale {

    NSMutableString *str = [NSMutableString string];

    [str appendString:@"[\n"];

    // 遍历数组的所有元素
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [str appendFormat:@"\t%@,\n", obj];
    }];

    [str appendString:@"]"];

    // 查出最后一个,的范围
    NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length) {
        // 删掉最后一个,
        [str deleteCharactersInRange:range];
    }

    return str;
}


//打印到控制台时会调用该方法
//- (NSString *)descriptionWithLocale:(id)locale {
//    return self.debugDescription;
//}

//有些时候不走上面的方法，而是走这个方法
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    return self.debugDescription;
}

//用po打印调试信息时会调用该方法
- (NSString *)debugDescription {
    
    NSError *error = nil;
    
    //数组转成json格式字符串
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted  error:&error];
    //如果报错了就按原先的格式输出
    if (error) {
        return [super debugDescription];
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end
