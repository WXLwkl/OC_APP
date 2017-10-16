//
//  SearchResultsTableViewController.m
//  OC_APP
//
//  Created by xingl on 2017/10/13.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "SearchResultsTableViewController.h"
#import "GroupModel.h"

@interface SearchResultsTableViewController ()

@property (nonatomic, strong) NSMutableArray *searchResults;

//@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@end

@implementation SearchResultsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _searchResults = [[NSMutableArray alloc] init];
    [self setHidesBottomBarWhenPushed:NO];
    
    self.view.backgroundColor = [UIColor yellowColor];
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    
//    
//    return _statusBarStyle;
//}
////动态更新状态栏颜色
//-(void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
//    _statusBarStyle = statusBarStyle;
//    [self setNeedsStatusBarAppearanceUpdate];
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    
//    self.statusBarStyle = UIStatusBarStyleDefault;
//    
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
//}
//
//- (void) viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    
//    self.statusBarStyle = UIStatusBarStyleLightContent;
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"id";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    // cell ...
    
    NSLog(@"加载结果----");
    cell.textLabel.text = self.searchResults[indexPath.row][@"name"];
    cell.detailTextLabel.text = [@(indexPath.row) stringValue];
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"联系人";
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
   
    [self filterPredicateWithSearchString:searchController.searchBar.text];
    
    [self.tableView reloadData];
}

- (void)filterPredicateWithSearchString:(NSString *)string {
    
    if (XL_IsEmptyString(string)) {
        for (GroupModel *model in self.dataArray) {
            for (NSDictionary *dic in model.groupFriends) {
                [self.searchResults addObject:dic];
            }
        }
        
    } else {
        //        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [c] %@", string];
        //        self.results = [NSMutableArray arrayWithArray:[self.sectionData filteredArrayUsingPredicate:predicate]];
        if (self.searchResults.count > 0) {
            [self.searchResults removeAllObjects];
        }
        for (GroupModel *model in self.dataArray) {
            for (NSDictionary *dic in model.groupFriends) {
                
                if ([(NSString *)dic[@"name"] containsString:string]) {
                    
                    [self.searchResults addObject:dic];
                }
            }
        }
    }
    
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
