//
//  WaterfallFlowLayout.h
//  OC_APP
//
//  Created by xingl on 2018/2/22.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef CGFloat(^HeightBlock)(NSIndexPath *indexPath , CGFloat width);

@interface WaterfallFlowLayout : UICollectionViewLayout

/** 列数 */
@property (nonatomic, assign) NSInteger lineNumber;
/** 行间距 */
@property (nonatomic, assign) CGFloat rowSpacing;
/** 列间距 */
@property (nonatomic, assign) CGFloat lineSpacing;
/** 内边距 */
@property (nonatomic, assign) UIEdgeInsets sectionInset;
/**
 *  计算各个item高度方法 必须实现
 *
 *  @param block 设计计算item高度的block
 */
- (void)computeIndexCellHeightWithWidthBlock:(CGFloat(^)(NSIndexPath *indexPath , CGFloat width))block;

@end
