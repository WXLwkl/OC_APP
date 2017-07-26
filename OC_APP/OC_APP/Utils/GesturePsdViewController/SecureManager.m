//
//  SecureManager.m
//  shoushi
//
//  Created by xingl on 2017/7/19.
//  Copyright © 2017年 xingl. All rights reserved.
//




#define UserDefaults [NSUserDefaults standardUserDefaults]



#import "SecureManager.h"

// 记录手势密码GestureCodeKey
NSString *const Gesture_Code_Key = @"Gesture_Code_Key";
// 手势密码是否开启的key
NSString *const Gesture_Password_Open = @"Gesture_Password_Open";
// 手势密码是否显示轨迹的key
NSString *const Gesture_Password_Show = @"Gesture_Password_Show";


@implementation SecureManager

/** 保存手势密码的code */
+ (void)saveGestureCodeKey:(NSString *)gestureCode {
    [UserDefaults setObject:gestureCode forKey:Gesture_Code_Key];
    [UserDefaults synchronize];
}

/** 手势密码的开启状态 */
+ (BOOL)gestureOpenStatus {
    
    BOOL gestureOpen = [UserDefaults boolForKey:Gesture_Password_Open];
    return gestureOpen;
}

/** 手势密码轨迹显示开启状态 */
+ (BOOL)gestureShowStatus {

    BOOL gestureShow = [UserDefaults boolForKey:Gesture_Password_Show];
    
    return gestureShow;
}

/** 开启/关闭手势密码 */
+ (void)openGesture:(BOOL)open {
    
    [UserDefaults setBool:open forKey:Gesture_Password_Open];
    [UserDefaults setBool:open forKey:Gesture_Password_Show];
    [UserDefaults synchronize];
    if (!open) {
        [self saveGestureCodeKey:nil];
    }
}

/** 显示/隐藏手势轨迹 */
+ (void)openGestureShow:(BOOL)open {
    
    [UserDefaults setBool:open forKey:Gesture_Password_Show];
    [UserDefaults synchronize];
}

+ (NSString *)gainGestureCodeKey {
    
    NSString *gestureCode = [[NSUserDefaults standardUserDefaults] objectForKey:Gesture_Code_Key];
    return gestureCode ? gestureCode : @"";
}

@end
