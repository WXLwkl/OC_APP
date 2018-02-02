//
//  ChatViewController.m
//  OC_APP
//
//  Created by xingl on 2017/8/22.
//  Copyright © 2017年 兴林. All rights reserved.
//

#define HEIGHT_TABBAR       49      // 就是chatBox的高度

#import "ChatViewController.h"
#import "ChatTwoViewController.h"

#import "ChatKeyBoard.h"

@interface ChatViewController ()<UITableViewDelegate, UITableViewDataSource, ChatKeyBoardDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, strong) ChatKeyBoard *keyBoard;

@end



@implementation ChatViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];


    [self initSubviews];
    [self loadData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.array.count -1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
}

- (void)initSubviews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"聊天";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem xl_itemTitle:@"评论" color:[UIColor whiteColor] target:self sel:@selector(rightAction:)];
    
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.keyBoard];
    
    [self.keyBoard addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if([keyPath isEqualToString:@"frame"]) {
        
        CGRect frame = [[change objectForKey:@"new"] CGRectValue];
        self.tableView.frame = CGRectMake(0, 0, kScreenWidth, frame.origin.y);
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.array.count -1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    }
}
- (void)rightAction:(UIBarButtonItem *)item {
    
    ChatTwoViewController *vc = [[ChatTwoViewController alloc] initWithNibName:NSStringFromClass([ChatTwoViewController class]) bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)btnClick {
    StartTime;
    [self.keyBoard beginComment];
    EndTime;
}

- (void)loadData {
    
    self.array = [NSMutableArray array];
    for (int i = 0; i < 19; i++) {
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"情开一朵，爱难临摹 ==> %d", i]];
        [self.array addObject:string];
    }
    [self.tableView reloadData];
}


#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"id";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    // cell ...
    cell.textLabel.attributedText = self.array[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}






#pragma mark - getter && setter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - HEIGHT_TABBAR) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
    
}
- (ChatKeyBoard *)keyBoard {
    if (!_keyBoard) {
        _keyBoard = [ChatKeyBoard keyBoardWithNavgationBarTranslucent:NO];
        _keyBoard.delegate = self;
        _keyBoard.placeHolder = @"聊天";
    }
    return _keyBoard;
}

@end
