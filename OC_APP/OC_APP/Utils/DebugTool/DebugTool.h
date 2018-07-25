//
//  DebugTool.h
//  OC_APP
//
//  Created by xingl on 2018/7/24.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, DebugToolTypes) {
    DebugToolTypeFPS    = 1 << 0,
    DebugToolTypeCPU    = 1 << 1,
    DebugToolTypeMemory = 1 << 2,
};

@interface DebugTool : NSObject

SingletonInterface(DebugTool);

//+ (instancetype)sharedInstance;

- (void)autoTypes:(DebugToolTypes)types;
- (void)showTypes:(DebugToolTypes)types;
- (void)hideTypes:(DebugToolTypes)types;
@end
