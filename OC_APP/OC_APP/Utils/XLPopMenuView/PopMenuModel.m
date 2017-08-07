

#import "PopMenuButton.h"
#import "PopMenuModel.h"

@implementation PopMenuModel

+ (instancetype)allocPopMenuModelWithImageNameString:(NSString *)imageNameString

                                                 AtTitleString:(NSString *)titleString

                                                   AtTextColor:(UIColor *)textColor

                                              AtTransitionType:(PopMenuTransitionType)transitionType

                                    AtTransitionRenderingColor:(UIColor *)transitionRenderingColor
{
    PopMenuModel* model = [[PopMenuModel alloc] init];
    model.imageNameString = imageNameString;
    model.titleString = titleString;
    model.transitionType = transitionType;
    model.transitionRenderingColor = transitionRenderingColor;
    model.textColor = textColor;
    [model _obj];
    return model;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transitionType = PopMenuTransitionTypeSystemApi;
    }
    return self;
}

- (void)setAutomaticIdentificationColor:(BOOL)automaticIdentificationColor
{
    _automaticIdentificationColor = automaticIdentificationColor;
    [_customView setValue:self forKey:@"model"];
}

- (void)_obj
{
    PopMenuButton* button = [[PopMenuButton alloc] init];
    button.model = self;
    CGFloat buttonViewWidth = MIN(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)) / 3;
    buttonViewWidth = buttonViewWidth - 10;
    button.bounds = CGRectMake(0, 0, buttonViewWidth, buttonViewWidth);
    button.layer.masksToBounds = true;
    
    _customView = button;
}

@end
