//
//  MultitextCell.m
//  OC_APP
//
//  Created by xingl on 2017/8/21.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "MultitextCell.h"
#import "HeaderCell.h"

@interface MultitextCell ()<UITextViewDelegate>

@property(strong,nonatomic)UILabel *myTitleLabel;
@property (strong, nonatomic)UITextView *textContentView;
@property(strong,nonatomic)UIView *lineView;

@end

@implementation MultitextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        [self initSubviews];
    }
    return self;
}
- (void)initSubviews {
    if (self.myTitleLabel == nil) {
        self.myTitleLabel = [[UILabel alloc]init];
        self.myTitleLabel.font = AdaptedFontSize(14);
        self.myTitleLabel.textColor = COLOR_WORD_GRAY_1;
        [self.contentView addSubview:self.myTitleLabel];
        
    }
    
    if(!_textContentView)
    {
        _textContentView = [[UITextView alloc]init];
        _textContentView.delegate = self;
        _textContentView.backgroundColor = [UIColor whiteColor];
        _textContentView.textColor = COLOR_WORD_BLACK;
        _textContentView.xl_placeholderColor=COLOR_WORD_GRAY_2;
        _textContentView.font = AdaptedFontSize(14);
        [self.contentView addSubview:_textContentView];
        
    }
    
    if (self.lineView == nil) {
        self.lineView = [[UIView alloc] init];
        self.lineView.hidden = YES;
        self.lineView.backgroundColor = COLOR_UNDER_LINE;
        [self.contentView addSubview:self.lineView];
        
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.myTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(AdaptedHeight(16));
    }];
    [_textContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.myTitleLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.myTitleLabel.mas_left).offset(-5);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(AdaptedHeight(80));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self).offset(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(@0.5);
    }];
}

- (BOOL)becomeFirstResponder {
    [super becomeFirstResponder];
    [_textContentView becomeFirstResponder];
    return YES;
}

- (BOOL)resignFirstResponder {
    [super resignFirstResponder];
    [_textContentView resignFirstResponder];
    return YES;
}

- (void)setCellDataKey:(NSString *)cellTitle
             textValue:(NSString *)textValue
            blankValue:(NSString *)blankvalue
              showLine:(BOOL)isShowLine {
    
    self.myTitleLabel.text=cellTitle;
    self.lineView.hidden=!isShowLine;
    if([textValue length]>0) {
        self.textContentView.text = textValue;
    } else {
        self.textContentView.xl_placeholder = blankvalue;
    }
}

#pragma mark UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView{
    if (self.textValueChangedBlock) {
        self.textValueChangedBlock(textView.text);
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


- (void)setPlaceFontSize:(CGFloat)placeFontSize {
    _textContentView.font = AdaptedFontSize(placeFontSize);
}

+ (CGFloat)cellHeight {
    return AdaptedHeight(120);
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
