//
//  SharePopView.h
//  OC_APP
//
//  Created by xingl on 2017/8/4.
//  Copyright © 2017年 兴林. All rights reserved.
//

//选择位置
typedef void (^SelectedBlock)(NSInteger index);

#import <UIKit/UIKit.h>

@interface SharePopView : UIView

@property (nonatomic,copy) SelectedBlock block;

/**
 *  初始化分享视图
 */
- (id)initWithTitleArray:(NSArray *)titlearray  picarray:(NSArray *)picarray;
/*
 *  视图展示
 */
- (void)show;


- (void)selectedItem:(SelectedBlock)block;

@end
