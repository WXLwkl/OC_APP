//
//  TurntableViewController1.m
//  抽奖
//
//  Created by xingl on 2017/12/7.
//  Copyright © 2017年 yjpal. All rights reserved.
//

#import "TurntableViewController1.h"
#import <QuartzCore/QuartzCore.h>

@interface TurntableViewController1 () <CAAnimationDelegate> {
    UIImageView *image1,*image2;
    float random;
    float orign;
}

@end

@implementation TurntableViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //添加转盘
    UIImageView *image_disk = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zb_dbj.jpg"]];
    image_disk.frame = CGRectMake(0.0, 0.0, 320.0, 320.0);
    image1 = image_disk;
    [self.view addSubview:image1];

    image_disk.layer.cornerRadius = 20;
    image_disk.layer.masksToBounds = YES;

    //添加转针
    UIImageView *image_start = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zb_jd"]];
    image_start.frame = CGRectMake(120.0, 80.0, 80.0, 120.0);
    image2 = image_start;
    [self.view addSubview:image2];

    //添加按钮
    UIButton *btn_start = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn_start.frame = CGRectMake(165.0, 350.0, 70.0, 40.0);
    btn_start.backgroundColor = [UIColor redColor];
    [btn_start setTitle:@"抽奖" forState:UIControlStateNormal];
    [btn_start addTarget:self action:@selector(choujiang) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_start];

    btn_start.layer.cornerRadius = 20;
    btn_start.layer.masksToBounds = YES;
}
- (void)choujiang
{
    //******************旋转动画******************
    /*
     //产生随机角度
     srand((unsigned)time(0));  //不加这句每次产生的随机数不变


     random = arc4random()%360;

     //设置动画
     CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
     [spin setFromValue:[NSNumber numberWithFloat:M_PI * (0.0+orign)]];
     [spin setToValue:[NSNumber numberWithFloat:M_PI * (10.0+random+orign)]];
     [spin setDuration:2.5];
     [spin setDelegate:self];//设置代理，可以相应animationDidStop:finished:函数，用以弹出提醒框
     //速度控制器
     [spin setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
     //添加动画
     [[image2 layer] addAnimation:spin forKey:nil];
     //锁定结束位置
     image2.transform = CGAffineTransformMakeRotation(M_PI * (10.0+random+orign));
     //锁定fromValue的位置
     orign = 10.0+random+orign;
     orign = fmodf(orign, 2.0);
     */

    float a = arc4random()%360;

    random = a;

    NSLog(@"---%g",a);

    //设置动画
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [spin setFromValue:[NSNumber numberWithFloat:orign]];

    [spin setToValue:[NSNumber numberWithFloat:M_PI*10 + random/180.0*M_PI]];


    NSLog(@"fromValue==%@ --> toValue==%@",[NSNumber numberWithFloat:orign],[NSNumber numberWithFloat:M_PI*10 + random/180.0*M_PI]);


    [spin setDuration:2.5];
    [spin setDelegate:self];//设置代理，可以相应animationDidStop:finished:函数，用以弹出提醒框
    //速度控制器
    [spin setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    //添加动画
    [[image2 layer] addAnimation:spin forKey:nil];
    //锁定结束位置
    image2.transform = CGAffineTransformMakeRotation(M_PI*10 + random/180.0*M_PI);
    //锁定fromValue的位置
    orign = random/180.0*M_PI;



}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{

    NSLog(@"-----");

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
