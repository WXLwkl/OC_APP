//
//  UIBarButtonItem+Common.m
//  OC_APP
//
//  Created by xingl on 2017/8/1.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "UIBarButtonItem+Common.h"

@implementation UIBarButtonItem (Common)

+ (UIBarButtonItem *)xl_itemImage:(NSString *)imageName
                   highlightImage:(NSString *)imageNameH
                           target:(NSObject *)target
                              sel:(SEL)sel {
    
    return [UIBarButtonItem xl_itemImage:[UIImage imageNamed:imageName]
                               highlight:imageNameH?[UIImage imageNamed:imageNameH]:nil
                                  target:target
                                     sel:sel];
}

+ (UIBarButtonItem *)xl_itemImage:(UIImage *)image
                       highlight:(UIImage *)imageH
                          target:(NSObject *)target
                             sel:(SEL)sel {
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:imageH forState:UIControlStateHighlighted];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    return item;
}

+ (UIBarButtonItem *)xl_itemTitle:(NSString *)title
                      color:(UIColor *)titleColor
                     target:(NSObject *)target
                        sel:(SEL)sel {
    
    return [self xl_itemTitle:title
                   color:titleColor
                    font:[UIFont systemFontOfSize:17.0]
                  target:target
                     sel:sel];
}

+ (UIBarButtonItem *)xl_itemTitle:(NSString *)title
                      color:(UIColor *)titleColor
                       font:(UIFont *)font
                     target:(NSObject *)target
                        sel:(SEL)sel {
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    btn.backgroundColor = [UIColor clearColor];
    if (font) btn.titleLabel.font = font;
    
    [btn setTitle:title forState:UIControlStateNormal];
    if (titleColor)
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    else
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    return item;
}
@end
