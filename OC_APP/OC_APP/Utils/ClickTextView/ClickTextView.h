//
//  ClickTextView.h
//  OC_APP
//
//  Created by xingl on 2017/6/12.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickTextViewPartBlock)(NSString *clickText);

@interface ClickTextView : UITextView


/**
 设置textView的部分为下划线，并使可以点击

 @param underlineText 需要下划线的文字，如果文字范围超出总的内容，将过滤掉
 @param color 下划线的颜色，以及下划线上面的文字颜色
 @param coverColor 点击背景，如果设置相关颜色的话，将会有点击效果，如果为nil则无点击效果
 @param block 点击文字时候的回调
 */
- (void)setUnderlineTextWithUnderlineText:(NSString *)underlineText withUnderlineColor:(UIColor *)color withClickCoverColor:(UIColor *)coverColor withBlock:(ClickTextViewPartBlock)block;


@end












