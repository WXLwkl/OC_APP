//
//  TableViewDelegateConfig.m
//  OC_APP
//
//  Created by xingl on 2019/2/20.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "TableViewDelegateConfig.h"

@implementation TableViewDelegateConfig

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    NSLog(@"section:%ld, row:%ld", indexPath.section, indexPath.row);
}


@end
