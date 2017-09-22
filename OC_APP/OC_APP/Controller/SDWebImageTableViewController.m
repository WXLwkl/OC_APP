//
//  SDWebImageTableViewController.m
//  OC_APP
//
//  Created by xingl on 2017/8/21.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "SDWebImageTableViewController.h"
#import <UIImageView+WebCache.h>
#import <UIView+WebCache.h>

@interface SDWebImageTableViewController ()

@property(nonatomic,copy)NSArray *imageUrlArr;
@property (strong, nonatomic) NSValue *targetRect; //定义一个当前屏幕显示的范围

@end

@implementation SDWebImageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self initSubviews];
}
- (void)initSubviews {
    self.navigationItem.title = @"只加载显示Cell的Image图(OK)";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ID"];
    [self.tableView setTableFooterView:[UIView new]];
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

    return self.imageUrlArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID" forIndexPath:indexPath];
    cell.accessoryType    = UITableViewCellAccessoryDisclosureIndicator;
    [self setupCell:cell withIndexPath:indexPath];
    return cell;
}

#pragma mark 自定义代码

- (void)setupCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath {
    
    NSURL *targetURL = [NSURL URLWithString:self.imageUrlArr[indexPath.row]];
    
    if (![[cell.imageView sd_imageURL] isEqual:targetURL]) {
        
        cell.imageView.alpha = 0.0;
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        BOOL shouldLoadImage = YES;
        CGRect cellFrame = [self.tableView rectForRowAtIndexPath:indexPath];
        
        //判断显示的当前屏幕范围内
        if (self.targetRect && !CGRectIntersectsRect([self.targetRect CGRectValue], cellFrame)) {
            //如果不在范围内，接着判断是否有缓存
            SDImageCache *cache = [manager imageCache];
            NSString *key = [manager cacheKeyForURL:targetURL];
            //如果没有缓存，则设置shouldLoadImage = NO 因为没有缓存说明以前也没有下载过，就不去进行下面的加载操作
            if (![cache imageFromCacheForKey:key]) {
                shouldLoadImage = NO;
            }
        }
        //执行这个代码 要进入当前屏幕范围，或者以前已经在出现过且缓存过
        if (shouldLoadImage) {
            NSLog(@"我这时加载的图片是%ld",(long)indexPath.row);
            [cell.imageView sd_setImageWithURL:targetURL placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (!error && [imageURL isEqual:targetURL]) {
                    [UIView animateWithDuration:0.25 animations:^{
                        cell.imageView.alpha = 1.0;
                    }];
                }
            }];
        }
    }
}

- (void)loadImageForVisibleCells {
    NSArray *cells = [self.tableView visibleCells];
    for (UITableViewCell *cell in cells) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [self setupCell:cell withIndexPath:indexPath];
    }
}

#pragma mark - scrollDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.targetRect = nil;
    [self loadImageForVisibleCells];
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    CGRect targetRect = CGRectMake(targetContentOffset->x, targetContentOffset->y, scrollView.frame.size.width, scrollView.frame.size.height);
    self.targetRect = [NSValue valueWithCGRect:targetRect];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.targetRect = nil;
    [self loadImageForVisibleCells];
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

#pragma mark - getter && setter
- (NSArray *)imageUrlArr {
    if (!_imageUrlArr) {
        _imageUrlArr = @[
                        @"http://www.dabaoku.com/sucaidatu/dongwu/chongwujingling/953838.JPG",
                        @"http://img4.duitang.com/uploads/item/201507/30/20150730163204_A24MX.thumb.700_0.jpeg",
                        @"http://www.wallcoo.com/animal/Dogs_Summer_and_Winter/wallpapers/1920x1200/DogsB10_Lucy.jpg",
                        @"http://mvimg2.meitudata.com/56074c97d79468889.jpg",
                        @"http://www.dabaoku.com/sucaidatu/dongwu/chongwujingling/804838.JPG",
                        @"http://img3.duitang.com/uploads/item/201601/28/20160128230209_iSYUx.jpeg",
                        @"http://photo.iyaxin.com/attachement/jpg/site2/20120402/001966720af110e381132c.jpg",
                        @"http://a.hiphotos.baidu.com/zhidao/pic/item/f9dcd100baa1cd11aa2ca018bf12c8fcc3ce2d74.jpg",
                        @"http://img.pconline.com.cn/images/upload/upc/tx/photoblog/1112/28/c11/10084076_10084076_1325087736046.jpg",
                        @"http://g.hiphotos.baidu.com/zhidao/pic/item/738b4710b912c8fcc51b78bbf4039245d78821df.jpg",
                        @"http://www.wallcoo.com/animal/Pet-Miniature-Schnauzer/wallpapers/1280x1024/Miniature-Schnauzer-puppy-photo-83448_wallcoo.com.jpg",
                        @"http://img0.pclady.com.cn/pclady/1702/04/1664938_36613700_148.jpg",
                        @"http://t-1.tuzhan.com/64098acae587/c-2/l/2013/09/14/04/c4481aa3564c449f8793a13716419be1.jpg",
                        @"http://mvimg1.meitudata.com/5517f3b94c1ba116.jpg",
                        @"http://pic24.nipic.com/20121023/5692504_110554234175_2.jpg",
                        @"http://t1.niutuku.com/960/21/21-262743.jpg",
                        @"http://cdn.duitang.com/uploads/item/201508/14/20150814074658_xRSe5.thumb.700_0.jpeg",
                        @"http://www.wallcoo.com/animal/Dogs_Summer_and_Winter/wallpapers/1920x1200/DogsB10_Lucy.jpg",
                        @"http://mvimg2.meitudata.com/56074c97d79468889.jpg",
                        @"http://www.dabaoku.com/sucaidatu/dongwu/chongwujingling/804838.JPG",
                        @"http://img3.duitang.com/uploads/item/201601/28/20160128230209_iSYUx.jpeg",
                        @"http://photo.iyaxin.com/attachement/jpg/site2/20120402/001966720af110e381132c.jpg",
                        @"http://a.hiphotos.baidu.com/zhidao/pic/item/f9dcd100baa1cd11aa2ca018bf12c8fcc3ce2d74.jpg",
                        @"http://img.pconline.com.cn/images/upload/upc/tx/photoblog/1112/28/c11/10084076_10084076_1325087736046.jpg",
                        @"http://g.hiphotos.baidu.com/zhidao/pic/item/738b4710b912c8fcc51b78bbf4039245d78821df.jpg",
                        @"http://www.wallcoo.com/animal/Pet-Miniature-Schnauzer/wallpapers/1280x1024/Miniature-Schnauzer-puppy-photo-83448_wallcoo.com.jpg",
                        @"http://img0.pclady.com.cn/pclady/1702/04/1664938_36613700_148.jpg",
                        @"http://t-1.tuzhan.com/64098acae587/c-2/l/2013/09/14/04/c4481aa3564c449f8793a13716419be1.jpg",
                        @"http://mvimg1.meitudata.com/5517f3b94c1ba116.jpg",
                        @"http://pic24.nipic.com/20121023/5692504_110554234175_2.jpg",
                        @"http://t1.niutuku.com/960/21/21-262743.jpg",
                        @"http://cdn.duitang.com/uploads/item/201508/14/20150814074658_xRSe5.thumb.700_0.jpeg"];
    }
    return _imageUrlArr;
}

@end
