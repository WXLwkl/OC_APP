//
//  TableViewOptimizationViewController.m
//  OC_APP
//
//  Created by xingl on 2019/2/27.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "TableViewOptimizationViewController.h"
#import "TestModel.h"
#import "ListVM.h"
#import "ImageDownload.h"

@interface TableViewOptimizationViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary *imageLoadDic;

@property (nonatomic, strong) ListVM *vm;

@end

@implementation TableViewOptimizationViewController

- (NSMutableDictionary *)imageLoadDic {
    if (!_imageLoadDic) {
        _imageLoadDic = @{}.mutableCopy;
    }
    return _imageLoadDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _vm = [ListVM new];
    
    self.navigationItem.title = @"tableView优化";
    [self.view addSubview:self.tableView];
    
    [self loadDatas];
}

#pragma mark - loadDatas
- (void)loadDatas{
    
    [self.vm fetchDataSuccess:^{
        [self.tableView reloadData];
    }];
   
}



#pragma mark - <UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.vm.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    TestModel *model = self.vm.datas[indexPath.row];
    cell.textLabel.text = model.text;
    
    
    if (model.iconImage) {
        cell.imageView.image = model.iconImage;
    }else{
        cell.imageView.image = [UIImage imageNamed:@"userHead"];
        
        /**
         runloop - 滚动时候 - trackingMode，
         - 默认情况 - defaultRunLoopMode
         ==> 滚动的时候，进入`trackingMode`，defaultMode下的任务会暂停
         停止滚动的时候 - 进入`defaultMode` - 继续执行`trackingMode`下的任务 - 例如这里的loadImage
         */
        //        [self performSelector:@selector(p_loadImgeWithIndexPath:)
        //                   withObject:indexPath afterDelay:0.0
        //                      inModes:@[NSDefaultRunLoopMode]];
        
        //拖动的时候不显示
        if (!tableView.dragging && !tableView.decelerating) {
            //下载图片数据 - 并缓存
            [self xl_loadImageWithIndexPath:indexPath];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        // 直接停止，没有动画效果
        [self xl_loadImage];
    } else {
        //有动画效果的(惯性) - 会走`scrollViewDidEndDecelerating`方法，这里不用设置
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self xl_loadImage];
}

#pragma mark - Image load
- (void)xl_loadImageWithIndexPath:(NSIndexPath *)indexPath {
    TestModel *model = self.vm.datas[indexPath.row];
    
    ImageDownload *manager = self.imageLoadDic[indexPath];
    if (!manager) {
        manager = [ImageDownload new];
        [self.imageLoadDic setObject:manager forKey:indexPath];
    }
    [manager loadImageWithModel:model success:^{
        //主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.imageView.image = model.iconImage;
        });
        
        //加载成功-从保存的当前下载操作字典中移除
        [self.imageLoadDic removeObjectForKey:indexPath];
    }];
}

- (void)xl_loadImage {
    // 拿到界面内显示的所有的cell的indexPath
    NSArray *visibleCellIndexPaths = self.tableView.indexPathsForVisibleRows;
    for (NSIndexPath *indexPath in visibleCellIndexPaths) {
        TestModel *model = self.vm.datas[indexPath.row];
        // 判断model是否已经加载过(即是否有iconImage)， 如果已经加载则不处理，没有加载就去下载iconImage
        if (model.iconImage) {
            continue;
        }
        [self xl_loadImageWithIndexPath:indexPath];
    }
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style: UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}

@end
