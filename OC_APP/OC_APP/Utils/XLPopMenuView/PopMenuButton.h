
#import "XLPopMenuView.h"
#import <UIKit/UIKit.h>
#import "PopMenuModel.h"


@class PopMenuButton;

typedef void (^completionAnimation)(PopMenuButton *);

@interface PopMenuButton : UIButton <CAAnimationDelegate>

@property (nonatomic, strong) PopMenuModel *model;

@property (nonatomic, strong) completionAnimation block;

- (instancetype)init;
- (void)selectdAnimation;
- (void)cancelAnimation;

@end
