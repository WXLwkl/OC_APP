//
//  XLPopMenuView.h
//  OC_APP
//
//  Created by xingl on 2017/8/3.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PopMenuButton.h"
#import "PopMenuModel.h"

/** 弹出动画类型 */
typedef NS_ENUM(NSUInteger, PopAnimationType) {
    
    PopAnimationTypeSina, //仿新浪弹出菜单
    PopAnimationTypeViscous, //带有粘性的动画
    PopAnimationTypeCenter, //底部中心弹出动画
    PopAnimationTypeLeftAndRight //左右弹出动画
};
/** 背景类型 */
typedef NS_ENUM(NSUInteger, PopBackgroundType) {
    
    PopBackgroundTypeLightBlur, //light模糊背景类型
    PopBackgroundTypeDarkBlur, //dark模糊背景类型
    PopBackgroundTypeLightTranslucent, //偏白半透明背景类型
    PopBackgroundTypeDarkTranslucent, //偏黑半透明背景类型
    PopBackgroundTypeGradient   //白~黑渐变色
};
@interface XLPopMenuView : UIView

@property (nonatomic, strong) NSArray *items;

/** 背景类型，默认：PopBackgroundTypeLightBlur */
@property (nonatomic, assign) PopBackgroundType backgroundType;

/** 动画类型 */
@property (nonatomic, assign) PopAnimationType animationType;

/** 自动识别颜色主题，默认为关闭 */
@property (nonatomic, assign) BOOL automaticIdentificationColor;

/** 代理 */
@property (nonatomic, assign) id delegate;

/** 弹出速度 默认为 10.0f  取值范围: 0.0f ~ 20.0f */
@property (nonatomic, assign) CGFloat popMenuSpeed;

/** 自定义顶部视图 */
@property (nonatomic, strong) UIView *topView;

+ (instancetype)sharedPopMenuManager;

- (void)openMenu;

- (void)closeMenu;

- (BOOL)isOpenMenu;

@end

@protocol HyPopMenuViewDelegate <NSObject>

- (void)popMenuView:(XLPopMenuView*)popMenuView didSelectItemAtIndex:(NSUInteger)index;

//....
@end
UIKIT_EXTERN NSString *const XLPopMenuViewWillShowNotification;
UIKIT_EXTERN NSString *const XLPopMenuViewDidShowNotification;
UIKIT_EXTERN NSString *const XLPopMenuViewWillHideNotification;
UIKIT_EXTERN NSString *const XLPopMenuViewDidHideNotification;
