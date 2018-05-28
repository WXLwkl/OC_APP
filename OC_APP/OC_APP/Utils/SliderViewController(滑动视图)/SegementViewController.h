//
//  SegementViewController.h
//  OC_APP
//
//  Created by xingl on 2018/5/25.
//  Copyright © 2018年 兴林. All rights reserved.
//



// 标题被点击或者内容滚动完成，会发出这个通知，监听这个通知，可以做自己想要做的事情，比如加载数据
static NSString * const DisplayViewClickOrScrollDidFinshNote = @"DisplayViewClickOrScrollDidFinshNote";

// 重复点击通知
static NSString * const DisplayViewRepeatClickTitleNote = @"DisplayViewRepeatClickTitleNote";


#import "RootViewController.h"

/** 颜色渐变样式 */
typedef NS_ENUM(NSInteger, TitleColorGradientStyle) {
    TitleColorGradientStyleRGB,
    TitleColorGradientStyleFill
};


@interface SegementViewController : RootViewController

/**
 内容是否需要全屏展示
 YES :  全屏：内容占据整个屏幕，会有穿透导航栏效果，需要手动设置tableView额外滚动区域
 NO  :  内容从标题下展示
 */
@property (nonatomic, assign) BOOL isFullScreen;

/**
 根据角标，选中对应的控制器
 */
@property (nonatomic, assign) NSInteger selectIndex;

/**
 如果_isfullScreen = Yes，这个方法就不好使。
 
 设置整体内容的frame,包含（标题滚动视图和内容滚动视图）
 */
- (void)setupContentViewFrame:(void(^)(UIView *contentView))contentBlock;

/** 刷新界面和标题 在调用之前，必须先确定所有的子控制器。*/
- (void)refreshDisplay;

/** 设置顶部标题样式 */
- (void)setupTitleEffect:(void(^)(UIColor **titleScrollViewColor, UIColor **norColor, UIColor **selColor, UIFont **titleFont, CGFloat *titleHeight, CGFloat *titleWidth))titleEffectBlock;

/** 设置下标样式 */
- (void)setupUnderLineEffect:(void(^)(BOOL *isUnderLineDelayScroll, CGFloat *underLineH, UIColor **underLineColor, BOOL *isUnderLineEqualTitleWidth))underLineBlock;

/** 字体缩放 */
- (void)setupTitleScale:(void (^)(CGFloat *titleScale))titleScaleBlock;

/** 颜色渐变 */
- (void)setupTitleGradient:(void(^)(TitleColorGradientStyle *titleColorGradientStype, UIColor **norColor, UIColor **selColor))titleGradientBlock;

/** 遮盖 */
- (void)setupCoverEffect:(void(^)(UIColor **coverColor, CGFloat *coverCornerRadius))coverEffectBlock;

@end
