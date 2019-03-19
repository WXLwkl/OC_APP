//
//  ListVM.m
//  OC_APP
//
//  Created by xingl on 2019/2/27.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "ListVM.h"
#import "TestModel.h"
#import "RequestManager.h"
#import <MJExtension/NSObject+MJKeyValue.h>
@implementation ListVM

- (void)fetchDataSuccess:(successBlock)block {
    //新浪微博API
    NSString *urlStr = @"https://api.weibo.com/2/statuses/public_timeline.json?access_token=2.00xo2AIClMprWC3c9e06af90JEgXHE";
    
    [RequestManager GET:urlStr isNeedCache:NO parameters:nil successBlock:^(id response) {
        
        NSArray *tempDatas = response[@"statuses"];
        NSMutableArray *json = @[].mutableCopy;
        [json addObjectsFromArray:tempDatas];
        [json addObjectsFromArray:tempDatas];
        [json addObjectsFromArray:tempDatas];
        [json addObjectsFromArray:tempDatas];
        [json addObjectsFromArray:tempDatas];
        
        NSArray *datas = [TestModel mj_objectArrayWithKeyValuesArray:json];
        
        self.datas = datas;
        
        NSLog(@"datas=%@", datas);
        
        block();
    } failureBlock:^(NSError *error) {
        NSLog(@"----error:%@", error.localizedDescription);
    }];
    
    
//    [[AFHTTPSessionManager manager] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
    
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error");
//    }];
    
}


@end
