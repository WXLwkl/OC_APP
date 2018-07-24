//
//  Person.h
//  OC_APP
//
//  Created by xingl on 2018/5/28.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Runtime.h"

@protocol PersonDelegate <NSObject>

- (void)personToWork;
@end

@interface Person : NSObject 

@property (nonatomic, weak) id<PersonDelegate> delegate;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, assign) int age;
@property (nonatomic, assign) float height;
@property (nonatomic, copy) NSString *job;
@property (nonatomic, copy) NSString *native; //籍贯
@property (nonatomic, copy) NSString *education;

//- (void)eat;
- (void)sleep;
- (void)work:(NSString *)name time:(NSString *)time;

@end
