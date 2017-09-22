//
//  ReduceTimeCell.h
//  OC_APP
//
//  Created by xingl on 2017/8/21.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ReduceTimeState) {
    ReduceTimeStateNotStart = 0,
    ReduceTimeStateIng,
    ReduceTimeStateEnd,
};

@interface ReduceTimeCell : UITableViewCell

- (void)configCellWithImage:(NSString *)imageName name:(NSString *)name;

- (void)configCellState:(ReduceTimeState)reduceTimeState currentTime:(NSString *)currentTime;

@end
