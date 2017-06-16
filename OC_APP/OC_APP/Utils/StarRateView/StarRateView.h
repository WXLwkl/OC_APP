//
//  StarRateView.h
//  OC_APP
//
//  Created by xingl on 2017/6/12.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StarRateView;

typedef NS_ENUM(NSInteger, RateStyle) {
    RateStyleWhole = 0, //整星评论
    RateStyleHalf = 1, // 半星评论
    RateStyleIncomple = 2 //不完整星评论
};

typedef void(^FinishBlock)(CGFloat currentScore);

@protocol StarRateViewDelegate <NSObject>

- (void)starRateView:(StarRateView *)starRateView currentScore:(CGFloat)currentScore;

@end

@interface StarRateView : UIView

//是否动画显示，默认NO
@property (nonatomic, assign) BOOL isAnimation;

//评分样式，默认whole
@property (nonatomic, assign) RateStyle rateStyle;

@property (nonatomic, weak) id<StarRateViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;

- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(RateStyle)rateStyle isAnimation:(BOOL)isAnimation delegate:(id)delegate;

- (instancetype)initWithFrame:(CGRect)frame finishBlock:(FinishBlock)finish;
- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(RateStyle)rateStyle isAnimation:(BOOL)isAnimation finishBlock:(FinishBlock)finish;
@end
