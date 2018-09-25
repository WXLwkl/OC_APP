//
//  XLVideoRecorderView.m
//  OC_APP
//
//  Created by xingl on 2018/9/20.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "XLVideoRecorderView.h"
#import "XLVideoRecorder.h"

@interface XLVideoRecorderView ()<XLVideoRecorderDelegate>

@property (nonatomic, strong) XLVideoRecorder *videoRecorder;

@end


@implementation XLVideoRecorderView

- (void)dealloc {
    NSLog(@"XLVideoRecorderView dealloc");
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        [self configUI];
    }
    return self;
}

- (void)configUI {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 50);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(diss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

- (void)diss {
    [[self xl_viewController] dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - XLVideoRecorderDelegate
- (void)recordProgress:(CGFloat)progress {
    
}

#pragma mark - set、get方法
- (XLVideoRecorder *)videoRecorder {
    if (!_videoRecorder) {
        _videoRecorder = [[XLVideoRecorder alloc] init];
        _videoRecorder.delegate = self;
    }
    return _videoRecorder;
}
@end
