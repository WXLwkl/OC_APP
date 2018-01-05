//
//  OptionalVeiw.h
//  OC_APP
//
//  Created by xingl on 2017/12/26.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionalVeiw : UIScrollView

/// 标题数组
@property (nonatomic, strong) NSArray <NSString *> *titleArray;

///item点击回调
@property (nonatomic, copy) void (^titleItemClickedCallBackBlock)(NSInteger index);
///偏移量
@property (nonatomic, assign) CGFloat contentOffsetX;

@end
