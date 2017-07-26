//
//  GestureItem.h
//  shoushi
//
//  Created by xingl on 2017/7/17.
//  Copyright © 2017年 xingl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GestureItemStatus) {
    GestureItemStatusNormal,
    GestureItemStatusSelected,
    GestureItemStatusSelectedAndShowArrow,
    GestureItemStatusError,
    GestureItemStatusErrorAndShowArrow,
};

@interface GestureItem : UIView


@property (nonatomic,assign) GestureItemStatus itemStatus;

/** 相邻两圆圈连线的方向角度 */
@property (nonatomic) CGFloat angle;

@end
