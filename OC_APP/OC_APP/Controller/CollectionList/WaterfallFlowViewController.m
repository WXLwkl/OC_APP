//
//  WaterfallFlowViewController.m
//  OC_APP
//
//  Created by xingl on 2018/2/22.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "WaterfallFlowViewController.h"
#import "WaterfallFlowLayout.h"
#import "FlowCell.h"

static NSString * const kIdentifierCell = @"WaterfallFlowCell";

@interface WaterfallFlowViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) WaterfallFlowLayout *waterLayout;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation WaterfallFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"瀑布流";
    [self initData];
    [self initUI];
}
#pragma mark - 实例方法
- (void)initData{
    self.dataArray = [NSMutableArray array];
    //添加照片名字
    for (int i = 0; i <= 50; i++) {
        NSString *imageName = [NSString stringWithFormat:@"00%d.jpg", i % 5];
        [self.dataArray addObject:imageName];
    }
}

- (void)initUI{
    [self.view addSubview:self.collectionView];
}

#pragma mark - 事件响应方法

#pragma mark - UICollectionViewDataSource Method
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FlowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kIdentifierCell forIndexPath:indexPath];
    cell.imageName = self.dataArray[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%ld", indexPath.row);
}
#pragma mark - set方法

#pragma mark - get方法
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:self.waterLayout];
        _collectionView.backgroundColor = [UIColor cyanColor];
        [_collectionView registerClass:[FlowCell class] forCellWithReuseIdentifier:kIdentifierCell];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}
- (WaterfallFlowLayout *)waterLayout {
    if (_waterLayout == nil) {
        //layout内部有设置默认属性
        _waterLayout = [[WaterfallFlowLayout alloc] init];
        //计算每个item高度方法，必须实现（也可以设计为代理实现）
        __weak typeof(self) weakSelf = self;
        [_waterLayout computeIndexCellHeightWithWidthBlock:^CGFloat(NSIndexPath *indexPath, CGFloat width) {
            NSString *imageName = weakSelf.dataArray[indexPath.row];
            
            
            UIImage *image = [UIImage imageNamed:imageName];
            CGFloat itemH = image.size.height / image.size.width * width;
            return itemH;
        }];
        //内间距
        _waterLayout.sectionInset = UIEdgeInsetsMake(20, 10, 10, 10);
    }
    return _waterLayout;
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
