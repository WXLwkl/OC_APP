//
//  UserInfo.h
//  OC_APP
//
//  Created by xingl on 2017/5/26.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
#import "Macros.h"
@interface UserInfo : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userAge;

//DECLARE_SYNTHESIZE_SINGLETON_FOR_CLASS
+ (instancetype)sharedInstance;
- (void)archive;
@end
