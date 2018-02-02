//
//  AdvertiseManager.m
//  OC_APP
//
//  Created by xingl on 2018/1/16.
//  Copyright © 2018年 兴林. All rights reserved.
//

NSString * const adImageName   = @"adImageName";
NSString * const adDownloadUrl = @"adDownloadUrl";
NSString * const pushToADUrl   = @"pushToADUrl";
NSString * const adType        = @"adTypeKey";


#import "AdvertiseManager.h"

#import "AdvertiseView.h"
#import "GuideView.h"

@implementation AdvertiseManager

+ (void)loadAdvertise {

    [[[self alloc] init] loadAdvertiseView];
}

- (void)loadAdvertiseView {

    NSString *currentVersion = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *LastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastVersion"];
    BOOL isEqueal = YES;
    if (![currentVersion isEqualToString:LastVersion]) {

        isEqueal = NO;
        [[NSUserDefaults standardUserDefaults] setValue:currentVersion forKey:@"LastVersion"];
    }

    if (!isEqueal) {
        NSLog(@"加载新手引导");
//        [self loadImageScollView];
        GuideView *v = [[GuideView alloc] initWithFrame:(CGRect){CGPointZero, kScreenSize}];
        [v show];
    } else {
        //1.判断沙盒中是否存在广告的图片名字和图片数据，如果有则显示
        NSString * imageName = [[NSUserDefaults standardUserDefaults] objectForKey:adImageName];
        if (imageName != nil) {

            NSString * filePath = [self getFilePathWithImageName:imageName];

            BOOL isExist = [self isFileExistWithFilePath:filePath];

            if (isExist) {

                NSString *typeStr = [[NSUserDefaults standardUserDefaults] objectForKey:adType];

                ADScreenType type = [typeStr isEqualToString:@"Full"] ? ADScreenTypeFull : ADScreenTypeLogo;

                AdvertiseView *advertiseView = [[AdvertiseView alloc] initWithFrame:kKeyWindow.bounds withADScreenType:type pushURLString:[[NSUserDefaults standardUserDefaults] objectForKey:pushToADUrl]];
                advertiseView.filePath = filePath;
                [advertiseView show];

            }
        }
    }
    //更新本地广告数据
    [self UpdateAdvertisementDataFromServer];
}



#pragma mark - *******************************************
#pragma mark - 要完善的方法   加上网络请求

- (void)UpdateAdvertisementDataFromServer {
    //TODO 在这里请求广告的数据，包含图片的图片路径和点击图片要跳转的URL


    //我们这里假设 图片的下载URl和跳转URl 广告图片大小 如下所示

    NSString *imageurl = @"http://pic.paopaoche.net/up/2012-2/20122220201612322865.png";
    NSString *pushtoURl = @"http://cn.bing.com/";
    NSString *adTypeStr = @"Full";


    //获取图片名
    NSString * imageName = [[imageurl componentsSeparatedByString:@"/"] lastObject];

    //将图片名与沙盒中的数据比较
    NSString * oldImageName =[[NSUserDefaults standardUserDefaults] objectForKey:adImageName];
    if ((oldImageName == nil) || (![oldImageName isEqualToString:imageName]) ) {
        //异步下载广告数据
        [self downloadADImageWithUrl:imageurl imageName:imageName];
        //保存跳转路径到沙盒中
        [[NSUserDefaults standardUserDefaults] setObject:pushtoURl forKey:pushToADUrl];
        [[NSUserDefaults standardUserDefaults] setObject:adTypeStr forKey:adType];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


#pragma mark - 帮助方法
- (NSString *)getFilePathWithImageName:(NSString *)imageName {
    if (imageName) {

        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        //图片默认存储在Cache目录下
        return [paths[0] stringByAppendingPathComponent:imageName];
    }
    return nil;

}

//判断该路径是否存在文件
- (BOOL)isFileExistWithFilePath:(NSString *) filePath
{
    NSFileManager * fileManager = [NSFileManager defaultManager];

    BOOL isDirectory = NO;

    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];

}

- (void)deleteOldImage {
    NSString * imageName = [[NSUserDefaults standardUserDefaults] objectForKey:adImageName];
    if (imageName) {

        NSString * filePath = [self getFilePathWithImageName:imageName];
        NSFileManager * fileManager = [NSFileManager defaultManager];
        if ([self isFileExistWithFilePath:filePath]) {

            [fileManager removeItemAtPath:filePath error:nil];
        }
    }
}


//异步下载广告图片
- (void)downloadADImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        //TODO 异步操作
        //1、下载数据
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage * image = [UIImage imageWithData:data];
        //2、获取保存文件的路径
        NSString * filePath = [self getFilePathWithImageName:imageName];
        //3、写入文件到沙盒中
        BOOL ret = [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
        if (ret) {
            NSLog(@"广告图片保存成功");

            [self deleteOldImage];

            //保存图片名和下载路径
            [[NSUserDefaults standardUserDefaults] setObject:imageName forKey:adImageName];
            [[NSUserDefaults standardUserDefaults] setObject:imageUrl forKey:adDownloadUrl];
            [[NSUserDefaults standardUserDefaults] synchronize];

        } else {
            NSLog(@"广告图片保存失败");
        }

    });
}

@end
