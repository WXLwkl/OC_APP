//
//  CellModel.h
//  OC_APP
//
//  Created by xingl on 2017/8/10.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellModel : NSObject

@property (assign, nonatomic) BOOL isOpen;  //是否要展开
@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) NSInteger level;  //决定偏移量大小
@property (copy, nonatomic) NSString *openUrl;
@property (copy, nonatomic) NSMutableArray *detailArray;
@property (copy, nonatomic) NSString *imageName;

@end
