//
//  ImageDownload.h
//  OC_APP
//
//  Created by xingl on 2019/2/27.
//  Copyright © 2019 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^loadImageSuccess)(void);

@interface ImageDownload : NSObject

//开始加载图片，下载完成回调
- (void)loadImageWithModel:(TestModel *)model success:(loadImageSuccess)completion;

//取消当前的图片下载操作
- (void)cancelLoadImage;
@end

NS_ASSUME_NONNULL_END
