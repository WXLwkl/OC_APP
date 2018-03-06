//
//  DargSortCell.h
//  OC_APP
//
//  Created by xingl on 2018/2/23.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_WIDTH_RATIO (kScreenWidth / 375)
#define kDeleteBtnWH 10 * SCREEN_WIDTH_RATIO
#define kLineHeight (1 / [UIScreen mainScreen].scale)
@protocol DragSortDelegate <NSObject>

- (void)dargSortCellGestureAction:(UIGestureRecognizer *)gestureRecognizer;
- (void)dargSortCellCancelSubscribe:(NSString *)subscribe;

@end

@interface DargSortCell : UICollectionViewCell

@property (nonatomic, strong) NSString *subscribe;
@property (nonatomic, weak) id<DragSortDelegate> delegate;

- (void)showDeleteBtn;

@end
