//
//  MultitextCell.h
//  OC_APP
//
//  Created by xingl on 2017/8/21.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultitextCell : UITableViewCell

//字体大小
@property(nonatomic,assign)CGFloat placeFontSize;

@property (nonatomic,copy) void(^textValueChangedBlock)(NSString* text);

//返回行高
+ (CGFloat)cellHeight;

/**
 <#Description#>

 @param cellTitle 标题
 @param textValue 值
 @param blankvalue 空值时的提示语
 @param isShowLine 是否显示下划线
 */
- (void)setCellDataKey:(NSString *)cellTitle
             textValue:(NSString *)textValue
            blankValue:(NSString *)blankvalue
              showLine:(BOOL)isShowLine;

//焦点事件
-(BOOL)becomeFirstResponder;

-(BOOL)resignFirstResponder;


@end
