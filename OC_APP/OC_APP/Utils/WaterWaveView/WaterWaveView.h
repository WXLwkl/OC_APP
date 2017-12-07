//
//  WaterWaveView.h
//  OC_APP
//
//  Created by xingl on 2017/11/20.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterWaveView : UIView

/** 波动速度 */
@property (nonatomic, assign) CGFloat waveSpeed;
/** 水波振幅 */
@property (nonatomic, assign) CGFloat waveAmplitude;
/** 水波颜色 */
@property (nonatomic, strong) UIColor *waveColor;
/** 水波的高度 */
@property (nonatomic, assign) CGFloat waveHeight;

- (void)destroy;

@end
