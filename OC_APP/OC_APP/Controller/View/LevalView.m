//
//  LevalView.m
//  CardSwitchViewDemo
//
//  Created by xingl on 2017/1/18.
//  Copyright © 2017年 yjpal. All rights reserved.
//

#import "LevalView.h"

@interface LevalView ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) NSArray * scrollSubViews;
@end

@implementation LevalView


- (instancetype)initWithFrame:(CGRect)frame withInfoArray:(NSArray *)info
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat unitW = frame.size.width*0.7;
        CGFloat unitH = frame.size.height;
        NSInteger count = info.count;
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, unitW, unitH)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.clipsToBounds = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.center = CGPointMake(self.bounds.size.width/2.0, unitH/2.0);
        _scrollView.contentSize = CGSizeMake(unitW * count, unitH);
        [self addSubview:_scrollView];
        
        NSMutableArray * array = [[NSMutableArray alloc]init];
        for (int i = 0; i < count; i++)
        {
            UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(i * unitW, 1, unitW-2, unitH-2)];
            bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:info[i][@"bgColor"]]];
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bgView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
            
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            //设置大小
            maskLayer.frame = bgView.bounds;
            //设置图形样子
            maskLayer.path = maskPath.CGPath;
            
            bgView.layer.mask = maskLayer;
            
            
            
            // 设置头像
            UIImageView * avaterIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 50, 50)];
            avaterIcon.image = [UIImage imageNamed:@"1"];
            avaterIcon.layer.cornerRadius = avaterIcon.frame.size.height/2.0;
            avaterIcon.layer.masksToBounds = YES;
            [bgView addSubview:avaterIcon];
            
            UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 75, unitW, 11)];
            nameLabel.text = info[i][@"name"];
            nameLabel.textColor = [UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.00f];
            [bgView addSubview:nameLabel];
            nameLabel.textAlignment = NSTextAlignmentCenter;
            nameLabel.font = [UIFont systemFontOfSize:10];
            
            UILabel * locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 94, unitW, 11)];
            locationLabel.text = info[i][@"department"];
            locationLabel.textAlignment = NSTextAlignmentCenter;
            locationLabel.textColor = [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f];
            locationLabel.font = [UIFont systemFontOfSize:10];
            [bgView addSubview:locationLabel];
            
            UILabel * jobLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 109, unitW, 11)];
            jobLabel.text = info[i][@"job"];
            jobLabel.textAlignment = NSTextAlignmentCenter;
            
            jobLabel.textColor = [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f];
            jobLabel.font = [UIFont systemFontOfSize:10];
            [bgView addSubview:jobLabel];
            
            
        
            [_scrollView addSubview:bgView];
            [array addObject:bgView];
        }
        
        _scrollSubViews = array;
        if (array.count >= 2)
        {
            _scrollView.contentOffset = CGPointMake(unitW, 0);
            
        }
        [self scrollViewDidScroll:_scrollView];

        self.clipsToBounds = YES;
    }
    return self;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat viewHeight = scrollView.frame.size.width;
    for (UIView * subView in _scrollSubViews)
    {
        CGFloat y = subView.center.x - scrollView.contentOffset.x;
        CGFloat p = y - viewHeight / 2;
        float scale = cos(0.6 * p / viewHeight);
        
        if (scale<0.7) {
            scale = 0.7;
        }
        subView.transform = CGAffineTransformMakeScale(scale, scale);
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    int index = scrollView.contentOffset.x/scrollView.frame.size.width;
    UILabel *tag = (UILabel *)[self viewWithTag:100];
    tag.text = [NSString stringWithFormat:@"这个是第%d个页面",index+1];
}
@end
