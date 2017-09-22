//
//  AddressPickerView.h
//  OC_APP
//
//  Created by xingl on 2017/8/18.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AdressBlock)(NSString *province, NSString *city, NSString *district);

@interface AddressPickerView : UIView

@property (nonatomic,copy) AdressBlock block;

//当前弹出视图的显示状态(YES 处于弹出状态 NO 隐藏状态)
@property(nonatomic)BOOL currentPickState;


+ (id)shareInstance;

/** 显示 */
- (void)showAddressPickView;

/** 隐藏 */
- (void)hiddenAddressPickView;

/** 绑定默认值 省名 市名 区名 */
- (void)configDataProvince:(NSString *)provinceName City:(NSString *)cityName Town:(NSString *)townName;

@end
