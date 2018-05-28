//
//  CardView2.m
//  OC_APP
//
//  Created by xingl on 2018/4/12.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "CardView2.h"

static const NSInteger ItemViewCount = 4;     //显示的item个数 必须大于2
static const NSInteger AheadItemCount = 5;    //提前几张view开始提醒刷新

@interface CardView2 () <CardView2CellDelegate>

@property (nonatomic, assign) NSInteger itemCount; //总共的item数量
@property (nonatomic, assign) NSInteger removedCount; // 已经移除的view的数量
@property (nonatomic, assign) BOOL isWorking; // 是否正在移除动画中
@property (nonatomic, assign) BOOL isAskingMoreData;// 是否已向代理请求数据 数据返回后进行状态重置
@property (nonatomic, copy) NSMutableDictionary *reuseDict; //缓存池字典

@end

@implementation CardView2

- (CardView2Cell *)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    NSMutableArray *mutableArray = self.reuseDict[identifier];
    if (mutableArray) {
        if (mutableArray.count > 0) {
            CardView2Cell *cell = [mutableArray lastObject];
            [mutableArray removeLastObject];
            return cell;
        }
    }
    return nil;
}

- (void)deleteTheTopItemViewWithLeft:(BOOL)left {
    if (self.isWorking) return;
    CardView2Cell *cell = (CardView2Cell *)self.subviews.lastObject;
    if (cell) {
        self.isWorking = YES;
        [cell removeWithLeft:left];
    }
}

- (void)reloadData {
    if (_dataSource == nil) return;
    self.isAskingMoreData = NO;
    self.itemCount = [self numberOfItemViews];
    if (self.subviews.count < ItemViewCount) {
        for (NSInteger i = self.subviews.count; i < ItemViewCount; i++) {
            [self insertCard:self.removedCount+i isReload:YES];
        }
        [self sortCardsWithRate:0 animate:YES];
    }
}

- (void)sortCardsWithRate:(CGFloat)rate animate:(BOOL)isAnmate {
    for (NSInteger i = 1; i < self.subviews.count; i++) {
        NSInteger index = self.subviews.count - i - 1;
        CardView2Cell *cell = self.subviews[index];
        cell.userInteractionEnabled = NO;
        NSInteger y = i > ItemViewCount - 2 ? ItemViewCount - 2 : i;
        CGFloat realRate = y - rate > 0 ? y - rate : 0;
        if (i == ItemViewCount - 1) {
            realRate = y;
        }
        CGFloat animationTime = isAnmate ? 0.2 : 0;
        [UIView animateKeyframesWithDuration:animationTime delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            [self transformCard:cell withRate:realRate];
        } completion:nil];
    }
}
- (void)transformCard:(CardView2Cell *)cell withRate:(CGFloat)rate {
    CGAffineTransform scaleTransfrom = CGAffineTransformMakeScale(1-0.02*rate, 1-0.02*rate);
    cell.transform = CGAffineTransformTranslate(scaleTransfrom, 0, 10*rate);
}

- (void)insertCard:(NSInteger)index isReload:(BOOL)isReload {
    if (index >= self.itemCount) return;
    CardView2Cell *cell = [self itemViewAtIndex:index];
    if (cell.delegate == nil) { // 初始化的cell 不是缓存池的
        cell.delegate = self;
        [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandle:)]];
    } else {
        cell.transform = CGAffineTransformMakeRotation(0);
    }
    CGSize size = [self itemViewSizeAtIndex:index];
    [self insertSubview:cell atIndex:0];
    cell.tag = index + 1;
    cell.frame = CGRectMake(self.frame.size.width / 2.0 - size.width / 2.0, self.frame.size.height / 2.0 - size.height / 2.0, size.width, size.height);
    cell.userInteractionEnabled = YES;
    if (!isReload) {
        if (index-self.removedCount == ItemViewCount - 1) {
            NSInteger rate = ItemViewCount - 2;
            [self transformCard:cell withRate:rate];
        }
    }
}
- (CGSize)itemViewSizeAtIndex:(NSInteger)index {
    if ([self.dataSource respondsToSelector:@selector(cardView:sizeForItemViewAtIndex:)] && index < [self numberOfItemViews]) {
        CGSize size = [self.dataSource cardView:self sizeForItemViewAtIndex:index];
        if (size.width > self.frame.size.width || size.width == 0) {
            size.width = self.frame.size.width;
        } else if (size.height > self.frame.size.height || size.height == 0) {
            size.height = self.frame.size.height;
        }
        return size;
    }
    return self.frame.size;
}

- (CardView2Cell *)itemViewAtIndex:(NSInteger)index {
    if ([self.dataSource respondsToSelector:@selector(cardView:itemViewAtIndex:)]) {
        CardView2Cell *cell = [self.dataSource cardView:self itemViewAtIndex:index];
        if (cell == nil) {
            return [[CardView2Cell alloc] init];
        } else {
            return cell;
        }
    }
    return [[CardView2Cell alloc] init];
}

- (NSInteger)numberOfItemViews {
    if ([self.dataSource respondsToSelector:@selector(numberOfItemViewsInCardView:)]) {
        return [self.dataSource numberOfItemViewsInCardView:self];
    }
    return 0;
}

- (void)tapGestureHandle:(UITapGestureRecognizer *)tapGest {
    if ([self.delegate respondsToSelector:@selector(cardView:didClickItemAtIndex:)]) {
        [self.delegate cardView:self didClickItemAtIndex:tapGest.view.tag - 1];
    }
}

- (void)cardItemViewDidRemoveFromSuperView:(CardView2Cell *)cardItemView {
    self.isWorking = NO;
    self.removedCount ++;
    [self insertItemViewToReuseDict:cardItemView];
    [self insertCard:self.removedCount+ItemViewCount-1 isReload:NO];
    CardView2Cell *cell = [self.subviews lastObject];
    cell.userInteractionEnabled = YES;
    if (self.removedCount + ItemViewCount > self.itemCount - AheadItemCount) {
        if (!self.isAskingMoreData) {
            self.isAskingMoreData = YES;
            if ([self.dataSource respondsToSelector:@selector(cardViewNeedMoreData:)]) {
                [self.dataSource cardViewNeedMoreData:self];
            }
        }
    } else {
        self.isAskingMoreData = NO;
    }
}

- (void)cardItemViewDidMoveRate:(CGFloat)rate anmate:(BOOL)anmate {
    [self sortCardsWithRate:rate animate:anmate];
}



- (void)insertItemViewToReuseDict:(CardView2Cell *)cardItemView {
    if (cardItemView.reuseIdentifier) {
        NSMutableArray *mutableArray = self.reuseDict[cardItemView.reuseIdentifier];
        if (mutableArray == nil) {
            mutableArray = [NSMutableArray array];
        }
        [mutableArray addObject:cardItemView];
        [self.reuseDict setValue:mutableArray forKey:cardItemView.reuseIdentifier];
    }
    [cardItemView removeFromSuperview];
}

- (NSMutableDictionary *)reuseDict {
    if (!_reuseDict) {
        _reuseDict = [NSMutableDictionary dictionary];
    }
    return _reuseDict;
}


@end
