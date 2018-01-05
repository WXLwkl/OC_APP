//
//  PayPasswordView.h
//  OC_APP
//
//  Created by xingl on 2017/12/12.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PayPasswordViewDelegate <NSObject>

@optional
/** 输入完成点击确定按钮 */
- (NSString *)finish:(NSString *)pwd;

@end

@interface PayPasswordView : UIView

@property (nonatomic, weak) id<PayPasswordViewDelegate> delegate;

/** 完成的回调block */
@property (nonatomic, copy) void (^finish) (NSString *passWord);

/** 快速创建 */
+ (instancetype)tradeView;

/** 弹出 */
- (void)show;

- (void)showInView:(UIView *)view;

@end
