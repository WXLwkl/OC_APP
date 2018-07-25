//
//  DebugConsoleLabel.h
//  OC_APP
//
//  Created by xingl on 2018/7/25.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DebugToolLabelType) {
    DebugToolLabelTypeFPS,
    DebugToolLabelTypeMemory,
    DebugToolLabelTypeCPU
};

@interface DebugConsoleLabel : UILabel

- (void)updateLabelWith:(DebugToolLabelType)labelType value:(float)value;

@end
