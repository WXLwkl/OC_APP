//
//  ScanningView.h
//  OC_APP
//
//  Created by xingl on 2017/10/19.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ScanningStyle) {
    ScanningStyleQRCode = 0,
    ScanningStyleBook,
    ScanningStyleStreet,
    ScanningStyleWord,
};

@interface ScanningView : UIView

@property (nonatomic, assign, readonly) ScanningStyle scanningStyle;

- (void)transformScanningTypeWithStyle:(ScanningStyle)style;

@end
