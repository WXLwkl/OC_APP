//
//  ShareItem.m
//  OC_APP
//
//  Created by xingl on 2017/8/4.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "ShareItem.h"

@implementation ShareItem

- (instancetype)init
{
    self = [super initWithFrame:CGRectNull];
    if (self) {
        //1.文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        //2.文字大小
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        //3.图片的内容模式
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        self.imageView.clipsToBounds = true;
//        [self setBackgroundColor: [UIColor orangeColor]];
        //4.取消高亮
//        self.adjustsImageWhenHighlighted = false;
    }
    return self;
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    
    [super setImage:image forState:state];
    [self setTitleColor:[UIColor xl_getMainColorFromImage:self.imageView.image] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor xl_getMainColorFromImage:self.imageView.highlightedImage] forState:UIControlStateHighlighted];
}

#pragma mark 调整内部ImageView的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    CGFloat imageWidth = contentRect.size.width / 1.7;
    CGFloat imageX = CGRectGetWidth(contentRect) / 2 - imageWidth / 2;
    CGFloat imageHeight = imageWidth;
    CGFloat imageY = CGRectGetHeight(self.bounds) - (imageHeight + 30);
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
    
}

#pragma mark 调整内部UILabel的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    CGFloat titleX = 0;
    CGFloat titleHeight = 20;
    CGFloat titleY = contentRect.size.height - titleHeight;
    CGFloat titleWidth = contentRect.size.width;
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
    
}
@end
