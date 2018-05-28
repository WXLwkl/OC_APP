//
//  DragSortViewController.m
//  OC_APP
//
//  Created by xingl on 2018/2/23.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "DragSortViewController.h"
#import "DargSortCell.h"
#import "DragSortTool.h"

#define kSpaceBetweenSubscribe  4 * SCREEN_WIDTH_RATIO
#define kVerticalSpaceBetweenSubscribe  2 * SCREEN_WIDTH_RATIO
#define kSubscribeHeight  35 * SCREEN_WIDTH_RATIO
#define kContentLeftAndRightSpace  20 * SCREEN_WIDTH_RATIO
#define kTopViewHeight  50 * SCREEN_WIDTH_RATIO


@interface DragSortViewController ()<UICollectionViewDataSource, DragSortDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *sortDeleteBtn;
@property (nonatomic, strong) UICollectionView *dragSortView;
@property (nonatomic, strong) UIView * snapshotView; //截屏得到的view
@property (nonatomic,   weak) DargSortCell * originalCell;
@property (nonatomic, strong) NSIndexPath * indexPath;
@property (nonatomic, strong) NSIndexPath * nextIndexPath;

@property (nonatomic, strong) NSMutableArray *subscribeArray;


@end

@implementation DragSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"拖拽排序";
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.dragSortView];
}

#pragma mark - Action
- (void)finshClick {
    [DragSortTool sharedDragSortTool].isEditing = ![DragSortTool sharedDragSortTool].isEditing;
    NSString * title = [DragSortTool sharedDragSortTool].isEditing ? @"完成":@"排序删除";
    self.dragSortView.scrollEnabled = ![DragSortTool sharedDragSortTool].isEditing;
    [_sortDeleteBtn setTitle:title forState:UIControlStateNormal];
    [self.dragSortView reloadData];
}

#pragma mark - DragSortDelegate
- (void)dargSortCellCancelSubscribe:(NSString *)subscribe {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"取消订阅%@",subscribe] message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertController dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

- (void)dargSortCellGestureAction:(UIGestureRecognizer *)gestureRecognizer {
    
    //记录上一次手势的位置
    static CGPoint startPoint;
    // 触发长按手势的cell
    DargSortCell *cell = (DargSortCell *)gestureRecognizer.view;
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        // 开始长按
        if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
            [DragSortTool sharedDragSortTool].isEditing = YES;
            [_sortDeleteBtn setTitle:@"完成" forState:UIControlStateNormal];
            self.dragSortView.scrollEnabled = NO;
        }
        if (![DragSortTool sharedDragSortTool].isEditing) {
            return;
        }
        NSArray *cells = [self.dragSortView visibleCells];
        for (DargSortCell *cell in cells) {
            [cell showDeleteBtn];
        }
        // 获取cell的截图
        _snapshotView = [cell snapshotViewAfterScreenUpdates:YES];
        _snapshotView.center = cell.center;
        [_dragSortView addSubview:_snapshotView];
        _indexPath = [_dragSortView indexPathForCell:cell];
        _originalCell = cell;
        _originalCell.hidden = YES;
        
        startPoint = [gestureRecognizer locationInView:_dragSortView];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) { //开始移动
        
        CGFloat tranX = [gestureRecognizer locationOfTouch:0 inView:_dragSortView].x - startPoint.x;
        CGFloat tranY = [gestureRecognizer locationOfTouch:0 inView:_dragSortView].y - startPoint.y;
        // 设置截图视图的位置
        _snapshotView.center = CGPointApplyAffineTransform(_snapshotView.center, CGAffineTransformMakeTranslation(tranX, tranY));
        startPoint = [gestureRecognizer locationOfTouch:0 inView:_dragSortView];
        // 计算截图视图和哪个cell相交
        for (UICollectionViewCell *cell in [_dragSortView visibleCells]) {
            // 跳过隐藏的cell
            if ([_dragSortView indexPathForCell:cell] == _indexPath) {
                continue;
            }
            // 计算中心距
            CGFloat space = sqrtf(pow(_snapshotView.center.x - cell.center.x, 2) + powf(_snapshotView.center.y - cell.center.y, 2));
            // 如果相交一半且两个视图Y的绝对值小于高度的一半就移动
            if (space <= _snapshotView.bounds.size.width * 0.5 && (fabs(_snapshotView.center.y - cell.center.y) <= _snapshotView.bounds.size.height * 0.5)) {
                _nextIndexPath = [_dragSortView indexPathForCell:cell];
                if (_nextIndexPath.item > _indexPath.item) {
                    for (NSUInteger i = _indexPath.item; i < _nextIndexPath.item; i ++) {
                        [self.subscribeArray exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                    }
                } else {
                    for (NSUInteger i = _indexPath.item; i > _nextIndexPath.item; i--) {
                        [self.subscribeArray exchangeObjectAtIndex:i withObjectAtIndex:i-1];
                    }
                }
                // 移动
                [_dragSortView moveItemAtIndexPath:_indexPath toIndexPath:_nextIndexPath];
                // 设置移动后的起始indexPath
                _indexPath = _nextIndexPath;
                break;
            }
        }
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) { //停止
        
        [_snapshotView removeFromSuperview];
        _originalCell.hidden = NO;
    }
}

#pragma mark - collectionView dataSouce
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.subscribeArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DargSortCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DargSortCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.subscribe = self.subscribeArray[indexPath.row];
    return cell;
}


#pragma mark - getter && setter

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kTopViewHeight)];
        _topView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        
        UILabel * titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.text = @"我的关注";
        [titleLabel sizeToFit];
        titleLabel.textColor = RGBColor(110, 110, 110);
        [_topView addSubview:titleLabel];
        titleLabel.xl_centerY = kTopViewHeight * 0.5;
        titleLabel.xl_x = kContentLeftAndRightSpace;
        
        UIButton *  finshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topView addSubview:finshBtn];
        [finshBtn setTitle:@"排序删除" forState:UIControlStateNormal];
        [finshBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        finshBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        finshBtn.layer.borderColor = [UIColor orangeColor].CGColor;
        finshBtn.layer.borderWidth = 1;
        finshBtn.layer.cornerRadius = 4 * SCREEN_WIDTH_RATIO;
        finshBtn.layer.masksToBounds = YES;
        [finshBtn sizeToFit];
        finshBtn.xl_height = 21 * SCREEN_WIDTH_RATIO;
        finshBtn.xl_width = finshBtn.xl_width + 10 * SCREEN_WIDTH_RATIO;
        finshBtn.xl_right = kScreenWidth - kContentLeftAndRightSpace;
        finshBtn.xl_centerY = titleLabel.xl_centerY;
        [finshBtn addTarget:self action:@selector(finshClick) forControlEvents:UIControlEventTouchUpInside];
        _sortDeleteBtn = finshBtn;
        
        UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(5, _topView.xl_height - 1, kScreenWidth - 6, 1)];
        bottomLine.backgroundColor = RGBColor(110, 110, 110);
        [_topView addSubview:bottomLine];
        
    }
    return _topView;
}

- (UICollectionView *)dragSortView {
    if (!_dragSortView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat width = (kScreenWidth - 3 * kSpaceBetweenSubscribe - 2 * kContentLeftAndRightSpace )/4 ;
        layout.itemSize = CGSizeMake(width, kSubscribeHeight + 10 * SCREEN_WIDTH_RATIO);
        layout.minimumLineSpacing = kSpaceBetweenSubscribe;
        layout.minimumInteritemSpacing = kVerticalSpaceBetweenSubscribe;
        layout.sectionInset = UIEdgeInsetsMake(kContentLeftAndRightSpace, kContentLeftAndRightSpace, kContentLeftAndRightSpace, kContentLeftAndRightSpace);
        
        
        _dragSortView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kTopViewHeight, kScreenWidth, kScreenHeight - kTopViewHeight) collectionViewLayout:layout];
        //注册cell
        [_dragSortView registerClass:[DargSortCell class] forCellWithReuseIdentifier:@"DargSortCell"];
        _dragSortView.dataSource = self;
        _dragSortView.backgroundColor = [UIColor whiteColor];
    }
    return _dragSortView;
}


- (NSMutableArray *)subscribeArray {
    
    if (!_subscribeArray) {
        
        _subscribeArray = [@[@"推荐",@"视频搜索33",@"军事",@"娱乐",@"问答",@"娱乐",@"汽车",@"段子",@"趣图",@"财经",@"热点",@"房产",@"社会",@"数码",@"美女",@"数码",@"文化",@"美文",@"星座",@"旅游",@"视频",@"军事",@"娱乐",@"问答",@"娱乐",@"汽车",@"段子",@"趣图",@"财经",@"热点",@"房产",@"社会",@"数码",@"美女",@"数码",@"文化",@"美文",@"星座",@"旅游"] mutableCopy];
    }
    return _subscribeArray;
}



@end
