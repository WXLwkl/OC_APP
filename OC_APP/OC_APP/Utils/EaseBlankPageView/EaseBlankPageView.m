//
//  EaseBlankPageView.m
//  OC_APP
//
//  Created by xingl on 2017/11/21.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "EaseBlankPageView.h"

@implementation EaseBlankPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)configWithType:(EaseBlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void (^)(id))block {
    if (hasData) {
        return [self removeFromSuperview];
    }
    self.alpha = 1.0;
    if (!_monkeyView) {
        _monkeyView = [[UIImageView alloc] init];
        [self addSubview:_monkeyView];
    }
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.numberOfLines = 0;
        _tipLabel.font = [UIFont systemFontOfSize:18];
        _tipLabel.textColor = [UIColor lightGrayColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tipLabel];
    }
    //    布局
    [_monkeyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_centerY);
    }];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerX.equalTo(self);
        make.top.equalTo(_monkeyView.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    
    _reloadButtonBlock = nil;
    
    if (!_reloadButton) {
        _reloadButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
        [_reloadButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_reloadButton setCornerRadius:20];
        [_reloadButton xl_setBorder:2 color:[UIColor grayColor]];
        _reloadButton.adjustsImageWhenHighlighted = YES;
        [_reloadButton addTarget:self action:@selector(reloadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_reloadButton];
        [_reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(_tipLabel.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(130, 40));
        }];
    }
    _reloadButton.hidden = NO;
    _reloadButtonBlock = block;
    
    if (hasError) {
        [_monkeyView setImage:[UIImage imageNamed:@"userHead"]];
        _tipLabel.text = @"貌似出了点差错";
        if (blankPageType == EaseBlankPageTypeMaterialScheduling) {
            _reloadButton.hidden = YES;
        }
    } else {
        if (_reloadButton) {
            _reloadButton.hidden = NO;
        }
        NSString *imageName, *tipStr;
        switch (blankPageType) {
            case EaseBlankPageTypeProject:
            {
                imageName = @"userHead";
                tipStr = @"当前还未有数据";
            }
                break;
            case EaseBlankPageTypeNoButton:
            {
                imageName = @"userHead";
                tipStr = @"当前还未有数据";
                if (_reloadButton) {
                    _reloadButton.hidden = YES;
                }
            }
                break;
            default:
            {
                imageName = @"userHead";
                tipStr = @"当前还未有数据";
            }
                break;
        }
        [_monkeyView setImage:[UIImage imageNamed:imageName]];
        _tipLabel.text = tipStr;
    }
}

- (void)reloadButtonClicked:(id)sender{
    self.hidden = YES;
    [self removeFromSuperview];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_reloadButtonBlock) {
            _reloadButtonBlock(sender);
        }
    });
}

@end
