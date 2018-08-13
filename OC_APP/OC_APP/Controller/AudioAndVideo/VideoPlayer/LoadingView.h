//
//  LoadingView.h
//  OC_APP
//
//  Created by xingl on 2018/8/7.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

/** 一次动画所持续时长 默认2s */
@property (nonatomic, assign) NSTimeInterval duration;
/** 线条颜色 */
@property (nonatomic, strong) UIColor *strokeColor;

- (void)startAnimation;

- (void)stopAnimation;

- (void)destroyAnimation;

@end
