//
//  LateralSlideConfiguration.m
//  cehua
//
//  Created by xingl on 2017/10/24.
//  Copyright © 2017年 xingl. All rights reserved.
//

#import "LateralSlideConfiguration.h"

@implementation LateralSlideConfiguration

+ (instancetype)defaultConfiguration {
    return [LateralSlideConfiguration configurationWithDistance:kScreenWidth * 0.75 maskAlpha:0.4 scaleY:1.0 direction:DrawerTransitionDirectionLeft backImage:nil];
}

+ (instancetype)configurationWithDistance:(float)distance maskAlpha:(float)alpha scaleY:(float)scaleY direction:(DrawerTransitionDirection)direction backImage:(UIImage *)backImage {
    return [[self alloc] initWithDistance:distance maskAlpha:alpha scaleY:scaleY direction:direction backImage:backImage];
}

- (instancetype)initWithDistance:(float)distance maskAlpha:(float)alpha scaleY:(float)scaleY direction:(DrawerTransitionDirection)direction backImage:(UIImage *)backImage {
    self = [super init];
    if (self) {
        _distance = distance;
        _maskAlpha = alpha;
        _direction = direction;
        _backImage = backImage;
        _scaleY = scaleY;
    }
    return self;
}

- (float)distance {
    if (_distance == 0) {
        return kScreenWidth * 0.75;
    }
    return _distance;
}

- (float)maskAlpha {
    if (_maskAlpha == 0) {
        return 0.1;
    }
    return _maskAlpha;
}
- (float)scaleY {
    if (_scaleY == 0) {
        return 1.0;
    }
    return _scaleY;
}

@end
