//
//  NetworkSpeedView.m
//  OC_APP
//
//  Created by xingl on 2019/2/18.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "NetworkSpeedView.h"

#define Scacle (w/([UIScreen mainScreen].bounds.size.width-40))
#define Space(x) ((x) * Scacle)

@implementation NetworkSpeedView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)show {
    // 背景图片
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cesuzhi"]];
    imgV.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [self addSubview:imgV];
    
    CALayer *needleLayer = [CALayer layer];
    needleLayer.anchorPoint = CGPointMake(0.5, 1.0);
    CGFloat w = CGRectGetWidth(self.frame);
    // 锚点在父视图上面的位置
    needleLayer.position = imgV.center;
    needleLayer.bounds = CGRectMake(0, 0, Space(5), Space(85));
    
    needleLayer.contents = (id)[UIImage imageNamed:@"cwszhizhen"].CGImage;
    [self.layer addSublayer:needleLayer];
    needleLayer.transform = CATransform3DMakeRotation(-0.75 * M_PI, 0, 0, 1);
    _needleLayer = needleLayer;
}

@end
