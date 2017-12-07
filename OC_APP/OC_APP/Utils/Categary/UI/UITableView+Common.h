//
//  UITableView+Common.h
//  OC_APP
//
//  Created by xingl on 2017/11/22.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Common)

@property (nonatomic, assign) BOOL firstReload;
@property (nonatomic, strong) UIView *placeholderView;
@property (nonatomic,   copy) void(^reloadBlock)(void);

@end
