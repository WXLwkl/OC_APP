
#import "InfunRefreshHeader.h"

@implementation InfunRefreshHeader

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare{
    [super prepare];
    
//    self.badgeBGColor = THEME_CLOLR;
    
    
    self.backgroundColor = THEME_CLOLR;
    
    // 设置控件的高度
    self.mj_h = 100;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
    //设置箭头
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh_arrow"]];
    [self addSubview:arrow];
    self.arrow = arrow;
    
    // logo
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Infun_loading"]];
    [self addSubview:logo];
    self.logo = logo;
    
    // loading
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loading.color = [UIColor redColor];
    [self addSubview:loading];
    self.loading = loading;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews{
    [super placeSubviews];
    self.label.frame = self.bounds;
    self.logo.center = CGPointMake(self.mj_w * 0.5, - self.mj_h * 1.3);
    self.loading.center = CGPointMake(self.center.x - 50, self.mj_h * 0.5);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    [super scrollViewContentOffsetDidChange:change];
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{
    [super scrollViewContentSizeDidChange:change];
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change{
    [super scrollViewPanStateDidChange:change];
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    if (state == MJRefreshStateIdle) {
        if (oldState == MJRefreshStateRefreshing) {
            [self.loading stopAnimating];
            self.arrow.hidden = NO;
            self.arrow.transform = CGAffineTransformIdentity;
            self.arrow.center = CGPointMake(self.center.x - 80, self.mj_h * 0.5);
            self.label.text = @"钓吧欢迎您";
            [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                self.loading.alpha = 0.0;
            } completion:^(BOOL finished) {
                // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
                if (self.state != MJRefreshStateIdle) return;
                
                self.loading.alpha = 1.0;
                [self.loading stopAnimating];
                self.arrow.hidden = NO;
            }];
        } else {
            [self.loading stopAnimating];
            self.arrow.hidden = NO;
            self.arrow.center = CGPointMake(self.center.x - 80, self.mj_h * 0.5);
            self.label.text = @"钓吧欢迎您";
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                self.arrow.transform = CGAffineTransformIdentity;
            }];
        }
    } else if (state == MJRefreshStatePulling) {
        [self.loading stopAnimating];
        self.arrow.center = CGPointMake(self.center.x - 50, self.mj_h * 0.5);
        self.label.text = @"松开即可刷新";
        self.arrow.hidden = NO;
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
            self.arrow.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
        }];
    } else if (state == MJRefreshStateRefreshing) {
        self.loading.alpha = 1.0; // 防止refreshing -> idle的动画完毕动作没有被执行
        [self.loading startAnimating];
        self.arrow.center = CGPointMake(self.center.x - 50, self.mj_h * 0.5);
        self.label.text = @"加载数据中";
        self.arrow.hidden = YES;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
//- (void)setPullingPercent:(CGFloat)pullingPercent
//{
//    [super setPullingPercent:pullingPercent];
//    
//    // 1.0 0.5 0.0
//    // 0.5 0.0 0.5
//    CGFloat red = 1.0 - pullingPercent * 0.5;
//    CGFloat green = 0.5 - 0.5 * pullingPercent;
//    CGFloat blue = 0.5 * pullingPercent;
//    self.label.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
//}

@end
