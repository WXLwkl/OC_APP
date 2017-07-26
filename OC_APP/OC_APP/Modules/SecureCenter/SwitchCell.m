//
//  SwitchCell.m
//  shoushi
//
//  Created by xingl on 2017/7/18.
//  Copyright © 2017年 xingl. All rights reserved.
//

#import "SwitchCell.h"

@interface SwitchCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@property (nonatomic, copy) SwitchBlock block;

@end

@implementation SwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = _title;
}

- (void)setupSwitchOn:(BOOL)isOn switchBlock:(SwitchBlock)block {
    [self.switchButton setOn:isOn animated:YES];
    self.block = block;
}
- (IBAction)switchAction:(UISwitch *)sender {
    if (self.block) {
        self.block(sender);
    }
}

@end
