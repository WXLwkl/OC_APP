

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PopMenuTransitionTypeSystemApi,
    PopMenuTransitionTypeCustomizeApi,
} PopMenuTransitionType;

@interface PopMenuModel : NSObject

@property (nonatomic, assign) BOOL automaticIdentificationColor;

@property (nonatomic, copy) NSString *imageNameString;

@property (nonatomic, copy) NSString *titleString;

@property (nonatomic, weak) UIColor *transitionRenderingColor;

@property (nonatomic, weak) UIColor *textColor;

@property (nonatomic, assign) PopMenuTransitionType transitionType;

@property (nonatomic, readonly, retain) UIView* customView;

+ (instancetype)allocPopMenuModelWithImageNameString:(NSString *)imageNameString

                                                 AtTitleString:(NSString *)titleString

                                                   AtTextColor:(UIColor *)textColor

                                              AtTransitionType:(PopMenuTransitionType)transitionType

                                    AtTransitionRenderingColor:(UIColor *)transitionRenderingColor;

@end
