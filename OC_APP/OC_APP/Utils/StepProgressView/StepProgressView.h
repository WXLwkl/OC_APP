//
//  StepProgressView.h
//  OC_APP
//
//  Created by xingl on 2017/6/18.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepProgressView : UIView

@property (nonatomic, assign) NSInteger stepIndex;

+ (instancetype)progressViewFrame:(CGRect)frame withTitleArray:(NSArray *)titleArray;

@end
