//
//  TitleAndPromptCell.m
//  OC_APP
//
//  Created by xingl on 2017/8/21.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "TitleAndPromptCell.h"
#import "HeaderCell.h"

@interface TitleAndPromptCell ()

@property (nonatomic, strong) UILabel *keyLabel, *valueLabel;
@property (nonatomic, strong) UIView *lineView;

@end

static const CGFloat spaceWith=15;

@implementation TitleAndPromptCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.accessoryType   = UITableViewCellAccessoryNone;
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        [self initSubviews];
    }
    return self;
}
- (void)initSubviews {
    if (self.keyLabel == nil) {
        self.keyLabel = [[UILabel alloc]init];
        self.keyLabel.font = AdaptedFontSize(14);
        self.keyLabel.textColor = COLOR_WORD_GRAY_1;
        [self.contentView addSubview:self.keyLabel];
        [self.keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(spaceWith);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(80, AdaptedHeight(15)));
        }];
    }
    
    if (self.valueLabel == nil) {
        self.valueLabel = [[UILabel alloc]init];
        self.valueLabel.textAlignment = NSTextAlignmentRight;
        self.valueLabel.font = AdaptedFontSize(14);
        self.valueLabel.textColor = COLOR_WORD_GRAY_2;
        [self.contentView addSubview:self.valueLabel];
        [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth-80-2*spaceWith, AdaptedHeight(18)));
        }];
    }
    
    if (self.lineView == nil) {
        self.lineView = [[UIView alloc] init];
        self.lineView.hidden = YES;
        self.lineView.backgroundColor = COLOR_UNDER_LINE;
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(spaceWith);
            make.right.mas_equalTo(self).offset(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(@0.5);
        }];
    }
}

- (void)setCellDataKey:(NSString *)curkey
              curValue:(NSString *)curvalue
            blankValue:(NSString *)blankvalue
            isShowLine:(BOOL)showLine
              cellType:(TitleAndPromptCellType)cellType {
    self.keyLabel.text = curkey;
    self.lineView.hidden = !showLine;
    if ([curvalue length] == 0) {
        self.valueLabel.text = blankvalue;
        self.valueLabel.textColor = COLOR_WORD_GRAY_2;
    } else {
        self.valueLabel.text = curvalue;
        self.valueLabel.textColor = COLOR_WORD_BLACK;
    }
    switch (cellType) {
        case TitleAndPromptCellTypeInput:
        {
            self.accessoryType = UITableViewCellAccessoryNone;
            [self.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.right.mas_equalTo(-spaceWith);
                make.size.mas_equalTo(CGSizeMake(kScreenWidth-80-2*spaceWith, AdaptedHeight(18)));
            }];
            [self.valueLabel layoutIfNeeded];
        }
            break;
        case TitleAndPromptCellTypeSelect:
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
