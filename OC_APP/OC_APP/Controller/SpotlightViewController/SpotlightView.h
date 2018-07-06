//
//  SpotlightView.h
//  OC_APP
//
//  Created by xingl on 2018/6/12.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SpotlightView;
@protocol SpotlightViewDelegate <NSObject>

@optional
- (void)didClickItem:(SpotlightView *)spotlightView atIndex:(NSInteger)index;

@end

@interface SpotlightView : UIView

@property (nonatomic, weak) id<SpotlightViewDelegate> delegate;

@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) NSMutableArray *itemsArray;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, copy) NSString *centerImageName;
@property (nonatomic, strong) NSArray *sourceArray;
@property (nonatomic, assign) CGFloat radius; // 半径
@property (nonatomic, assign) double startRadian; // 开始弧度
@property (nonatomic, assign) double endRadian; // 结束弧度
@property (nonatomic, assign) double multiple; //缩放倍数 >=1

#pragma mark -setUp（设置完属性后必须setUp）
-(void)setup;
#pragma mark -展开
-(void)show;
#pragma mark -收起
-(void)hide;

@end
