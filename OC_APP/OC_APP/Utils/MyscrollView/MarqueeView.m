//
//  MarqueeView.m
//  OC_APP
//
//  Created by xingl on 2018/2/23.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "MarqueeView.h"
#import "MarqueeCell.h"

@interface MarqueeView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,  weak) UICollectionView *collectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation MarqueeView

static NSString *const identifier = @"cycleID";
/**UICollectionView的分组数 */
static int const SectionNumber = 4;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initialization];
    }
    return self;
}

- (void)initialization {
    //init UICollectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout = flowLayout;
    UICollectionView *TFCollectionView = [[UICollectionView alloc]initWithFrame:self.frame collectionViewLayout:flowLayout];
    self.collectionView = TFCollectionView;
    [self addSubview:TFCollectionView];
    TFCollectionView.backgroundColor = [UIColor whiteColor];
    TFCollectionView.delegate = self;
    TFCollectionView.dataSource = self;
    self.flowLayout = flowLayout;
    TFCollectionView.pagingEnabled = YES;
    //    TFCollectionView.scrolldi
    TFCollectionView.showsHorizontalScrollIndicator = NO;
    TFCollectionView.showsVerticalScrollIndicator = NO;
    
    [self.collectionView registerClass:[MarqueeCell class] forCellWithReuseIdentifier:identifier];
    
    self.dataArray = @[
                                  @"神盾大家族好不好看",
                                  @"Skey逆反了，后续剧情如何",
                                  @"乔布斯毕业演讲人人改听的三次",
                                  @"Apple8000普光，大家反映难看",
                                  @"http://p1.so.qhimg.com/t01739d7baafb216b61"
                                  ];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
    
    //设置布局
    self.flowLayout.itemSize = self.frame.size; //CGSizeMake(self.frame.size.width, imgH);
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//UICollectionViewScrollDirectionHorizontal;
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:SectionNumber / 2] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    
    [self addTimer];
}

#pragma - mark UICollectionView代理
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return SectionNumber;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MarqueeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.title = self.dataArray[indexPath.item];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(marqueeViewDidSelectAtIndex:)]) {
        [self.delegate marqueeViewDidSelectAtIndex:indexPath.item];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self destroyTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self addTimer];
}

- (NSIndexPath *)resetIndexPath {
    // 当前正在展示的位置
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    NSLog(@"-VisibleItems:%ld---",currentIndexPath.item);
    
    // 马上显示回最中间那组的数据
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:SectionNumber/2];
    [self.collectionView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    return currentIndexPathReset;
}

- (void)goToNext {
    if (!self.timer)  return;
    NSIndexPath *currentIndexPath = [self resetIndexPath];
    NSInteger nextItem = currentIndexPath.item + 1;
    NSInteger nextSection = currentIndexPath.section;
    NSLog(@"-:%ld-:%ld---:%ld",currentIndexPath.item,(long)nextItem,(long)nextSection);
    if (nextItem == self.dataArray.count) {
        nextItem = 0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
}

#pragma mark - 增加定时器
- (void)addTimer {
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(goToNext) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        //消息循环，添加到主线程
        //extern NSString* const NSDefaultRunLoopMode;  //默认没有优先级
        //extern NSString* const NSRunLoopCommonModes;  //提高优先级
    }
}
#pragma mark - 销毁定时器
- (void)destroyTimer {
    [self.timer invalidate];
    self.timer = nil;
}


- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

- (void)dealloc {
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview && self.timer) {
        // 销毁定时器
        [self.timer invalidate];
        self.timer = nil;
    }
}


@end
