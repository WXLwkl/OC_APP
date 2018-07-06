//
//  XLCaptureManager1.h
//  OC_APP
//
//  Created by xingl on 2018/6/25.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AssetWriteManager.h"

//闪光灯状态
typedef NS_ENUM(NSInteger, LLFlashState) {
    XLFlashClose = 0,
    XLFlashOpen,
    XLFlashAuto,
};

@protocol XLCaptureManager1Delegate <NSObject>

- (void)updateFlashState:(LLFlashState)state;
- (void)updateRecordingProgress:(CGFloat)progress;
- (void)updateRecordState:(LLRecordState)recordState;

@end

@interface XLCaptureManager1 : NSObject

@property (nonatomic, weak  ) id<XLCaptureManager1Delegate>delegate;
@property (nonatomic, assign) LLRecordState recordState;
@property (nonatomic, strong, readonly) NSURL *videoUrl;
- (instancetype)initWithSuperView:(UIView *)superView;

- (void)turnCameraAction;
- (void)switchflash;
- (void)startRecord;
- (void)stopRecord;
- (void)reset;

@end
