//
//  NSString+Json.h
//  OC_APP
//
//  Created by xingl on 2017/8/8.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Json)

- (id)xl_jsonObject;

@end

@interface NSData (Json)

- (id)xl_jsonObject;

@end

@interface NSObject (Json)

- (NSData *)xl_jsonData;

@end


@interface NSDictionary (Json)

- (NSString *)xl_jsonString;

@end

@interface NSArray (Json)

- (NSString *)xl_jsonString;

@end
