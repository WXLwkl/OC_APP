//
//  UIViewController+AlertViewController.m
//  OC_APP
//
//  Created by xingl on 2018/3/29.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "UIViewController+AlertViewController.h"

//toast默认展示时间
static NSTimeInterval const XLAlertShowDurationDefault = 1.0f;

#pragma mark - XLAlertActionModel
@interface XLAlertActionModel : NSObject

@property (nonatomic, copy) NSString * title;
@property (nonatomic, assign) UIAlertActionStyle style;
@end

@implementation XLAlertActionModel

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"";
        self.style = UIAlertActionStyleDefault;
    }
    return self;
}
@end

#pragma mark - XLAlertController
/**
 AlertActions配置
 
 @param actionBlock XLAlertActionBlock
 */
typedef void (^XLAlertActionsConfig)(XLAlertActionBlock actionBlock);


@interface XLAlertController ()
//JXTAlertActionModel数组
@property (nonatomic, strong) NSMutableArray <XLAlertActionModel *>*alertActionArray;
//是否操作动画
@property (nonatomic, assign) BOOL setAlertAnimated;
//action配置
- (XLAlertActionsConfig)alertActionsConfig;
@end

@implementation XLAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.alertDidDismiss) {
        self.alertDidDismiss();
    }
}
- (void)dealloc {
    
}

- (NSMutableArray<XLAlertActionModel *> *)alertActionArray {
    if (!_alertActionArray) {
        _alertActionArray = [NSMutableArray array];
    }
    return _alertActionArray;
}

- (XLAlertActionsConfig)alertActionsConfig {
    return ^(XLAlertActionBlock actionBlock) {
        if (self.alertActionArray.count > 0) {
            // 创建action
            __weak typeof(self) weakSelf = self;
            [self.alertActionArray enumerateObjectsUsingBlock:^(XLAlertActionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle:obj.title style:obj.style handler:^(UIAlertAction * _Nonnull action) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    if (actionBlock) {
                        actionBlock(idx, action, strongSelf);
                    }
                }];
                [self addAction:alertAction];
            }];
        } else {
            NSTimeInterval duration = self.toastStyleDuration > 0 ? self.toastStyleDuration : XLAlertShowDurationDefault;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:!self.setAlertAnimated completion:NULL];
            });
        }
    };
}
- (instancetype)initAlertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle {
    if (!(title.length > 0) && (message.length > 0) && (preferredStyle == UIAlertControllerStyleAlert)) {
        title = @"";
    }
    self = [[self class] alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    if (!self) return nil;
    self.setAlertAnimated = NO;
    self.toastStyleDuration = XLAlertShowDurationDefault;
    return self;
}

- (void)alertAnimateDisabled {
    self.setAlertAnimated = YES;
}

- (XLAlertActionTitle)addActionDefaultTitle {
    return ^(NSString *title) {
        XLAlertActionModel *actionModel = [[XLAlertActionModel alloc] init];
        actionModel.title = title;
        actionModel.style = UIAlertActionStyleDefault;
        [self.alertActionArray addObject:actionModel];
        return self;
    };
}
- (XLAlertActionTitle)addActionCancelTitle {
    return ^(NSString *title) {
        XLAlertActionModel *actionModel = [[XLAlertActionModel alloc] init];
        actionModel.title = title;
        actionModel.style = UIAlertActionStyleCancel;
        [self.alertActionArray addObject:actionModel];
        return self;
    };
}

- (XLAlertActionTitle)addActionDestructiveTitle
{
    return ^(NSString *title) {
        XLAlertActionModel *actionModel = [[XLAlertActionModel alloc] init];
        actionModel.title = title;
        actionModel.style = UIAlertActionStyleDestructive;
        [self.alertActionArray addObject:actionModel];
        return self;
    };
}

@end

@implementation UIViewController (AlertViewController)

- (void)xl_showAlertWithPreferredStyle:(UIAlertControllerStyle)preferredStyle title:(NSString *)title message:(NSString *)message appearanceProcess:(XLAlertAppearanceProcess)appearanceProcess actionsBlock:(XLAlertActionBlock)actionBlock {
    if (appearanceProcess) {
        XLAlertController *alertMaker = [[XLAlertController alloc] initAlertControllerWithTitle:title message:message preferredStyle:preferredStyle];
        if (!alertMaker) return;
        
        //加工链
        appearanceProcess(alertMaker);
        //配置响应
        alertMaker.alertActionsConfig(actionBlock);
        if (alertMaker.alertDidShown) {
            [self presentViewController:alertMaker animated:!alertMaker.setAlertAnimated completion:^{
                alertMaker.alertDidShown();
            }];
        } else {
            [self presentViewController:alertMaker animated:!(alertMaker.setAlertAnimated) completion:NULL];
        }
    }
}

- (void)xl_showAlertWithTitle:(NSString *)title message:(NSString *)message appearanceProcess:(XLAlertAppearanceProcess)appearanceProcess actionsBlock:(XLAlertActionBlock)actionBlock {
    [self xl_showAlertWithPreferredStyle:UIAlertControllerStyleAlert title:title message:message appearanceProcess:appearanceProcess actionsBlock:actionBlock];
}

- (void)xl_showActionSheetWithTitle:(NSString *)title message:(NSString *)message appearanceProcess:(XLAlertAppearanceProcess)appearanceProcess actionsBlock:(XLAlertActionBlock)actionBlock {
    [self xl_showAlertWithPreferredStyle:UIAlertControllerStyleActionSheet title:title message:message appearanceProcess:appearanceProcess actionsBlock:actionBlock];
}
@end
