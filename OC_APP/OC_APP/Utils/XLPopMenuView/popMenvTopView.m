//
//  popMenvTopView.m
//  XLPopMenuView
//
//  Created by XL_Mac on 16/7/15.
//  Copyright © 2016年 ouy.Aberi. All rights reserved.
//

#import "popMenvTopView.h"
#import "XLPopMenuView.h"

#define drakColor RGBColor(60, 60, 60)
#define lightColor RGBColor(249, 247, 234)


@interface popMenvTopView ()
@property (strong, nonatomic) NSArray *datas;
@property (nonatomic, assign) NSUInteger idx;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) XLPopMenuView* menu;
@end

@implementation popMenvTopView

+ (instancetype)popMenvTopView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"popMenvTopView" owner:self options:nil] firstObject];
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _idx = 0;
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.4f target:self selector:@selector(changeImage) userInfo:nil repeats:true];
    [self changeImage];
    
    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(XLPopMenuViewWillShowNotification:) name:XLPopMenuViewWillShowNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(XLPopMenuViewWillHideNotification:) name:XLPopMenuViewWillHideNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(XLPopMenuViewDidShowNotification:) name:XLPopMenuViewDidShowNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(XLPopMenuViewDidHideNotification:) name:XLPopMenuViewDidHideNotification object:nil];
}

- (void)XLPopMenuViewWillShowNotification:(NSNotification *)notification
{
    _menu = [notification object];
    if (_menu.backgroundType == PopBackgroundTypeDarkBlur ||
        _menu.backgroundType == PopBackgroundTypeDarkTranslucent) {
        self.label1.textColor = lightColor;
        self.label2.textColor = lightColor;
        self.label3.textColor = lightColor;
        self.label4.textColor = lightColor;
    } else {
        self.label1.textColor = drakColor;
        self.label2.textColor = drakColor;
        self.label3.textColor = drakColor;
        self.label4.textColor = drakColor;
    }
}

- (void)XLPopMenuViewWillHideNotification:(NSNotification *)notification
{
//...
}

- (void)XLPopMenuViewDidShowNotification:(NSNotification *)notification
{
//...
}

- (void)XLPopMenuViewDidHideNotification:(NSNotification *)notification
{
//...
}

- (void)changeImage
{
    if (![_menu isOpenMenu]) return ;
    
    _idx ++;
    if (_idx > 6) {
        _idx = 1;
    }
    __weak popMenvTopView *weak = self;
    [UIView animateWithDuration:0.2 animations:^{
        
        weak.imageView.alpha = 0;
        
    } completion:^(BOOL finished) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"img-%zd",weak.idx]];
        weak.imageView.image = image;
        [UIView animateWithDuration:0.2 animations:^{
            weak.imageView.alpha = 1;
        }];
    }];
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
}

- (void)dealloc
{
    
}

@end
