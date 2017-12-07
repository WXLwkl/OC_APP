

#import <UIKit/UIKit.h>


@interface XLGifView : UIView

- (id)initWithCenter:(CGPoint) center fileURL:(NSURL *)fileURL;

- (void)startGif;
- (void)stopGif;

- (void)pauseGif;
- (void)resumeGif;
@end

