//
//  NSString+Json.m
//  OC_APP
//
//  Created by xingl on 2017/8/8.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "NSString+Json.h"

@implementation NSString (Json)

- (id)xl_jsonObject{
    
    if (!self) {
        
        return nil;
    }
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    return [data xl_jsonObject];
}

@end

@implementation NSData (Json)

- (id)xl_jsonObject{
    
    if (!self) {
        
        return nil;
    }
    
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:self
                                                options:NSJSONReadingMutableContainers
                                                  error:&error];
    if (error) {
        
        NSLog(@"error==%@",error);
        return nil;
    }
    return result;
}
@end

@implementation NSObject (Json)

- (NSData *)xl_jsonData{
    
    if (!self||![NSJSONSerialization isValidJSONObject:self]) {
        
        return nil;
    }
    
    NSError *error = nil;
    NSData *result = [NSJSONSerialization dataWithJSONObject:self
                                                     options:kNilOptions error:&error];
    
    if (error) {
        
        NSLog(@"error==%@",error);
        return nil;
    }
    
    return result;
}

@end



@implementation NSDictionary (LTJson)

- (NSString *)xl_jsonString{
    
    NSData *result = [self xl_jsonData];
    
    if (!result) {
        
        return nil;
    }
    
    NSString *resultString = [[NSString alloc]initWithData:result
                                                  encoding:NSUTF8StringEncoding];
    
    return resultString;
}
@end

@implementation NSArray (Json)

- (NSString *)xl_jsonString{
    
    NSData *result = [self xl_jsonData];
    
    if (!result) {
        
        return nil;
    }
    
    NSString *resultString = [[NSString alloc]initWithData:result
                                                  encoding:NSUTF8StringEncoding];
    
    return resultString;
}
@end
