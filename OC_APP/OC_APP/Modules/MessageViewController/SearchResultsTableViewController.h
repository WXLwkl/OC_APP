//
//  SearchResultsTableViewController.h
//  OC_APP
//
//  Created by xingl on 2017/10/13.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultsTableViewController : UITableViewController<UISearchResultsUpdating>

@property (nonatomic, strong) NSMutableArray *dataArray;

@end
