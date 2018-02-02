//
//  ShowSignatureView.h
//  OC_APP
//
//  Created by xingl on 2018/1/29.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowSignatureViewDelegate <NSObject>

- (void)onSubmitBtn:(UIImage *)signatureImage;

@end

@interface ShowSignatureView : UIView

@property (nonatomic, weak) id<ShowSignatureViewDelegate> delegate;

- (void)show;

- (void)hide;

@end
