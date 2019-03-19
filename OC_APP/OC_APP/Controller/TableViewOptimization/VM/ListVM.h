//
//  ListVM.h
//  OC_APP
//
//  Created by xingl on 2019/2/27.
//  Copyright © 2019 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^successBlock)(void);

@interface ListVM : NSObject

@property (nonatomic, strong) NSArray *datas;

- (void)fetchDataSuccess:(successBlock)block;

@end

NS_ASSUME_NONNULL_END
