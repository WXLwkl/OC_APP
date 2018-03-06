//
//  MarqueeView.h
//  OC_APP
//
//  Created by xingl on 2018/2/23.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MarqueeViewDelegate <NSObject>

@optional
- (void)marqueeViewDidSelectAtIndex:(NSInteger)index;
@end

@interface MarqueeView : UIView

@property (nonatomic,strong) NSArray *imgsArray;
@property (nonatomic,  weak) id<MarqueeViewDelegate> delegate;

@end
