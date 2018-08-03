//
//  Book.h
//  OC_APP
//
//  Created by xingl on 2018/8/2.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

@property (nonatomic,  copy) NSString *name;
@property (nonatomic,  copy) NSString *publisher;
@property (nonatomic,assign) double price;

@end
