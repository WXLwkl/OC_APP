//
//  LateralSlideConfiguration.h
//  cehua
//
//  Created by xingl on 2017/10/24.
//  Copyright © 2017年 xingl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//#define kSCREENWIDTH [UIScreen mainScreen].bounds.size.width

typedef NS_ENUM(NSUInteger,DrawerTransitionDirection) {
    DrawerTransitionDirectionLeft = 0, // 左侧滑出
    DrawerTransitionDirectionRight     // 右侧滑出
};

@interface LateralSlideConfiguration : NSObject


/**
 根控制器可偏移的距离，默认为屏幕的0.75
 */
@property (nonatomic, assign) float distance;

/**
 遮罩的透明度
 */
@property (nonatomic, assign) float maskAlpha;

/**
 根控制器在y方向的缩放，默认为步缩放
 */
@property (nonatomic, assign) float scaleY;

/**
 菜单滑出的方向，默认为从左侧滑出
 */
@property (nonatomic, assign) DrawerTransitionDirection direction;

/**
 动画切换工程中，最底层的背景图片
 */
@property (nonatomic, strong) UIImage *backImage;


/**
 默认配置

 @return 配置对象本身
 */
+ (instancetype)defaultConfiguration;

/**
 创建一个配置对象的类方法
 
 @param distance 偏移距离
 @param alpha 遮罩的透明度
 @param scaleY y方向的缩放
 @param direction 滑出方向
 @param backImage 动画切换过程中，最底层的背景图片
 @return 配置对象本身
 */
+ (instancetype)configurationWithDistance:(float)distance maskAlpha:(float)alpha scaleY:(float)scaleY direction:(DrawerTransitionDirection)direction backImage:(UIImage *)backImage;

/**
 创建一个配置对象

 @param distance 偏移距离
 @param alpha 遮罩的透明度
 @param scaleY y方向的缩放 (仅DrawerAnimationTypeDefault动画模式有效)
 @param direction 滑出方向
 @param backImage 动画切换过程中，最底层的背景图片 (仅DrawerAnimationTypeDefault动画模式有效)
 @return 配置对象本身
 */
- (instancetype)initWithDistance:(float)distance maskAlpha:(float)alpha scaleY:(float)scaleY direction:(DrawerTransitionDirection)direction backImage:(UIImage *)backImage;

@end
