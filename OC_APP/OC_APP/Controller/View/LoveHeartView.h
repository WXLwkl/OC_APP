//
//  LoveHeartView.h
//  OC_APP
//
//  Created by xingl on 2017/12/8.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>
#define DMRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define DMRGBAColor(r, g, b ,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define RandColor DMRGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

@interface LoveHeartView : UIView

- (void)animateInView:(UIView *)view;

@end
