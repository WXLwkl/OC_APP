//
//  TanTanCardViewController.m
//  OC_APP
//
//  Created by xingl on 2018/4/12.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "TanTanCardViewController.h"
#import "CardView2.h"
#import "CustomCardViewCell.h"

@interface TanTanCardViewController ()<CardView2Delegate, CardView2DataSource>

@property (nonatomic, strong) CardView2 *cardView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *array;

@end

@implementation TanTanCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataArray = [NSMutableArray new];
    self.array = [NSMutableArray new];
    for (int i=0; i<10; i++) {
        [self.array addObject:@(i)];
    }
    
    [self.dataArray addObjectsFromArray:self.array];
    
    self.cardView = [[CardView2 alloc] initWithFrame:CGRectMake(0, 0, 300, 260)];
    self.cardView.center = self.view.center;
    [self.view addSubview:self.cardView];
    
    self.cardView.delegate = self;
    self.cardView.dataSource = self;
    [self.cardView reloadData];
    
}

- (void)cardViewNeedMoreData:(CardView2 *)cardView {
    [self performSelector:@selector(moreData) withObject:nil afterDelay:5];
}

- (void)moreData {
    [self.dataArray addObjectsFromArray:self.array];
    [self.cardView reloadData];
}

- (CardView2Cell *)cardView:(CardView2 *)cardView itemViewAtIndex:(NSInteger)index {
    static NSString *reuseIdentitfier = @"card";
    CustomCardViewCell *itemView = (CustomCardViewCell *)[cardView dequeueReusableCellWithIdentifier:reuseIdentitfier];
    if (itemView == nil) {
        itemView = [[CustomCardViewCell alloc] initWithReuseIdentifier:reuseIdentitfier];
    }
    itemView.backgroundColor = [UIColor colorWithRed:120/255.0 green:194/255.0 blue:234/255.0 alpha:1];
    if (index%2 == 0) {
        itemView.backgroundColor = [UIColor colorWithRed:175/255.0 green:222/255.0 blue:228/255.0 alpha:1];
    }
    itemView.indexLabel.text = [NSString stringWithFormat:@"index:%ld", index];
    return itemView;
}

- (NSInteger)numberOfItemViewsInCardView:(CardView2 *)cardView {
    return self.dataArray.count;
}


- (void)cardView:(CardView2 *)cardView didClickItemAtIndex:(NSInteger)index {
    NSLog(@"----%ld", index);
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
