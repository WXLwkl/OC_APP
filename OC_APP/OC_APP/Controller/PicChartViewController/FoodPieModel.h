//
//  FoodPieModel.h
//  OC_APP
//
//  Created by xingl on 2018/5/25.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodPieModel : NSObject

    
/** 名称 */
@property (nonatomic, copy) NSString *name;

/** 数值 */
@property (assign, nonatomic) CGFloat value;

/** 比例 */
@property (assign, nonatomic) CGFloat rate;
    
@end
