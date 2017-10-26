//
//  MyView.m
//  CustomViewDemo
//
//  Created by 王凯丽 on 2017/3/25.
//  Copyright © 2017年 KL. All rights reserved.
//

#import "MyView.h"


@interface MyView ()
@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@end

@implementation MyView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initSubViews];
}

// 步骤3 在initWithFrame:方法中添加子控件
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 注意：该处不要给子控件设置frame与数据，可以在这里初始化子控件的属性
        [self initSubViews];
    }
    return self;
}
- (void)initSubViews {
    UIImageView *iconImageView = [[UIImageView alloc] init];
    self.iconImageView = iconImageView;
//    iconImageView.image = [UIImage imageNamed:@"cloudy"];
    [self addSubview:iconImageView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    // 设置子控件的属性
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:10];
    self.nameLabel = nameLabel;
    //        nameLabel.text = @"XXXXX";
    nameLabel.backgroundColor = [UIColor redColor];
    [self addSubview:nameLabel];
}
// 步骤4 在`layoutSubviews`方法中设置子控件的`frame`（在该方法中一定要调用`[super layoutSubviews]`方法）
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    self.iconImageView.frame = CGRectMake(0, 0, width, width);
    self.nameLabel.frame = CGRectMake(0, width, width, height - width);
}

// 步骤6 在该`setter`方法中取出模型属性，给对应的子控件赋值
//- (void)setModel:(CustomModel *)model
//{
//    _model = model;
//    
//    self.iconImageView.image = [UIImage imageNamed:model.icon];
//    self.nameLabel.text = model.name;
//    
//}
- (void)setTitle:(NSString *)title {
    _title = title;
    self.nameLabel.text = title;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.iconImageView.image = image;
}

@end
