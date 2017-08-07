


#import "XLRefreshHeader.h"

@interface XLRefreshHeader ()

@property (weak, nonatomic) UIActivityIndicatorView *loadingView;

@end

@implementation XLRefreshHeader

- (instancetype)init
{
    if (self = [super init]) {

        [self setTitle:@"释放即可刷新" forState:MJRefreshStatePulling];
        [self setTitle:@"正在加载" forState:MJRefreshStateRefreshing];

    }
    return self;
}
- (void)setLastUpdatedTimeKey:(NSString *)lastUpdatedTimeKey {
    
    [super setLastUpdatedTimeKey:lastUpdatedTimeKey];
    self.lastUpdatedTimeLabel.text = @"账户资金安全由阳光保险和新浪支付共同保障";
    
}
- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.stateLabel.hidden) return;
    
    BOOL noConstrainsOnStatusLabel = self.stateLabel.constraints.count == 0;
    
    if (self.lastUpdatedTimeLabel.hidden) {
        // 状态
        if (noConstrainsOnStatusLabel) self.stateLabel.frame = self.bounds;
    } else {
        CGFloat stateLabelH = self.mj_h * 0.5;
        // 上
        if (noConstrainsOnStatusLabel) {
            
            self.lastUpdatedTimeLabel.mj_x = 0;
            self.lastUpdatedTimeLabel.mj_y = 0;
            self.lastUpdatedTimeLabel.mj_w = self.mj_w;
            self.lastUpdatedTimeLabel.mj_h = stateLabelH;
        }
        
        // 下
        if (self.lastUpdatedTimeLabel.constraints.count == 0) {
            
            self.stateLabel.mj_x = 0;
            self.stateLabel.mj_y = 10;
            self.stateLabel.mj_w = self.mj_w;
            self.stateLabel.mj_h = self.mj_h - self.lastUpdatedTimeLabel.mj_y;
        }
    }
    
    // 箭头的中心点
    CGFloat arrowCenterX = self.mj_w * .5;
    if (!self.stateLabel.hidden) {
        CGFloat offset = 20;
        CGFloat stateWidth = self.stateLabel.mj_textWith;
        CGFloat timeWidth = 0.0;
        if (!self.lastUpdatedTimeLabel.hidden) {
            timeWidth = self.lastUpdatedTimeLabel.mj_textWith;
        }
        CGFloat textWidth = MIN(stateWidth, timeWidth);
        arrowCenterX -= textWidth / 2 + offset;
    }
//    CGFloat arrowCenterY = self.mj_h * 0.5;
    CGFloat arrowCenterY = self.stateLabel.centerY;
    CGPoint arrowCenter = CGPointMake(arrowCenterX, arrowCenterY);
    
    // 箭头
    if (self.arrowView.constraints.count == 0) {
        self.arrowView.mj_size = self.arrowView.image.size;
        self.arrowView.center = arrowCenter;
    }
    
    // 圈圈
    if (self.loadingView.constraints.count == 0) {
        self.loadingView.center = arrowCenter;
    }
    
    self.arrowView.tintColor = self.stateLabel.textColor;
    
    
    
}

- (UIActivityIndicatorView *)loadingView
{
    if (!_loadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorViewStyle];
        loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}



@end
