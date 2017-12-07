//
//  UITableView+Common.m
//  OC_APP
//
//  Created by xingl on 2017/11/22.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "UITableView+Common.h"
#import "SurePlaceholderView.h"
@implementation UITableView (Common)

- (void)setFirstReload:(BOOL)firstReload {
    objc_setAssociatedObject(self, @selector(firstReload), @(firstReload), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)firstReload {
    return [objc_getAssociatedObject(self, @selector(firstReload)) boolValue];
}

- (void)setPlaceholderView:(UIView *)placeholderView {
    objc_setAssociatedObject(self, @selector(placeholderView), placeholderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)placeholderView {
    return objc_getAssociatedObject(self, @selector(placeholderView));
}

- (void)setReloadBlock:(void (^)(void))reloadBlock {
    objc_setAssociatedObject(self, @selector(reloadBlock), reloadBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(void))reloadBlock {
    return objc_getAssociatedObject(self, @selector(reloadBlock));
}

+ (void)load {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self xl_methodSwizzlingWithOriginalSelector:@selector(reloadData) bySwizzledSelector:@selector(xl_reloadData)];
        [self xl_methodSwizzlingWithOriginalSelector:@selector(reloadSections:withRowAnimation:) bySwizzledSelector:@selector(xl_reloadSections:withRowAnimation:)];
    });
}
- (void)xl_reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    
    
    if (!self.firstReload) {
        
        [self checkEmpty];
    }
    self.firstReload = YES;
    [self xl_reloadSections:sections withRowAnimation:animation];
}

- (void)xl_reloadData {
    
    if (!self.firstReload) {
        
        [self checkEmpty];
    }
    self.firstReload = NO;
    [self xl_reloadData];
}
- (void)checkEmpty {
    BOOL isEmpty = YES;//flag标示
    
    id <UITableViewDataSource> dataSource = self.dataSource;
    NSInteger sections = 1;
    if ([dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        sections = [dataSource numberOfSectionsInTableView:self] - 1; //获取当前tableview组数
    }
    for (NSInteger i = 0; i <= sections; i ++) {
        NSInteger rows = [dataSource tableView:self numberOfRowsInSection:i];//获取当前tableview各组的行数
        
        if (rows) {
            isEmpty = NO;//若行数存在，不为空
            break;
        }
    }
    if (isEmpty) { //数据为空，加载占位图
        //默认占位图
        if (!self.placeholderView) {
            [self makeDefaultPalceholderView];
        }
        
        self.placeholderView.hidden = NO;
        [self addSubview:self.placeholderView];
    } else {//不为空，移除占位图
        self.placeholderView.hidden = YES;
        [self.placeholderView removeFromSuperview];
    }
    
}

- (void)makeDefaultPalceholderView {
    self.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    SurePlaceholderView *view = [[SurePlaceholderView alloc] initWithFrame:self.bounds];
    WeakSelf(self);
    [view setReloadClickBlock:^{
        if (weakself.reloadBlock) {
            weakself.reloadBlock();
        }
    }];
    self.placeholderView = view;
}

@end
