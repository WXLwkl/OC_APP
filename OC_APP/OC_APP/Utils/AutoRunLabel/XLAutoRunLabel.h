//
//  XLAutoRunLabel.h
//  Demo
//
//  Created by xingl on 2016/12/30.
//  Copyright © 2016年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLAutoRunLabel;

typedef NS_ENUM(NSInteger, RunDirectionType) {
    LeftType = 0,
    RightType = 1,
};

@protocol XLAutoRunLabelDelegate <NSObject>

@optional
- (void)operateLabel: (XLAutoRunLabel *)autoLabel animationDidStopFinished: (BOOL)finished;

@end

@interface XLAutoRunLabel : UIView

@property (nonatomic, weak) id <XLAutoRunLabelDelegate> delegate;
@property (nonatomic, assign) CGFloat speed;
@property (nonatomic, assign) RunDirectionType directionType;

- (void)addContentView: (UIView *)view;
- (void)startAnimation;
- (void)stopAnimation;

@end
