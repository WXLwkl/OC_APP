//
//  AddressPickViewController.m
//  OC_APP
//
//  Created by xingl on 2017/8/18.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "AddressPickViewController.h"
#import "AddressPickerView.h"
@interface AddressPickViewController ()

@property(nonatomic,strong)AddressPickerView *myAddressPickerView;

@end

@implementation AddressPickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"省市区三级联动";
    [self initSubviews];
}

- (void)initSubviews {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, kScreenWidth, 44);
    btn.backgroundColor = [UIColor grayColor];
    [btn setTitle:@"显示地区选择" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)btnClick:(UIButton *)sender {
    _myAddressPickerView = [AddressPickerView shareInstance];
    //可以设置其默认值
//    [_myAddressPickerView configDataProvince:@"福建省" City:@"厦门市" Town:@"思明区"];
    //可以判断弹出窗当前的状态
    //_myAddressPickerView.currentPickState
    
    [_myAddressPickerView showAddressPickView];
    [self.view addSubview:_myAddressPickerView];
    
    __weak UIButton *temp = (UIButton *)sender;
    _myAddressPickerView.block = ^(NSString *province,NSString *city,NSString *district) {
        [temp setTitle:[NSString stringWithFormat:@"%@ %@ %@",province,city,district] forState:UIControlStateNormal];
        
        NSLog(@"%@", [NSString stringWithFormat:@"%@ %@ %@",province,city,district]);
        
    };
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
