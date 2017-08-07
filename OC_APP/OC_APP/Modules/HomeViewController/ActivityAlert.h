//
//  ActivityAlert.h
//  OC_APP
//
//  Created by xingl on 2017/8/1.
//  Copyright © 2017年 兴林. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface ActivityAlert : UIView



+ (instancetype)showWithView:(UIView *)view trueAction:(void(^)())block;

@end
