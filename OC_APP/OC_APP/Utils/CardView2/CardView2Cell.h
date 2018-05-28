//
//  CardView2Cell.h
//  OC_APP
//
//  Created by xingl on 2018/4/12.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CardView2Cell;

@protocol CardView2CellDelegate <NSObject>
/**  itemView从父视图移除*/
- (void)cardItemViewDidRemoveFromSuperView:(CardView2Cell *)CardItemView;
/**  item移动了多少角度，是否有动画*/
- (void)cardItemViewDidMoveRate:(CGFloat)rate anmate:(BOOL)anmate;

@end

@interface CardView2Cell : UIView

@property (nonatomic, weak) id<CardView2CellDelegate> delegate;

@property (nonatomic, readonly,copy) NSString *reuseIdentifier; // 重用标识符

- (void)initView;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

/**  从父视图移除，是否从左侧*/
- (void)removeWithLeft:(BOOL)left;

@end
