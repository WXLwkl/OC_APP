//
//  ArrayDataSource.h
//  OC_APP
//
//  Created by xingl on 2018/1/4.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TableViewCellConfigureBlock)(id cell, id item);

@interface ArrayDataSource : NSObject <UITableViewDataSource>

- (id)initWithItems:(NSArray *)anItems cellIdentifier:(NSString *)identifier configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;
@end
