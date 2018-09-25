//
//  XLRecordProgressView.h
//  OC_APP
//
//  Created by xingl on 2018/9/21.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLRecordProgressView : UIButton

@property (nonatomic, assign) CGFloat progress;

- (void)resetScale;
- (void)setScale;

@end
