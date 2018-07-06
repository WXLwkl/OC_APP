//
//  NSObject+Runtime.h
//  OC_APP
//
//  Created by xingl on 2018/5/28.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Runtime)

- (NSArray *)ignoredNames;

- (void)xl_encode:(NSCoder *)aCoder;
- (void)xl_decode:(NSCoder *)aDecoder;
@end

// 宏定义归解档
#define CodingImplementation \
- (instancetype)initWithCoder:(NSCoder *)aDecoder {\
if (self = [super init]) {\
[self xl_decode:aDecoder];\
}\
return self;\
}\
\
- (void)encodeWithCoder:(NSCoder *)aCoder {\
[self xl_encode:aCoder];\
}
