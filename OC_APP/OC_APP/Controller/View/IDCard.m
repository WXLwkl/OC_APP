//
//  IDCard.m
//  OC_APP
//
//  Created by xingl on 2017/10/18.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "IDCard.h"

@interface IDCard ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation IDCard

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}
//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        [self setUpUI];
//    }
//    return self;
//}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpUI];
}
- (IBAction)nextStep:(id)sender {
    
    NSLog(@"xxxx");
}

- (void)setUpUI {
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([IDCard class]) owner:self options:nil];
    self.bounds = self.contentView.frame;
    [self addSubview:self.contentView];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
}

- (void)setImage:(UIImage *)image {
    _image = image;
    
}

@end
