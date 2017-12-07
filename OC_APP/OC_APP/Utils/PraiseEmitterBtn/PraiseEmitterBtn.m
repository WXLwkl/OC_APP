//
//  PraiseEmitterBtn.m
//  OC_APP
//
//  Created by xingl on 2017/11/27.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "PraiseEmitterBtn.h"

@interface PraiseEmitterBtn ()

@property (strong, nonatomic) CAEmitterLayer *explosionLayer;

@end

@implementation PraiseEmitterBtn

- (CAEmitterLayer *)explosionLayer {
    if (!_explosionLayer) {
        _explosionLayer = [[CAEmitterLayer alloc] init];
//        发射形状
        _explosionLayer.emitterShape = kCAEmitterLayerCircle;
//        发射模型
        _explosionLayer.emitterMode = kCAEmitterLayerOutline;
//        发射源大小
        _explosionLayer.emitterSize = CGSizeMake(10, 0);
//        渲染模型
        _explosionLayer.renderMode = kCAEmitterLayerOldestFirst;
        _explosionLayer.masksToBounds = NO;
        _explosionLayer.birthRate = 0;
//        发射位置
        _explosionLayer.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        _explosionLayer.zPosition = -1;
    }
    return _explosionLayer;
}


- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        [self explosionAni];
    } else {
        [self stopAnimation];
    }
}

- (void)drawRect:(CGRect)rect {
    [self setupExplosion];
}

- (void)setupExplosion {
    CAEmitterCell *explosionCell = [[CAEmitterCell alloc] init];
    explosionCell.name = @"explosion";
//    设置粒子颜色alpha能改变的范围
    explosionCell.alphaRange = 0.10;
//    设置粒子alpha的改变速度
    explosionCell.alphaSpeed = -1.0;
//    设置粒子的生命周期
    explosionCell.lifetime = 0.7;
//    设置粒子生命周期的范围
    explosionCell.lifetimeRange = 0.3;
//    粒子发射的初始速度
    explosionCell.birthRate = 2500;
//    粒子速度
    explosionCell.velocity = 40.00;
//    粒子速度范围
    explosionCell.velocityRange = 10.00;
//    粒子缩放比例
    explosionCell.scale = 0.03;
//    粒子缩放比例范围
    explosionCell.scaleRange = 0.02;
    
    explosionCell.contents = (__bridge id _Nullable)([[UIImage imageNamed:@"sparkle"] CGImage]);
//    发射源包含的粒子
    self.explosionLayer.emitterCells = @[explosionCell];
    
    [self.layer addSublayer:self.explosionLayer];
}

- (void)explosionAni {
    CAKeyframeAnimation *animation = [[CAKeyframeAnimation alloc] init];
    animation.keyPath = @"transform.scale";
    if (self.selected) {
        animation.values = @[@1.5, @0.8, @1.0, @1.2, @1.0];
        animation.duration = 0.5;
        [self startAnimation];
    } else {
        animation.values = @[@0.8,@1.0];
        animation.duration = 0.5;
    }
    animation.calculationMode = kCAAnimationCubic;
    [self.layer addAnimation:animation forKey:@"transform.scale"];
}

- (void) startAnimation{
    
    self.explosionLayer.beginTime = CACurrentMediaTime();
    self.explosionLayer.birthRate = 1;
    NSLog(@"startAnimation被执行啦.birthRate = %f",self.explosionLayer.birthRate);
    
    [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:0.15];
}

- (void) stopAnimation{
    self.explosionLayer.birthRate = 0;
    NSLog(@"stopAnimation被执行啦，birthRate = %f",self.explosionLayer.birthRate);
}
@end
