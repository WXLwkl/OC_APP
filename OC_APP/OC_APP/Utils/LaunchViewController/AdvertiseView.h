//
//  AdvertiseView.h
//  OC_APP
//
//  Created by xingl on 2018/1/16.
//  Copyright © 2018年 兴林. All rights reserved.
//

typedef NS_ENUM(NSUInteger, ADScreenType) {
    ADScreenTypeFull, //全屏广告
    ADScreenTypeLogo, //logo广告
};


#import <UIKit/UIKit.h>

@interface AdvertiseView : UIView


/**
 广告图的文件地址
 */
@property (nonatomic,   copy) NSString *filePath;


/**
 初始化

 @param frame frame
 @param type 屏幕类型
 */
- (instancetype)initWithFrame:(CGRect)frame withADScreenType:(ADScreenType)type pushURLString:(NSString *)url;

/** 显示广告页面方法*/
- (void)show;


@end
