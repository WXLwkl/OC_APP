//
//  ClipImageView.m
//  OC_APP
//
//  Created by xingl on 2017/6/21.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "ClipImageView.h"

@implementation ClipImageView


+ (void)addToCurrentView:(UIView *)view clipImage:(UIImage *)image backgroundImage:(NSString *)backgroundImageName animationComplete:(AnimationComplete)complete {
    
    CGFloat width = view.frame.size.width;
    CGFloat height = view.frame.size.height;
    
    CGFloat imageW = image.size.width * 0.5;
    CGFloat imageH = image.size.height * 0.5;
    
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:view.bounds];
    bgImageView.image = [UIImage imageNamed:backgroundImageName];
    
//    左上半部分
    UIImageView *topLeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width*0.5, height*0.5)];
    topLeftImageView.tag = 100;
    topLeftImageView.image = [self clipImage:image withRect:CGRectMake(0, 0, imageW, imageH)];
//    右上半部分
    UIImageView *topRightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width*0.5, 0, width*0.5, height*0.5)];
    topRightImageView.tag = 101;
    topRightImageView.image = [self clipImage:image withRect:CGRectMake(imageW, 0, imageW, imageH)];
    
    
    //    左下半部分
    UIImageView *bottomLeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, height*0.5, width*0.5, height*0.5)];
    bottomLeftImageView.tag = 102;
    bottomLeftImageView.image = [self clipImage:image withRect:CGRectMake(0, imageH, imageW, imageH)];
    //    右下半部分
    UIImageView *bottomRightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width*0.5, height*0.5, width*0.5, height*0.5)];
    bottomRightImageView.tag = 103;
    bottomRightImageView.image = [self clipImage:image withRect:CGRectMake(imageW, imageH, imageW, imageH)];
    
    [bgImageView addSubview:topLeftImageView];
    [bgImageView addSubview:topRightImageView];
    [bgImageView addSubview:bottomLeftImageView];
    [bgImageView addSubview:bottomRightImageView];
    
    [view addSubview:bgImageView];
    
    //延时操作
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:2 animations:^{
            CGRect topLeftRect = topLeftImageView.frame;
            topLeftRect.origin.y -= imageH;
            topLeftRect.origin.x -= imageW;
            topLeftImageView.frame = topLeftRect;
            
            CGRect topRightRect = topRightImageView.frame;
            topRightRect.origin.y -= imageH;
            topRightRect.origin.x += imageW;
            topRightImageView.frame = topRightRect;
            
            CGRect bottomLeftRect = bottomLeftImageView.frame;
            bottomLeftRect.origin.y += imageH;
            bottomLeftRect.origin.x -= imageW;
            bottomLeftImageView.frame = bottomLeftRect;
            
            CGRect bottomRightRect = bottomRightImageView.frame;
            bottomRightRect.origin.y += imageH;
            bottomRightRect.origin.x += imageW;
            bottomRightImageView.frame = bottomRightRect;
            
            bgImageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
            
        } completion:^(BOOL finished) {
            complete();
            [bgImageView removeFromSuperview];
        }];
    });
    
    
    

}


//根据大小返回裁切后的图片
+ (UIImage *)clipImage:(UIImage *)image withRect:(CGRect)rect {
    CGRect clipFrame = rect;
    CGImageRef refImage = CGImageCreateWithImageInRect(image.CGImage, clipFrame);
    UIImage *newImage = [UIImage imageWithCGImage:refImage];
    CGImageRelease(refImage);
    return newImage;
}












@end
