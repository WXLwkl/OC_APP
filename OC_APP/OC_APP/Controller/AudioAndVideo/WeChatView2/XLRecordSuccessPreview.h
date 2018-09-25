//
//  XLRecordSuccessPreview.h
//  OC_APP
//
//  Created by xingl on 2018/9/21.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface XLRecordSuccessPreview : UIView

@property (nonatomic, copy) void (^sendBlock)(UIImage *image, NSString *videoPath);
@property (nonatomic, copy) void (^cancelBlock)(void);

- (void)setImage:(UIImage *)image videoPath:(NSString *)videoPath captureVideoOrientation:(AVCaptureVideoOrientation)orientation;

@end
