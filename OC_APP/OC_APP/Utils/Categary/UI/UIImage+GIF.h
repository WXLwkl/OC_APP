//
//  UIImage+GIF.h
//  OC_APP
//
//  Created by xingl on 2018/1/11.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GIF)

+ (UIImage *)xl_animatedGIFWithData:(NSData *)data;

+ (UIImage *)xl_animatedGIFNamed:(NSString *)name;







@end
