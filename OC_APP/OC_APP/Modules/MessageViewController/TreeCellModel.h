//
//  TreeCellModel.h
//  OC_APP
//
//  Created by xingl on 2017/8/15.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeCellModel : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, assign) NSUInteger belowCount;

@property (nonatomic, strong) TreeCellModel *supermodel;

@property (nonatomic, strong) NSMutableArray *submodels;

+ (instancetype)modelWithDic:(NSDictionary *)dic;
- (NSArray *)open;
- (void)closeWithSubModels:(NSArray *)submodels;

@end
