//
//  UIViewController+AlertViewAndActionSheet.h
//  OC_APP
//
//  Created by xingl on 2017/7/7.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NO_USE -1000

typedef void(^click)(NSInteger index);
typedef void(^configuration)(UITextField *textField, NSInteger index);
typedef void(^clickHaveField)(NSArray<UITextField *> *fields, NSInteger index);

@interface UIViewController (AlertViewAndActionSheet)


- (void)xl_alertWithTitle:(NSString *)title
               message:(NSString *)message
             andOthers:(NSArray<NSString *> *)others
              animated:(BOOL)animated
                action:(click)click;

- (void)xl_actionSheetWithTitle:(NSString *)title
                     message:(NSString *)message
                 destructive:(NSString *)destructive
           destructiveAction:(click )destructiveAction
                   andOthers:(NSArray <NSString *> *)others
                    animated:(BOOL )animated
                      action:(click )click;

- (void)xl_alertWithTitle:(NSString *)title
               message:(NSString *)message
               buttons:(NSArray<NSString *> *)buttons
       textFieldNumber:(NSInteger )number
         configuration:(configuration )configuration
              animated:(BOOL )animated
                action:(clickHaveField )click;
@end
