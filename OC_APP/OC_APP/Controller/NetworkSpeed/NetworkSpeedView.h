//
//  NetworkSpeedView.h
//  OC_APP
//
//  Created by xingl on 2019/2/18.
//  Copyright © 2019 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkSpeedView : UIView

@property (strong, nonatomic) CALayer *needleLayer;

- (void)show;

@end

NS_ASSUME_NONNULL_END
