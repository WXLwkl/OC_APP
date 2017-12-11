//
//  TurntableView.h
//  OC_APP
//
//  Created by xingl on 2017/12/8.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TurntableView <NSObject>

- (void)TurnTableViewDidFinishWithIndex:(NSInteger)index;

@end

@interface TurntableView : UIView

@property (nonatomic,assign) NSInteger numberIndex;

@property (nonatomic,strong) UIButton * playButton;      // 抽奖按钮

@property (nonatomic,strong) UIImageView * rotateWheel;  // 转盘背景

@property (nonatomic,strong) NSArray * numberArray;      // 存放奖励

@property (nonatomic,assign) id <TurntableView>delegate;


@end
