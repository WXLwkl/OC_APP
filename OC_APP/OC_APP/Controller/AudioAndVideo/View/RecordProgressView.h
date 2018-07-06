//
//  RecordProgressView.h
//  OC_APP
//
//  Created by xingl on 2018/6/21.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordProgressView : UIView

- (void)updateProgressWithValue:(CGFloat)progress;
- (void)resetProgress;

@end
