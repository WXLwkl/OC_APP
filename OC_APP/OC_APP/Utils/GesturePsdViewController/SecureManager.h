//
//  SecureManager.h
//  shoushi
//
//  Created by xingl on 2017/7/19.
//  Copyright © 2017年 xingl. All rights reserved.
//


/// 手势圆圈正常的颜色
#define CircleNormalColor   ColorWithHex(0x33CCFF)
/// 手势圆圈选中的颜色
#define CircleSelectedColor ColorWithHex(0x3393F2)
/// 手势圆圈错误的颜色
#define CircleErrorColor    ColorWithHex(0xFF0033)

// 手势密码提示Label的高度
#define LabelHeight 20.0f
// 手势密码九宫格view的宽高
#define GestureWH   260.0f

#import <Foundation/Foundation.h>
#import "Macros.h"

@interface SecureManager : NSObject

/** 保存手势密码的code */
+ (void)saveGestureCodeKey:(NSString *)gestureCode;

/** 手势密码的开启状态 */
+ (BOOL)gestureOpenStatus;

/** 手势密码轨迹显示开启状态 */
+ (BOOL)gestureShowStatus;

/** 开启/关闭手势密码 */
+ (void)openGesture:(BOOL)open;

/** 显示/隐藏手势轨迹 */
+ (void)openGestureShow:(BOOL)open;

/** 获取保存手势密码的code */
+ (NSString *)gainGestureCodeKey;

@end
