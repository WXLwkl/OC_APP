//
//  SignatureView.h
//  OC_APP
//
//  Created by xingl on 2018/1/26.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

//代理
@protocol SignatureViewDelegate <NSObject>

/**
 获取截图图片
 
 @param image 手写绘制图
 */
- (void)getSignatureImg:(UIImage*)image;


/**
 产生签名手写动作
 */
- (void)onSignatureWriteAction;

@end

@interface SignatureView : UIView {
    CGFloat min;
    CGFloat max;
    CGRect origRect;
    CGFloat origionX;
    CGFloat totalWidth;
    BOOL  isSure;
}

@property (nonatomic,   copy) NSString *showMessage; //签名完成后的水印文字
@property (nonatomic, assign) id<SignatureViewDelegate> delegate;
@property (nonatomic, strong) UIImage *SignatureImg;
@property (nonatomic, strong) NSMutableArray *currentPointArr;
@property (nonatomic, assign) BOOL hasSignatureImg;

/**
 清除
 */
- (void)clear;

/**
 确定
 */
- (void)sure;

@end
