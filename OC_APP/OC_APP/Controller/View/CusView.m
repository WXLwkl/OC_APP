//
//  CusView.m
//  CustomViewDemo
//
//  Created by 王凯丽 on 2017/3/25.
//  Copyright © 2017年 KL. All rights reserved.
//

#import "CusView.h"

@interface CusView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation CusView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setTitle:(NSString *)title {
    _title = title;
    self.label.text = title;
}
- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}


+ (instancetype)showView {
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
}

@end
