//
//  DSLView.h
//  OC_APP
//
//  Created by xingl on 2018/9/4.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSLView : UIView

+ (DSLView *)make;

- (DSLView *(^)(CGRect))xl_frame;

- (DSLView *(^)(UIColor *))xl_backgroundColor;

//+ (void)loginWithName:(NSString*)name andPassword:(NSString*)passwordcompletionBlock:(void(^)(NSDictionary*dic))block;

@end
