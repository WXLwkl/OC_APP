//
//  ContactsViewController.m
//  OC_APP
//
//  Created by xingl on 2017/6/7.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "ContactsViewController.h"

#import "GroupModel.h"

#import "TreeViewController.h"

@interface ContactsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sectionData;
@end

@implementation ContactsViewController

#pragma mark - get
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style: UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor xl_colorWithHexString:@"#F7F7F9"];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 14, 0);
//        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubViews];
    
    [self loadData];
    
}
- (void)initSubViews {
    
    self.navigationItem.title = @"仿QQ联系人";
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"多级cell" style:(UIBarButtonItemStylePlain) target:self action:@selector(treeAction)];
}
- (void)treeAction {
    
    TreeViewController *vc = [[TreeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)loadData {
    
    NSArray *sectionOne = @[
                            @{@"groupName":@"手机通讯录",
                              @"groupCount":@"0",
                              @"groupArray":@[]
                              },
                            @{
                                @"groupName":@"我的设备",
                                @"groupCount":@"3",
                                @"groupArray":@[
                                        @{@"name":@"我的电脑",
                                          @"avatarURL":@"",
                                          @"shuoshuo":@"无需数据线",
                                          @"status":@"1"},
                                        @{@"name":@"我的平板",
                                          @"avatarURL":@"",
                                          @"shuoshuo":@"轻松传文件到平板",
                                          @"status":@"1"},
                                        @{@"name":@"发现新设备",
                                          @"avatarURL":@"",
                                          @"shuoshuo":@"搜索附近设备，用QQ链接",
                                          @"status":@"1"
                                          }
                                        ]
                                },
                            ];
    _sectionData = [[NSMutableArray alloc]init];
    for (NSDictionary *groupInfoDic in sectionOne) {
        
        GroupModel *model = [[GroupModel alloc]init];
        model.groupName = groupInfoDic[@"groupName"];
        model.groupCount = [groupInfoDic[@"groupCount"] integerValue];
        model.isOpened = NO;
        model.groupFriends = groupInfoDic[@"groupArray"];
        
        [_sectionData addObject:model];
    }
    NSDictionary *JSONDic =@{
                             @"group":
                                 @[
                                     @{@"groupName":@"小学同学",
                                       @"groupCount":@"3",
                                       @"groupArray":@[
                                               @{@"name":@"狗腿子",
                                                 @"avatarURL":@"",
                                                 @"shuoshuo":@"作业又没写好,唉！",
                                                 @"status":@"1"},
                                               @{@"name":@"大宝",
                                                 @"avatarURL":@"",
                                                 @"shuoshuo":@"考试不要抄我的！",
                                                 @"status":@"1"},
                                               @{@"name":@"Zws",
                                                 @"avatarURL":@"",
                                                 @"shuoshuo":@"马勒戈壁有本事放学别走！",
                                                 @"status":@"0"}
                                               ]
                                       },
                                     @{@"groupName":@"初中同学",
                                       @"groupCount":@"5",
                                       @"groupArray":
                                           @[
                                               @{@"name":@"李铁球",
                                                 @"avatarURL":@"",
                                                 @"shuoshuo":@"我家来自农村，不要欺负我",
                                                 @"status":@"1"},
                                               @{@"name":@"王麻子",
                                                 @"avatarURL":@"",
                                                 @"shuoshuo":@"历史咯老师真漂亮！",
                                                 @"status":@"1"},
                                               @{@"name":@"吴道德",
                                                 @"avatarURL":@"",
                                                 @"shuoshuo":@"我姓吴，法号道德",
                                                 @"status":@"1"},
                                               @{@"name":@"张丝丹",
                                                 @"avatarURL":@"",
                                                 @"shuoshuo":@"我小名叫四蛋子，哈哈",
                                                 @"status":@"0"},
                                               @{@"name":@"赵铁柱",
                                                 @"avatarURL":@"",
                                                 @"shuoshuo":@"我喜欢小花",
                                                 @"status":@"0"}
                                               ]
                                       },
                                     @{@"groupName":@"高中同学",
                                       @"groupCount":@"3",
                                       @"groupArray":
                                           @[
                                               @{@"name":@"刘阿猫",
                                                 @"avatarURL":@"",
                                                 @"shuoshuo":@"我操，高考又到了",
                                                 @"status":@"1"},
                                               @{@"name":@"静静",
                                                 @"avatarURL":@"",
                                                 @"shuoshuo":@"大家好，我是静静。",
                                                 @"status":@"1"},
                                               @{@"name":@"隔壁老王",
                                                 @"avatarURL":@"",
                                                 @"shuoshuo":@"小样你是新来的吧！",
                                                 @"status":@"0"}
                                               ]
                                       },
                                     @{@"groupName":@"大学同学",
                                       @"groupCount":@"4",
                                       @"groupArray":
                                           @[
                                               @{@"name":@"屌丝男",
                                                 @"avatarURL":@"",
                                                 @"shuoshuo":@"泡妞去了，回聊。",
                                                 @"status":@"1"},
                                               @{@"name":@"游戏狗",
                                                 @"avatarURL":@"",
                                                 @"shuoshuo":@"我擦，双杀！！",
                                                 @"status":@"1"},
                                               @{@"name":@"学霸",
                                                 @"avatarURL":@"",
                                                 @"shuoshuo":@"期末考试稳拿第一",
                                                 @"status":@"1"},
                                               @{@"name":@"书呆子",
                                                 @"avatarURL":@"",
                                                 @"shuoshuo":@"蛋白质是怎么炼成的。。。",
                                                 @"status":@"0"}
                                               ]
                                       },
                                     @{@"groupName":@"同事",
                                       @"groupCount":@"3",
                                       @"groupArray":
                                           @[
                                               @{@"name":@"JAVA工程师",
                                                 @"avatarURL":@"",
                                                 @"shuoshuo":@"JAVA是最好的编程语言",
                                                 @"status":@"1"},
                                               @{@"name":@"Android工程师",
                                                 @"avatarURL":@"",
                                                 @"shuoshuo":@"Android最好用，便宜耐摔！",
                                                 @"status":@"1"},
                                               @{@"name":@"iOS工程师",
                                                 @"avatarURL":@"",
                                                 @"shuoshuo":@"iPhone手机牛逼又流畅。",
                                                 @"status":@"0"}
                                               ]
                                       },
                                     @{@"groupName":@"家人",
                                       @"groupCount":@"3",
                                       @"groupArray":
                                           @[
                                               @{@"name":@"妈妈",
                                                 @"avatarURL":@"",
                                                 @"shuoshuo":@"今天天气好晴朗☀️，处处好风光",
                                                 @"status":@"1"},
                                               @{@"name":@"爸爸",
                                                 @"avatarURL":@"",
                                                 @"shuoshuo":@"我的儿子是个帅B！",
                                                 @"status":@"1"},
                                               @{@"name":@"姐姐",
                                                 @"avatarURL":@"",
                                                 @"shuoshuo":@"唱歌跳舞样样精通。",
                                                 @"status":@"0"}
                                               ]
                                       },
                                     @{@"groupName":@"Love",
                                       @"groupCount":@"1",
                                       @"groupArray":
                                           @[
                                               @{@"name":@"宝贝",
                                                 @"avatarURL":@"",
                                                 @"shuoshuo":@"稳稳地幸福",
                                                 @"status":@"1"}
                                               ]
                                       }
                                     ]
                             };
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSDictionary *groupInfoDic in JSONDic[@"group"]) {
        GroupModel *model = [[GroupModel alloc]init];
        model.groupName = groupInfoDic[@"groupName"];
        model.groupCount = [groupInfoDic[@"groupCount"] integerValue];
        model.isOpened = NO;
        model.groupFriends = groupInfoDic[@"groupArray"];
        
        [arr addObject:model];
        
        
        //        CommodityModel * commodity = [[CommodityModel alloc] init];
        //        [commodity setValuesForKeysWithDictionary:dic];
        //        [mutableArr addObject:commodity];
    }
    [self.sectionData addObjectsFromArray:arr];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.sectionData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    GroupModel *groupModel = _sectionData[section];
    NSInteger count = groupModel.isOpened ? groupModel.groupFriends.count : 0;
    return count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"id";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    // cell ...
    
    GroupModel *model = self.sectionData[indexPath.section];
    NSDictionary *friendInfoDic = model.groupFriends[indexPath.row];
    
    NSString *status = nil;
    if ([friendInfoDic[@"status"] isEqualToString:@"1"]) {
//        stateLabel.textColor = [UIColor greenColor];
        status = @"在线";
    }else{
//        stateLabel.textColor = [UIColor lightGrayColor];
        status = @"不在线";
    }
    cell.imageView.image = [UIImage imageNamed:@"User"];
    cell.textLabel.text = friendInfoDic[@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"[%@]%@", status, friendInfoDic[@"shuoshuo"]];
    
    
    UILabel *sub = [[UILabel alloc] init];
    sub.text = @"4G";
    [sub sizeToFit];
    cell.accessoryView = sub;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    GroupModel *groupModel = self.sectionData[section];
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(self.view.bounds), 50)];
    sectionView.tag = 1000 + section;
    sectionView.backgroundColor = [UIColor whiteColor];
    {
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionTaped:)];
        [sectionView addGestureRecognizer:recognizer];
    }
    {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(self.view.bounds), 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        line.alpha = 0.5f;
        [sectionView addSubview:line];
    }
    {
        UIImageView *tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 20, 8, 10)];
        tipImageView.image = [UIImage imageNamed:@"tip"];
        tipImageView.tag = 10;
        [sectionView addSubview:tipImageView];
        [self doTipImageView:tipImageView expand: groupModel.isOpened/*subNode.expand*/];
    }
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 200, 30)];
        label.font = [UIFont systemFontOfSize:17.0f];
        label.tag = 20;
        label.text = groupModel.groupName;
        [sectionView addSubview:label];
    }
    {
        UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-40, (44-20)/2, 40, 20)];
        [numberLabel setBackgroundColor:[UIColor clearColor]];
        [numberLabel setFont:[UIFont systemFontOfSize:14]];
        NSInteger onLineCount = 0;
        for (NSDictionary *friendInfoDic in groupModel.groupFriends) {
            if ([friendInfoDic[@"status"] isEqualToString:@"1"]) {
                onLineCount++;
            }
        }
        [numberLabel setText:[NSString stringWithFormat:@"%ld/%ld",(long)onLineCount,(long)groupModel.groupCount]];
        [sectionView addSubview:numberLabel];

    }
    return sectionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    CGFLOAT_MIN
    return section == 1 ? 20 : 0;
}


#pragma mark Action
- (void)sectionTaped:(UIGestureRecognizer *) recognizer {
    UIView *view = recognizer.view;
    NSUInteger tag = view.tag - 1000;
    UIImageView *tipImageView = [view viewWithTag:10];

    GroupModel *groupModel = self.sectionData[tag];
    groupModel.isOpened = !groupModel.isOpened;
    [self doTipImageView:tipImageView expand:groupModel.isOpened];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:tag] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
}
- (void) doTipImageView:(UIImageView *)imageView expand:(BOOL) expand {
    
    [UIView animateWithDuration:0.2f animations:^{
        imageView.transform = (expand) ? CGAffineTransformMakeRotation(DegreesToRadian(90)) : CGAffineTransformIdentity;
    }];
}



@end
