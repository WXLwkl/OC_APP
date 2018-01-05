//
//  ScrollNumLabel.h
//  OC_APP
//
//  Created by xingl on 2017/12/11.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface ScrollNumLabel : UILabel

@property (nonatomic, assign) IBInspectable NSInteger targetNumber;// default is 0
@property (nonatomic, assign) IBInspectable CGFloat animateDuration;// default is 0.25
@property (nonatomic, assign) IBInspectable BOOL isCommonLabel;// default is NO
@property (nonatomic, assign) BOOL centerPointPriority;// default is NO

- (void)increaseNumber:(NSInteger)increasedNum;
- (void)decreaseNumber:(NSInteger)decreasedNum;

@end
