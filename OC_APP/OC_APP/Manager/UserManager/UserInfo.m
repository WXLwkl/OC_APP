//
//  UserInfo.m
//  OC_APP
//
//  Created by xingl on 2017/5/26.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "UserInfo.h"

#define UserFile [DocumentPath stringByAppendingPathComponent:@"User.xml"]

@implementation UserInfo MJExtensionCodingImplementation

//没有特殊定制可以用这个方法。
//IMPLEMENT_SYNTHESIZE_SINGLETON_FOR_CLASS(UserInfo)

static UserInfo *info = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        info = [NSKeyedUnarchiver unarchiveObjectWithFile:UserFile];
        if (!info) {
            info = [[self alloc] init];  //用这个方法必然会调用 + allocWithZone 这个方法。
        }
    });
    return info;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        info = [super allocWithZone:zone];
    });
    return info;
}
- (id)copyWithZone:(NSZone *)zone{
    return info;
}


- (void)archive {
    [NSKeyedArchiver archiveRootObject:self toFile:UserFile];
}

@end
