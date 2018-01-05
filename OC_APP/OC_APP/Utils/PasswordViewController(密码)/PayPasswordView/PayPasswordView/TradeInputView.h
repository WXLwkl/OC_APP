//
//  TradeInputView.h
//  OC_APP
//
//  Created by xingl on 2017/12/12.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *TradeInputViewCancleButtonClick = @"TradeInputViewCancleButtonClick";
static NSString *TradeInputViewOkButtonClick = @"TradeInputViewOkButtonClick";
static NSString *ZCTradeInputViewPwdKey = @"TradeInputViewPwdKey";

@class TradeInputView;

@protocol TradeInputViewDelegate <NSObject>

@optional
/** 确定按钮点击 */
- (void)tradeInputView:(TradeInputView *)tradeInputView okBtnClick:(UIButton *)okBtn;
/** 取消按钮点击 */
- (void)tradeInputView:(TradeInputView *)tradeInputView cancleBtnClick:(UIButton *)cancleBtn;

@end


@interface TradeInputView : UIView
@property (nonatomic, weak) id<TradeInputViewDelegate> delegate;
@end
