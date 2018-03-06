//
//  DargSortCell.m
//  OC_APP
//
//  Created by xingl on 2018/2/23.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "DargSortCell.h"
#import "DragSortTool.h"

@interface DargSortCell ()<UIGestureRecognizerDelegate>

@property (nonatomic,strong)  UILabel *label;
@property (nonatomic,strong) UIButton * deleteBtn;

@end

@implementation DargSortCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUp];
    }
    return self;
}

- (void)setUp {
    
    // 添加长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    longPress.delegate = self;
    [self addGestureRecognizer:longPress];
    
    UIPanGestureRecognizer *pan =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(gestureAction:)];
    pan.delegate = self;
    [self addGestureRecognizer:pan];
    
    _label = [[UILabel alloc] init];
    [self.contentView addSubview:_label];
    _label.font = [UIFont systemFontOfSize:15];
    _label.textColor = RGBAColor(110, 110, 110, 1);
    _label.layer.cornerRadius = 4 * SCREEN_WIDTH_RATIO;
    _label.layer.masksToBounds = NO;
    _label.layer.borderColor = RGBAColor(110, 110, 110, 1).CGColor;
    _label.layer.borderWidth = kLineHeight;
    _label.textAlignment = NSTextAlignmentCenter;
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setImage:[UIImage imageNamed:@"delete_image"] forState:UIControlStateNormal];
    _deleteBtn.xl_width = kDeleteBtnWH;
    _deleteBtn.xl_height = kDeleteBtnWH;
    _deleteBtn.backgroundColor = [UIColor redColor];
    
    [_deleteBtn addTarget:self action:@selector(cancelSubscribe) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteBtn];
    
}

- (void)showDeleteBtn {
    _deleteBtn.hidden = NO;
}


- (void)setSubscribe:(NSString *)subscribe {
    _subscribe = subscribe;
    _deleteBtn.hidden = ![DragSortTool sharedDragSortTool].isEditing;
    _label.text = subscribe;
    _label.xl_width = self.xl_width - kDeleteBtnWH;
    _label.xl_height = self.xl_height - kDeleteBtnWH;
    _label.center = CGPointMake(self.xl_width * 0.5, self.xl_height * 0.5);
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && ![DragSortTool sharedDragSortTool].isEditing) {
        return NO;
    }
    return YES;
}


#pragma mark - Action
- (void)cancelSubscribe {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dargSortCellCancelSubscribe:)]) {
        [self.delegate dargSortCellCancelSubscribe:self.subscribe];
    }
}

- (void)gestureAction:(UIGestureRecognizer *)gestureRecognizer{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dargSortCellGestureAction:)]) {
        [self.delegate dargSortCellGestureAction:gestureRecognizer];
    }
}

@end
