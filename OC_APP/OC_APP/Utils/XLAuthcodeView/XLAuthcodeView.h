//
//  XLAuthcodeView.h
//  OC_APP
//
//  Created by xingl on 2017/6/23.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLAuthcodeView : UIView

@property (nonatomic, strong) NSArray *dataArray; //字符素材数组
@property (nonatomic, strong) NSMutableString *authCodeStr;  // 验证码字符串

@end
