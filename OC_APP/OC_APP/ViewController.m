//
//  ViewController.m
//  Demo
//
//  Created by 兴林 on 2016/10/12.
//  Copyright © 2016年 兴林. All rights reserved.
//

#import "ViewController.h"
#import "UserInfo.h"
#import <MBProgressHUD.h>

#import <Toast/UIView+Toast.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.view.backgroundColor =  [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1.0];
    
    StartTime;
    EndTime;
    //强弱用法引用
//    kWeakSelf(self);
//    [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        kStrongSelf(self);
//        make.left.equalTo(self.view)
//    }];
    
    if (IOS_Foundation_Before_8) {
        NSLog(@"-------");
    }
    
    
    
    NSArray *arr = @[@"王", @"兴", @"林"];
    NSLog(@"%@", arr);
    
    NSDictionary *dic = @{@"name": @"王兴林", @"age": @26, @"job": @"iOS开发工程师"};
    NSLog(@"%@", dic);
    
//    NetworkActivityIndicatorVisible(1);
    
    [self performSelector:@selector(aa) withObject:self afterDelay:1];
    
//    kShowHUDAndActivity;
    
    
    UserInfo *info1 = [UserInfo sharedInstance];
    NSLog(@"%@", info1);
    
    UserInfo *info2 = [[UserInfo alloc] init];
    NSLog(@"%@", info2);
    
    UserInfo *info3 = [info2 copy];
    NSLog(@"%@", info3);
    
    
    
    
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, onceBlock);
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kScreenHeight   -44, kScreenWidth, 44)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    toolbar.barTintColor = [UIColor redColor];
    
    UIBarButtonItem *addItem=[[ UIBarButtonItem alloc ] initWithBarButtonSystemItem : UIBarButtonSystemItemAdd target : self action : @selector(add) ];
    
    UIBarButtonItem *saveItem=[[ UIBarButtonItem alloc ] initWithBarButtonSystemItem : UIBarButtonSystemItemSave target : self action : @selector(add)];
    
    UIBarButtonItem *editItem=[[ UIBarButtonItem alloc ] initWithBarButtonSystemItem : UIBarButtonSystemItemEdit target : self action : @selector(add) ];
    
    //    UIBarButtonItem *imgItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"1"] style:UIBarButtonItemStyleBordered target:self action:@selector(add)];
    
    toolbar.items = @[addItem,saveItem,editItem];
    
    
    [self.view addSubview:toolbar];
    
}
- (IBAction)sss:(id)sender {
    DISPATCH_ONCE_BLOCK(^(){
        
        UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:@[[[NSBundle mainBundle] URLForResource:@"Steve" withExtension:@"pdf"]] applicationActivities:nil/*@[[[ZSCustomActivity alloc] init]]*/];
        
        // hide AirDrop
        //    excludedActivityTypes 这里是要隐藏的类型
        //     activity.excludedActivityTypes = @[UIActivityTypeAirDrop];
        //
        // incorrect usage
        // [self.navigationController pushViewController:activity animated:YES];
        
        UIPopoverPresentationController *popover = activity.popoverPresentationController;
        if (popover) {
            popover.sourceView = sender;
            popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
        }
        
        [self presentViewController:activity animated:YES completion:NULL];
    });
}
- (void)aa {
    
}
- (void)add {
    NSLog(@"------");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
