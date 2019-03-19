//
//  PushPopTransitionViewController.h
//  OC_APP
//
//  Created by xingl on 2019/3/7.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PushPopTransitionViewController : RootViewController<UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView * imageView;

@property (nonatomic, strong) UILabel * titleLabel;

@end

NS_ASSUME_NONNULL_END
