//
//  UIViewController+AlertViewController.h
//  OC_APP
//
//  Created by xingl on 2018/3/29.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLAlertController;

/**
 XLAlertController: alertAction配置链

 @param title 标题
 @return XLAlertController对象
 */
typedef XLAlertController * _Nonnull (^XLAlertActionTitle)(NSString *title);

/**
 XLAlertController: alert按钮执行回调
 
 @param buttonIndex 按钮index(根据添加action的顺序)
 @param action      UIAlertAction对象
 @param alertSelf   本类对象
 */
typedef void(^XLAlertActionBlock)(NSInteger buttonIndex, UIAlertAction *action, XLAlertController *alertSelf);

NS_CLASS_AVAILABLE_IOS(8_0) @interface XLAlertController : UIAlertController

/**
 XLAlertController: 禁用alert弹出动画，默认执行系统的默认弹出动画
 */
- (void)alertAnimateDisabled;

/**
 XLAlertController: alert弹出后，可配置的回调
 */
@property (nullable, nonatomic, copy) void (^alertDidShown)(void);

/**
 XLAlertController: alert关闭后，可配置的回调
 */
@property (nullable, nonatomic, copy) void (^alertDidDismiss)(void);

/**
 XLAlertController: 设置toast模式展示时间：如果alert未添加任何按钮，将会以toast样式展示，这里设置展示时间，默认1s
 */
@property (nonatomic, assign) NSTimeInterval toastStyleDuration;

/**
 XLAlertController: 链式构造alert视图按钮，添加一个alertAction按钮，默认样式，参数为标题
 
 @return XLAlertController对象
 */
- (XLAlertActionTitle)addActionDefaultTitle;
/**
 XLAlertController: 链式构造alert视图按钮，添加一个alertAction按钮，取消样式，参数为标题(warning:一个alert该样式只能添加一次!!!)
 
 @return XLAlertController对象
 */
- (XLAlertActionTitle)addActionCancelTitle;

/**
 XLAlertController: 链式构造alert视图按钮，添加一个alertAction按钮，警告样式，参数为标题
 
 @return XLAlertController对象
 */
- (XLAlertActionTitle)addActionDestructiveTitle;

@end

/**
 XLAlertController: alert构造块
 
 @param alertMaker XLAlertController配置对象
 */
typedef void(^XLAlertAppearanceProcess)(XLAlertController *alertMaker);

@interface UIViewController (AlertViewController)

/**
 XLAlertController: show-alert(iOS8)
 
 @param title             title
 @param message           message
 @param appearanceProcess alert配置过程
 @param actionBlock       alert点击响应回调
 */
- (void)xl_showAlertWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message
            appearanceProcess:(XLAlertAppearanceProcess)appearanceProcess
                 actionsBlock:(nullable XLAlertActionBlock)actionBlock NS_AVAILABLE_IOS(8.0);

/**
 XLAlertController: show-actionSheet(iOS8)
 
 @param title             title
 @param message           message
 @param appearanceProcess actionSheet配置过程
 @param actionBlock       actionSheet点击响应回调
 */
- (void)xl_showActionSheetWithTitle:(nullable NSString *)title
                            message:(nullable NSString *)message
                  appearanceProcess:(XLAlertAppearanceProcess)appearanceProcess
                       actionsBlock:(nullable XLAlertActionBlock)actionBlock NS_AVAILABLE_IOS(8_0);

@end

NS_ASSUME_NONNULL_END
