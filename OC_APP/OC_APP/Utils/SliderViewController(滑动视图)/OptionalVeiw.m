//
//  OptionalVeiw.m
//  OC_APP
//
//  Created by xingl on 2017/12/26.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "OptionalVeiw.h"

#import "SliderView.h"
#import "TitleItem.h"

@interface OptionalVeiw ()

@property (nonatomic, strong) SliderView *sliderView;

@end

static const CGFloat sliderViewWidth = 15;
static const CGFloat itemWidth = 60;

@implementation OptionalVeiw

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.sliderView];

        [self addObserver:self forKeyPath:@"_sliderView.frame" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {

    CGFloat itemVisionblePositionMax = _sliderView.frame.origin.x - (itemWidth - sliderViewWidth)/2 + 2 * itemWidth;
    CGFloat itemVisionblePositionMin = _sliderView.frame.origin.x - (itemWidth - sliderViewWidth)/2 - itemWidth;

    // 右滑
    if (itemVisionblePositionMax >= self.frame.size.width + self.contentOffset.x && itemVisionblePositionMax <= self.contentSize.width) {
        [UIView animateWithDuration:0.25 animations:^{
            self.contentOffset = CGPointMake(itemVisionblePositionMax - self.frame.size.width, 0);
        }];
    }
    // 左滑
    if (itemVisionblePositionMin < self.contentOffset.x && itemVisionblePositionMin >= 0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.contentOffset = CGPointMake(itemVisionblePositionMin, 0);
        }];
    }
}

- (void)setTitleArray:(NSArray <NSString *> *)titleArray {
    _titleArray = titleArray;

    for (NSInteger i = 0; i < titleArray.count; i++) {
        TitleItem *item = [[TitleItem alloc] initWithFrame:CGRectMake(i * itemWidth, 0, itemWidth, self.frame.size.height)];
        [item addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [item setTitle:titleArray[i] forState:UIControlStateNormal];
        item.titleLabel.font = [UIFont systemFontOfSize:15];
        [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [item setBackgroundColor:RandomColor];
        item.tag = i + 100;
        [self addSubview:item];
    }

    // 第一个item更改样式
    TitleItem *firstItem = [self viewWithTag:100];
    [firstItem setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    firstItem.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    self.contentSize = CGSizeMake(itemWidth * titleArray.count, self.frame.size.height);
}

- (void)itemClicked:(TitleItem *)sender {

    NSInteger index = (NSInteger)_contentOffsetX / (NSInteger)self.bounds.size.width;
    if (sender.tag - 100 == index) return;
    TitleItem *currentItem = [self viewWithTag:index + 100];

    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [currentItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    CGRect frame = _sliderView.frame;
    frame.origin.x = (sender.tag - 100) * itemWidth + (itemWidth - sliderViewWidth)/2;

    [UIView animateWithDuration:0.25 animations:^{
        sender.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        currentItem.transform = CGAffineTransformIdentity;
        _sliderView.frame = frame;
    }];
    !_titleItemClickedCallBackBlock ? : _titleItemClickedCallBackBlock(sender.tag);
}

- (void)setContentOffsetX:(CGFloat)contentOffsetX {
    _contentOffsetX = contentOffsetX;

    NSInteger index = (NSInteger)contentOffsetX / (NSInteger)self.bounds.size.width;
    // progress 0(屏幕边缘开始) -  1 （满屏结束）
    CGFloat progress =( _contentOffsetX - index * self.bounds.size.width)/ self.bounds.size.width;

    // 左右选项卡
    TitleItem *leftItem = [self viewWithTag:index + 100];
    TitleItem *rightItem = [self viewWithTag:index + 101];

    // item 根据progress改变状态
    leftItem.progress = 1 - progress;
    rightItem.progress = progress;

    //滑条sliderView 根据progress 改变状态
    CGRect frame = _sliderView.frame;
    frame.origin.x = index * itemWidth + (itemWidth - sliderViewWidth) / 2;
    _sliderView.frame = frame;
    _sliderView.progress = progress;
}


- (SliderView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[SliderView alloc] initWithFrame:CGRectMake((itemWidth - sliderViewWidth) / 2, self.frame.size.height - 4, sliderViewWidth, 2)];
        _sliderView.backgroundColor = [UIColor redColor];
        _sliderView.layer.cornerRadius = 2;
        _sliderView.layer.masksToBounds = YES;
        _sliderView.itemWidth = itemWidth;
    }
    return _sliderView;
}

@end
