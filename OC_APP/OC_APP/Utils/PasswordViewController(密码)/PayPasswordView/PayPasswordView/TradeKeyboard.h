//
//  TradeKeyboard.h
//  OC_APP
//
//  Created by xingl on 2017/12/12.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *TradeKeyboardDeleteButtonClick = @"TradeKeyboardDeleteButtonClick";
static NSString *TradeKeyboardOkButtonClick = @"TradeKeyboardOkButtonClick";
static NSString *TradeKeyboardNumberButtonClick = @"TradeKeyboardNumberButtonClick";
static NSString *TradeKeyboardNumberKey = @"TradeKeyboardNumberKey";

@class TradeKeyboard;

@protocol TradeKeyboardDelegate <NSObject>

@optional
/** 数字按钮点击 */
- (void)tradeKeyboard:(TradeKeyboard *)keyboard numBtnClick:(NSInteger)num;
/** 删除按钮点击 */
- (void)tradeKeyboardDeleteBtnClick;
/** 确定按钮点击 */
- (void)tradeKeyboardOkBtnClick;
@end

@interface TradeKeyboard : UIView

@property (nonatomic, weak) id<TradeKeyboardDelegate> delegate;

@end
