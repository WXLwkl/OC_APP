//
//  SliderViewController.h
//  OC_APP
//
//  Created by xingl on 2017/12/26.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SliderViewController;

@protocol SliderViewControllerDelegate <NSObject>
/** 子视图高度 (不包含optionalView高度的子视图高度, optionalView高度40), 默认适配全屏*/
- (CGFloat)viewOfChildViewControllerHeightInSliderViewController;
/** 子视图起始位置（y），默认在状态栏之下 */
- (CGFloat)optionalViewStartYInSliderViewController;
@end

@protocol SliderViewControllerDataSource <NSObject>
/** 标题个数 */
- (NSArray <NSString *> *)titlesArrayInSliderViewController;
/** index对应的子控制器 */
- (UIViewController *)sliderViewController:(SliderViewController *)sliderVC subViewControllerAtIndxe:(NSInteger)index;
@end

@interface SliderViewController : UIViewController

@property (nonatomic, weak) id <SliderViewControllerDelegate> delegate;
@property (nonatomic, weak) id <SliderViewControllerDataSource> dataSource;

@end
