//
//  Pop11ViewController.m
//  OC_APP
//
//  Created by xingl on 2019/3/8.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "Pop11ViewController.h"
#import "Pop12ViewController.h"
#import "PopTransitionInteractive.h"

@interface Pop11ViewController ()

@property (nonatomic, strong) PopTransitionInteractive *transitionInteractive;

@end

@implementation Pop11ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.transitionInteractive.interactiveType = PopInteractiveTypePresent;
    self.transitionInteractive.presentConifg = ^{
        [self present];
    };
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"01.png"]];
    imageView.layer.cornerRadius = 10;
    imageView.layer.masksToBounds = YES;
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).offset(70);
        make.size.mas_equalTo(CGSizeMake(250, 250));
    }];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"点我或者向上滑动present" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(imageView.mas_bottom).offset(30);
    }];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(present) forControlEvents:UIControlEventTouchUpInside];
}

- (void)present{
    Pop12ViewController  *presentedVC = [Pop12ViewController new];
    presentedVC.interactivePush = self.transitionInteractive;
    [self presentViewController:presentedVC animated:YES completion:nil];
}

- (PopTransitionInteractive *)transitionInteractive {
    if (!_transitionInteractive) {
        _transitionInteractive = [[PopTransitionInteractive alloc] init];
        [_transitionInteractive addPanGestureForViewController:self];
    }
    return _transitionInteractive;
}


@end
