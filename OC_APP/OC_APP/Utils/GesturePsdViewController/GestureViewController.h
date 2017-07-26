//
//  GestureViewController.h
//  shoushi
//
//  Created by xingl on 2017/7/17.
//  Copyright © 2017年 xingl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

typedef NS_ENUM(NSInteger, GestureSetType) {
    GestureSetTypeSetting = 1,   // 设置
    GestureSetTypeChange,        // 修改
    GestureSetTypeVerify         // 校验
};

//设置的结果
typedef void(^GestureSetBlock)(BOOL success);

@interface GestureViewController : RootViewController

@property (nonatomic, assign) GestureSetType gestureSetType;

/// 设置手势完成的回调
- (void)gestureSetComplete:(GestureSetBlock)block;

@end
