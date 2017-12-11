//
//  LinkageViewController.m
//  OC_APP
//
//  Created by xingl on 2017/12/8.
//  Copyright © 2017年 兴林. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface CollectionCategoryModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray *subcategories;

@end

@interface SubCategoryModel : NSObject

@property (nonatomic, copy) NSString *icon_url;
@property (nonatomic, copy) NSString *name;

@end
