//
//  QQTableViewController.m
//  OC_APP
//
//  Created by xingl on 2017/8/10.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "QQTableViewController.h"
#import "CellModel.h"


#define LabelTag            101
#define SpaceWidth          15


@interface QQTableViewController ()

@property (copy, nonatomic) NSMutableArray *dataArray;
@property (copy, nonatomic) NSIndexPath *indexPath;
@property (copy, nonatomic) NSMutableArray *resultArray;

@end

@implementation QQTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"多个Cell表";
    self.view.backgroundColor = [UIColor whiteColor];

//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ID"];
    
     [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"title"];
    [self.tableView setTableFooterView:[UIView new]];
    [self initData];
}

- (void)initData {
    _dataArray = [NSMutableArray new];
    _resultArray = [NSMutableArray new];
    
    NSMutableArray *secondArray1 = [NSMutableArray new];
    NSMutableArray *threeArray1 = [NSMutableArray new];
    NSMutableArray *fourArray1 = [NSMutableArray new];
    
    NSArray *FirstTitleArray = @[@"我的好友", @"同事", @"室友", @"好友", @"陌生人", @"高中同学", @"大学同学"];
    NSArray *SecondTitleArray = @[@"SecondTitle1", @"SecondTitle2", @"SecondTitle3"];
    NSArray *ThreeTitleArray = @[@"ThreeTitle1", @"ThreeTitle2", @"ThreeTitle3", @"ThreeTitle4"];
    NSArray *FourTitleArray = @[@"FourTitle1", @"FourTitle2", @"FourTitle3"];
    
    NSArray *imageArray = @[@"scroller1", @"scroller2", @"scroller3", @"scroller4", @"scroller5", @"scroller6", @"scroller7", @"scroller8", @"scroller9", @"scroller10"];
    
    //第四层数据
    for (int i = 0; i < FourTitleArray.count; i++) {
        CellModel *model = [[CellModel alloc] init];
        model.title = FourTitleArray[i];
        model.level = 3;
        model.isOpen = NO;
        
        [fourArray1 addObject:model];
    }
    
    //第三层数据
    for (int i = 0; i < ThreeTitleArray.count; i++) {
        CellModel *model = [[CellModel alloc] init];
        model.title = ThreeTitleArray[i];
        model.level = 2;
        model.isOpen = NO;
        model.detailArray = fourArray1;
        
        [threeArray1 addObject:model];
    }
    
    //第二层数据
    for (int i = 0; i < SecondTitleArray.count; i++) {
        CellModel *model = [[CellModel alloc] init];
        model.title = SecondTitleArray[i];
        model.level = 1;
        model.isOpen = NO;
//        model.detailArray = [threeArray1 mutableCopy];
        
        [secondArray1 addObject:model];
    }
    
    //第一层数据
    for (int i = 0; i < FirstTitleArray.count; i++) {
        CellModel *model = [[CellModel alloc] init];
        model.title = FirstTitleArray[i];
        model.level = 0;
        model.isOpen = NO;
        model.detailArray = [secondArray1 mutableCopy];
        model.imageName = imageArray[i];
        
        [_dataArray addObject:model];
    }
    
    //处理源数据，获得展示数组_resultArray
    [self dealWithDataArray:_dataArray];
}

/**
 将源数据数组处理成要展示的一维数组
 
 @param dataArray 源数据数组
 */
- (void)dealWithDataArray:(NSMutableArray *)dataArray {
    
    for (CellModel *model in dataArray) {
        [_resultArray addObject:model];
        
        if (model.isOpen && model.detailArray.count > 0) {
            [self dealWithDataArray:model.detailArray];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _resultArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    CellModel *model = _resultArray[row];
    
    if (model.level == 0) {
        return 44;
    }
    
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    CellModel *model = _resultArray[row];
    
    if (model.level == 0) {
        UITableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:@"title"];
        titleCell.accessoryType = UITableViewCellAccessoryNone;
        titleCell.textLabel.text = model.title;
        
        return titleCell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth / 2, 32)];
            label.font = [UIFont systemFontOfSize:14];
            label.tag = LabelTag;
            
            [cell.contentView addSubview:label];
        }
        
        for (UIView *view in cell.contentView.subviews) {
            if (view.tag == LabelTag) {
                ((UILabel *)view).text = model.title;
                ((UILabel *)view).frame = CGRectMake(15 + (model.level - 1) * SpaceWidth , 0, kScreenWidth / 2, 32);
            }
        }
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    
    CellModel *model = _resultArray[row];
    
    if (model.isOpen) {
        //原来是展开的，现在要收起,则删除model.detailArray存储的数据
        [self deleteObjectWithDataArray:model.detailArray count:0];
    }
    else {
        if (model.detailArray.count > 0) {
            //原来是收起的，现在要展开，则需要将同层次展开的收起，然后再展开
            [self compareSameLevelWithModel:model row:row];
        }
        else {
            //点击的是最后一层数据，跳转到别的界面
            NSLog(@"最后一层");
        }
    }
    
    model.isOpen = !model.isOpen;
    
    //滑动到屏幕顶部
    for (int i = 0; i < _resultArray.count; i++) {
        CellModel *openModel = _resultArray[i];
        
        if (openModel.isOpen && openModel.level == 0) {
            //将点击的cell滑动到屏幕顶部
            NSIndexPath *selectedPath = [NSIndexPath indexPathForRow:i inSection:0];
            [tableView scrollToRowAtIndexPath:selectedPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
    
    [tableView reloadData];
}

#pragma mark - 业务代码

/**
 与点击同一层的数据比较，然后删除要收起的数据和插入要展开的数据
 
 @param model 点击的cell对应的model
 @param row   点击的在tableview的indexPath.row,也对应_resultArray的下标
 */
- (void)compareSameLevelWithModel:(CellModel *)model row:(NSInteger)row {
    NSInteger count = 0;
    NSInteger index = 0;    //需要收起的起始位置
    NSMutableArray *copyArray = [_resultArray mutableCopy];
    
    for (int i = 0; i < copyArray.count; i++) {
        
        CellModel *openModel = copyArray[i];
        if (openModel.level == model.level) {
            //同一个层次的比较
            if (openModel.isOpen) {
                //删除openModel所有的下一层
                count = [self deleteObjectWithDataArray:openModel.detailArray count:count];
                index = i;
                openModel.isOpen = NO;
                break;
            }
        }
    }
    
    //插入的位置在删除的位置的后面，则需要减去删除的数量。
    if (row > index && row > count) {
        row -= count;
    }
    
    [self addObjectWithDataArray:model.detailArray row:row + 1];
}

/**
 在指定位置插入要展示的数据
 
 @param dataArray 数据
 @param row       需要插入的数组下标
 */
- (void)addObjectWithDataArray:(NSMutableArray *)dataArray row:(NSInteger)row {
    for (int i = 0; i < dataArray.count; i++) {
        CellModel *model = dataArray[i];
        model.isOpen = NO;
        
        [_resultArray insertObject:model atIndex:row];
        
        row += 1;
    }
}

/**
 删除要收起的数据
 
 @param dataArray 数据
 @param count     统计删除数据的个数
 
 @return 删除数据的个数
 */
- (CGFloat)deleteObjectWithDataArray:(NSMutableArray *)dataArray count:(NSInteger)count {
    for (CellModel *model in dataArray) {
        count += 1;
        
        if (model.isOpen && model.detailArray.count > 0) {
            count = [self deleteObjectWithDataArray:model.detailArray count:count];
        }
        
        model.isOpen = NO;
        
        [_resultArray removeObject:model];
    }
    
    return count;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
