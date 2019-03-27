//
//  ScrollNumLabelViewController.m
//  OC_APP
//
//  Created by xingl on 2017/12/11.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "ScrollNumLabelViewController.h"
#import "ScrollNumLabel.h"

@interface ScrollNumLabelViewController ()

@property (weak, nonatomic) ScrollNumLabel *scrollnumLabel;
@property (weak, nonatomic) ScrollNumLabel *centerDetectLabel;

@end

@implementation ScrollNumLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"滚动的数字";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self xl_setNavBackItem];
    [self initSubviews];
}

- (void)initSubviews {
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    ScrollNumLabel *num = [[ScrollNumLabel alloc] initWithFrame:(CGRect){CGPointMake(screenBounds.size.width/2 - 50, 100),CGSizeMake(2, 100)}];

    // 设置frame时
    // 如果size属性的宽不能适应展示宽度，都会自动调整
    // 如果size属性的高度不能容纳展示高度，会自动调整，能容纳则不做任何处理
    // num.frame = (CGRect){CGPointMake(screenBounds.size.width/2 - 50, 100),CGSizeMake(2, 100)};

    // 字体属性，直接赋值
    num.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    if (IOS_Foundation_Later_8) {
        num.font = [UIFont systemFontOfSize:40 weight:UIFontWeightBold];
    } else {
        num.font = [UIFont systemFontOfSize:40];
    }

    num.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.4];

    // 属性配置完成后，赋值 默认为0
    num.targetNumber = 512;

    // 如果采用center赋值 需要设置是否中心点优先
    ScrollNumLabel *centerLabel = [[ScrollNumLabel alloc] init];
    centerLabel.center = CGPointMake(screenBounds.size.width/2, 250);
    centerLabel.centerPointPriority = YES;
    centerLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    if (IOS_Foundation_Later_8) {
        centerLabel.font = [UIFont systemFontOfSize:35 weight:UIFontWeightThin];
    } else {
        centerLabel.font = [UIFont systemFontOfSize:35];
    }

    centerLabel.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.4];
    centerLabel.text = @"998";

    // 如果想当做普通的UILabel用 比如特殊值"1千"等 打开isCommonLabel 直接按照UILabel的使用即可
    ScrollNumLabel *commonLabel = [[ScrollNumLabel alloc] init];
    commonLabel.isCommonLabel = YES;
    commonLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    if (IOS_Foundation_Later_8) {
        commonLabel.font = [UIFont systemFontOfSize:35 weight:UIFontWeightThin];
    } else {
        commonLabel.font = [UIFont systemFontOfSize:35];
    }
    commonLabel.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.4];
    commonLabel.text = @"我可以当普通label用哦";
    [commonLabel sizeToFit];
    commonLabel.center = CGPointMake(screenBounds.size.width/2, commonLabel.frame.size.height/2+34);

    [self.view addSubview:num];
    [self.view addSubview:centerLabel];
    [self.view addSubview:commonLabel];
    self.scrollnumLabel = num;
    self.centerDetectLabel = centerLabel;


    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(50, self.view.bounds.size.height - 80 - 64, 100, 50);
    [btn1 setTitle:@"-" forState:UIControlStateNormal];
    btn1.tag = 100;
    btn1.backgroundColor = [UIColor orangeColor];
    [btn1 addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];


    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(200, self.view.bounds.size.height - 80 - 64, 100, 50);
    [btn2 setTitle:@"+" forState:UIControlStateNormal];
    btn2.tag = 200;
    btn2.backgroundColor = [UIColor orangeColor];
    [btn2 addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}
- (void)clicked:(UIButton *)sender {
    if (sender.tag == 100) {
        [self.scrollnumLabel decreaseNumber:1];
        [self.centerDetectLabel decreaseNumber:1];
    } else {
        NSInteger x = arc4random()%1000;

        [self.scrollnumLabel increaseNumber:x];
        [self.centerDetectLabel increaseNumber:1];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
