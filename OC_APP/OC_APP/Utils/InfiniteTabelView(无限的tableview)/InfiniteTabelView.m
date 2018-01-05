//
//  InfiniteTabelView.m
//  OC_APP
//
//  Created by xingl on 2017/12/14.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "InfiniteTabelView.h"
#import "TableViewInterceptor.h"

@interface InfiniteTabelView ()

@property (nonatomic, strong) TableViewInterceptor *dataSourceInterceptor;
@property (nonatomic, assign) NSInteger actualRows;

@end

@implementation InfiniteTabelView

- (void)layoutSubviews {
    [super layoutSubviews];
    [self resetContentOffsetIfNeeded];
}

- (void)resetContentOffsetIfNeeded {
    CGPoint contentOffset = self.contentOffset;
    if (contentOffset.y < 0.0) {
        contentOffset.y = self.contentSize.height / 3.0;
    } else if (contentOffset.y >= self.contentSize.height - self.bounds.size.height) {
        contentOffset.y = self.contentSize.height / 3.0 - self.bounds.size.height;
    }
    [self setContentOffset:contentOffset];
}

- (void)setDataSource:(id<UITableViewDataSource>)dataSource {
    self.dataSourceInterceptor.receiver = dataSource;
    [super setDataSource:(id<UITableViewDataSource>)self.dataSourceInterceptor];
}

- (TableViewInterceptor *)dataSourceInterceptor {
    if (!_dataSourceInterceptor) {
        _dataSourceInterceptor = [[TableViewInterceptor alloc] init];
        _dataSourceInterceptor.middleMan = self;
    }
    return _dataSourceInterceptor;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    self.actualRows = [self.dataSourceInterceptor.receiver tableView:tableView numberOfRowsInSection:section];
    return self.actualRows * 3;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *actualIndexPath = [NSIndexPath indexPathForRow:indexPath.row % self.actualRows inSection:indexPath.section];
    return [self.dataSourceInterceptor.receiver tableView:tableView cellForRowAtIndexPath:actualIndexPath];
}

@end
