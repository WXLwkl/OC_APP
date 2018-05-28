//
//  CardView2.h
//  OC_APP
//
//  Created by xingl on 2018/4/12.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView2Cell.h"

@class CardView2;

@protocol CardView2Delegate <NSObject>

@optional
- (void)cardView:(CardView2 *)cardView didClickItemAtIndex:(NSInteger)index;
@end

@protocol CardView2DataSource <NSObject>

@required
/** 一共有多少个CardItemView对象 */
- (NSInteger)numberOfItemViewsInCardView:(CardView2 *)cardView;
/** 返回第几个CardItemView的对象 */
- (CardView2Cell *)cardView:(CardView2 *)cardView itemViewAtIndex:(NSInteger)index;
/** 要求请求更多数据 */
- (void)cardViewNeedMoreData:(CardView2 *)cardView;

@optional
- (CGSize)cardView:(CardView2 *)cardView sizeForItemViewAtIndex:(NSInteger)index;
@end


@interface CardView2 : UIView

@property (nonatomic, weak) id<CardView2DataSource> dataSource;
@property (nonatomic, weak) id<CardView2Delegate> delegate;

/**  获取标识符的CardItemView对象*/
- (CardView2Cell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;
/**  删除第一个CardItemView对象 是否从左侧*/
- (void)deleteTheTopItemViewWithLeft:(BOOL)left;
/**  重载视图*/
- (void)reloadData;

@end
