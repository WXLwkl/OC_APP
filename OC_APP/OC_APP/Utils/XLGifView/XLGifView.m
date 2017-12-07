

#import "XLGifView.h"

#import <ImageIO/ImageIO.h>
#import <QuartzCore/QuartzCore.h>

@interface XLGifView()<CAAnimationDelegate>
@property (nonatomic , strong) NSMutableArray *frames;

@property (nonatomic , strong) NSMutableArray *frameDelayTimes;

@property (nonatomic , assign) CGFloat totalTime;
@property (nonatomic , assign) CGFloat width;
@property (nonatomic , assign) CGFloat height;


@end



@implementation XLGifView



void getFrameInfo(CFURLRef url, NSMutableArray *frames, NSMutableArray *delayTimes, CGFloat *totalTime,CGFloat *gifWidth, CGFloat *gifHeight) {
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL(url, NULL);
    
    // get frame count
    size_t frameCount = CGImageSourceGetCount(gifSource);
    for (size_t i = 0; i < frameCount; ++i) {
        // get each frame
        CGImageRef frame = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        [frames addObject:(__bridge id)frame];
        CGImageRelease(frame);
        
        // get gif info with each frame
        NSDictionary *dict = (NSDictionary*)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(gifSource, i, NULL));
        NSLog(@"kCGImagePropertyGIFDictionary %@", [dict valueForKey:(NSString*)kCGImagePropertyGIFDictionary]);
        
        // get gif size
        if (gifWidth != NULL && gifHeight != NULL) {
            *gifWidth = [[dict valueForKey:(NSString*)kCGImagePropertyPixelWidth] floatValue];
            *gifHeight = [[dict valueForKey:(NSString*)kCGImagePropertyPixelHeight] floatValue];
        }
        
        // kCGImagePropertyGIFDictionary中kCGImagePropertyGIFDelayTime，kCGImagePropertyGIFUnclampedDelayTime值是一样的
        NSDictionary *gifDict = [dict valueForKey:(NSString*)kCGImagePropertyGIFDictionary];
        [delayTimes addObject:[gifDict valueForKey:(NSString*)kCGImagePropertyGIFDelayTime]];
        
        if (totalTime) {
            *totalTime = *totalTime + [[gifDict valueForKey:(NSString*)kCGImagePropertyGIFDelayTime] floatValue];
        }
    }
}



- (id)initWithCenter:(CGPoint) center fileURL:(NSURL *)fileURL {
    if (self = [super initWithFrame:CGRectZero])
    {
        _frames = [NSMutableArray array];
        _frameDelayTimes = [NSMutableArray array];
        
        _width = 0;
        _height = 0;
        
        if (fileURL) {
            getFrameInfo((__bridge CFURLRef)fileURL, _frames, _frameDelayTimes, &_totalTime, &_width, &_height);
        }
        
        self.frame = CGRectMake(0, 0, _width, _height);
        self.center = center;
        
    }
    return self;
}

- (void)startGif {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    
    NSMutableArray *times = [NSMutableArray arrayWithCapacity:3];
    CGFloat currentTime = 0;
    NSInteger count = _frameDelayTimes.count;
    for (int i = 0; i < count; ++i) {
        [times addObject:[NSNumber numberWithFloat:(currentTime / _totalTime)]];
        currentTime += [[_frameDelayTimes objectAtIndex:i] floatValue];
    }
    [animation setKeyTimes:times];
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:3];
    for (int i = 0; i < count; ++i) {
        [images addObject:[_frames objectAtIndex:i]];
    }
    
    [animation setValues:images];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    animation.duration = _totalTime;
    animation.delegate = self;
    animation.repeatCount = 50;
    
    [self.layer addAnimation:animation forKey:@"gifAnimation"];
    
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.layer.contents = nil;
}


- (void)stopGif {
    
    [self.layer removeAllAnimations];
}
//暂停
- (void)pauseGif {
    CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0.0;
    self.layer.timeOffset = pausedTime;
}
//恢复layer上的动画
- (void)resumeGif {
    CFTimeInterval pausedTime = [self.layer timeOffset];
    self.layer.speed = 1.0;
    self.layer.timeOffset = 0.0;
    self.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.layer.beginTime = timeSincePause;
}
@end
