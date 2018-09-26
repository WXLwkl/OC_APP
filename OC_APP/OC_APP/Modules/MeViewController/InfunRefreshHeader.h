

//#import "MJRefreshHeader.h"
#import "XLRefreshHeader.h"

@interface InfunRefreshHeader : XLRefreshHeader
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UIImageView *arrow;
@property (weak, nonatomic) UIImageView *logo;
@property (weak, nonatomic) UIActivityIndicatorView *loading;

@end
