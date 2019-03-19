//
//  TrasitionViewController.h
//  OC_APP
//
//  Created by xingl on 2019/3/1.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrasitionViewController : RootViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@end

NS_ASSUME_NONNULL_END
