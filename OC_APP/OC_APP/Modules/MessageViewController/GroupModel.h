//
//  GroupModel.h
//  OC_APP
//
//  Created by xingl on 2017/8/11.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupModel : NSObject

@property (nonatomic, assign)BOOL isOpened;
@property (nonatomic, retain)NSString *groupName;
@property (nonatomic, assign)NSInteger groupCount;
@property (nonatomic, retain)NSArray *groupFriends;

@end
