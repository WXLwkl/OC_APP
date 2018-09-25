//
//  DSLView.m
//  OC_APP
//
//  Created by xingl on 2018/9/4.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "DSLView.h"

@implementation DSLView

+ (DSLView *)make {
    return [DSLView new];
}

- (DSLView *(^)(CGRect))xl_frame {
    __weak typeof(self) weakSelf = self;
    return ^DSLView *(CGRect frame) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        strongSelf.frame = frame;
        return strongSelf;
    };
}

- (DSLView *(^)(UIColor *))xl_backgroundColor {
    __weak typeof(self) weakSelf = self;
    return ^DSLView *(UIColor *color) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.backgroundColor = color;
        return strongSelf;
    };
}

@end
