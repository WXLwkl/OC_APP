//
//  TitleAndPromptCell.h
//  OC_APP
//
//  Created by xingl on 2017/8/21.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TitleAndPromptCellType){
    TitleAndPromptCellTypeInput = 0,
    TitleAndPromptCellTypeSelect
};


@interface TitleAndPromptCell : UITableViewCell


/**
 左边标题 右边当为空时显示色较浅的提示语 有值时显示内容

 @param curkey     左边标题
 @param curvalue   右边内容
 @param blankvalue 提示语
 @param showLine   是否显示下划线
 @param cellType   cell的类型
 */
- (void)setCellDataKey:(NSString *)curkey
              curValue:(NSString *)curvalue
            blankValue:(NSString *)blankvalue
            isShowLine:(BOOL)showLine
              cellType:(TitleAndPromptCellType)cellType;


@end
