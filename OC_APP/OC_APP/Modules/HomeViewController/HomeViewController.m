//
//  HomeViewController.m
//  OC_APP
//
//  Created by xingl on 2017/6/7.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "HomeViewController.h"

#import "ViewController.h"


#define TITLES @[@"修改", @"删除", @"扫一扫",@"付款",@"加好友",@"查找好友"]
#define ICONS  @[@"motify",@"delete",@"saoyisao",@"pay",@"delete",@"delete"]

@interface HomeViewController ()<PopoverMenuDelegate>


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
    self.view.backgroundColor = [UIColor xl_colorWithHexString:@"0x1FB5EC"];
    
    
    UIButton *rightItem = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [rightItem sizeToFit];
    [rightItem addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
    
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 30, 150, 50);
    btn.backgroundColor = [UIColor grayColor];
    [btn setTitle:@"开始" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    

    
    
    
    
    
    
    
    //条形码
    UIImage *barImage = [UIImage xl_barCodeImageWithContent:@"123456"
                                             codeImageSize:CGSizeMake(300, 90)
                                                       red:0
                                                     green:0.4
                                                      blue:0.6];
    CGRect barImageView_Frame = CGRectMake(self.view.bounds.size.width/2-300/2, 100, 300, 90);
    UIImageView *barImageView = [[UIImageView alloc] initWithFrame:barImageView_Frame];
    barImageView.image = barImage;
    barImageView.backgroundColor = [UIColor clearColor];
    //阴影
    barImageView.layer.shadowOffset = CGSizeMake(-0.5, 0.5);
    barImageView.layer.shadowRadius = 0.5;
    barImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    barImageView.layer.shadowOpacity = 0.2;
    
    [self.view addSubview:barImageView];
    
    
    
    
}

- (void)add:(UIButton *)button {
    [PopoverMenu showRelyOnView:button titles:TITLES icons:ICONS menuWidth:150 delegate:self];
}

- (void)btnClick {
    ViewController *vc = [[ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(PopoverMenu *)ybPopupMenu
{
    NSLog(@"点击了 %@ 选项",TITLES[index]);
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
