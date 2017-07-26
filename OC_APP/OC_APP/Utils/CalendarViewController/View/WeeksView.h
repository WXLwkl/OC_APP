//
//  WeeksView.h
//  OC_APP
//
//  Created by xingl on 2017/7/25.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeeksView : UIView

@property (nonatomic, copy) NSString *year;

- (void)selectMonth:(void (^)(BOOL increase))selectBlock;

@end
