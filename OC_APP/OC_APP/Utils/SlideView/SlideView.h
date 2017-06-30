//
//  SlideView.h
//  OC_APP
//
//  Created by xingl on 2017/6/27.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol SlideViewDelegate <NSObject>

/**
 点击后的方法
 
 @param string 返回下标
 */
- (void)selectedSlideViewWithString:(NSString *)string;

@end

@interface SlideView : UIView

@property (nonatomic, assign) id<SlideViewDelegate> delegate;

/**
 初始化方法

 @param frame frame
 @param color layer颜色
 @return slideView
 */
- (instancetype)initWithFrame:(CGRect)frame withLayerColor:(UIColor *)color;

@end
