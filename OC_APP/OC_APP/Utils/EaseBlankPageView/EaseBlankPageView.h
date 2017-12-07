//
//  EaseBlankPageView.h
//  OC_APP
//
//  Created by xingl on 2017/11/21.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EaseBlankPageType) {
    EaseBlankPageTypeView = 0,
    EaseBlankPageTypeProject,
    EaseBlankPageTypeNoButton,
    EaseBlankPageTypeMaterialScheduling
};

@interface EaseBlankPageView : UIView

@property (nonatomic, strong) UIImageView *monkeyView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *reloadButton;
@property (nonatomic, copy) void(^reloadButtonBlock) (id sender);

- (void)configWithType:(EaseBlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void(^)(id sender))block;

@end
