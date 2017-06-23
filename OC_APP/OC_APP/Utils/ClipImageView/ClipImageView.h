//
//  ClipImageView.h
//  OC_APP
//
//  Created by xingl on 2017/6/21.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AnimationComplete)();

@interface ClipImageView : UIImageView


/**
 设置撕裂图片

 @param view 要添加到的View
 @param image 要撕裂的图片
 @param backgroundImageName 可以设置背景图片
 @param complete 动画结束事件
 */
+ (void)addToCurrentView:(UIView *)view
               clipImage:(UIImage *)image
         backgroundImage:(NSString *)backgroundImageName
       animationComplete:(AnimationComplete)complete;

@end
