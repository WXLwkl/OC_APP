//
//  MeasurNetTools.h
//  OC_APP
//
//  Created by xingl on 2019/2/18.
//  Copyright © 2019 兴林. All rights reserved.
//

#define timeCount 0.2

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void (^measureBlock) (float speed);
typedef void (^finishMeasureBlock) (float speed);

@interface MeasurNetTools : NSObject

/**
 *  初始化测速方法
 *
 *  @param measureBlock       实时返回测速信息
 *  @param finishMeasureBlock 最后完成时候返回平均测速信息
 *
 *  @return MeasurNetTools对象
 */
- (instancetype)initWithblock:(measureBlock)measureBlock finishMeasureBlock:(finishMeasureBlock)finishMeasureBlock failedBlock:(void (^) (NSError *error))failedBlock;

/**
 *  开始测速
 */
-(void)startMeasur;

/**
 *  停止测速，会通过block立即返回测试信息
 */
-(void)stopMeasur;

@end

NS_ASSUME_NONNULL_END
