//
//  GroupShadowTableView.h
//  OC_APP
//
//  Created by xingl on 2018/8/27.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupShadowTableView;

@protocol GroupShadowTableViewDelegate <NSObject>

@optional
- (void)groupShadowTableView:(GroupShadowTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)groupShadowTableView:(GroupShadowTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)groupShadowTableView:(GroupShadowTableView *)tableView canSelectAtSection:(NSInteger)section;

@end

@protocol GroupShadowTableViewDataSource <NSObject>

@required
- (NSInteger)groupShadowTableView:(GroupShadowTableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)groupShadowTableView:(GroupShadowTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSInteger)numberOfSectionsInGroupShadowTableView:(GroupShadowTableView *)tableView;

@end



@interface GroupShadowTableView : UITableView

/// 是否显示分割线 默认为YES
@property (nonatomic, assign) BOOL showSeparator;

@property (nonatomic, weak) id<GroupShadowTableViewDelegate> groupShadowDelegate;
@property (nonatomic, weak) id<GroupShadowTableViewDataSource> groupShadowDataSource;

@end
