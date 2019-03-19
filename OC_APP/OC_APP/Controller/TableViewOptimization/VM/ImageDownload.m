//
//  ImageDownload.m
//  OC_APP
//
//  Created by xingl on 2019/2/27.
//  Copyright © 2019 兴林. All rights reserved.
//

#import "ImageDownload.h"

@implementation ImageDownload {
    NSURLSessionTask *_task;
}

- (void)loadImageWithModel:(TestModel *)model success:(loadImageSuccess)completion{
    
    NSURLSession *session = [NSURLSession sharedSession];
    _task = [session dataTaskWithURL:[NSURL URLWithString:model.user.avatar_large] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            model.iconImage = image;
            completion();
        }
        
    }];
    
    [_task resume];
}

- (void)cancelLoadImage{
    [_task cancel];
}


@end
