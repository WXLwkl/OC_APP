//
//  XLPhotoLibraryManager.h
//  OC_APP
//
//  Created by xingl on 2018/6/27.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RequestAssetsLibraryAuthCompletion)(BOOL isAuth);
typedef void(^SavePhotoCompletionBlock)(UIImage *image, NSError *error);
typedef void(^SaveVideoCompletionBlock)(NSURL *videoUrl, NSError *error);

@interface XLPhotoLibraryManager : NSObject

/** 判断权限 */
+ (void)requestALAssetsLibraryAuthorizationWithCompletion:(RequestAssetsLibraryAuthCompletion) requestAssetsLibraryAuthCompletion;

///** 保存照片 */
//+ (void)savePhotoWithImage:(UIImage *)image andAssetCollectionName:(NSString *)assetCollectionName withCompletion:(SavePhotoCompletionBlock)savePhotoCompletionBlock;
//
///** 保存视频 */
//+ (void)saveVideoWithVideoUrl:(NSURL *)videoUrl andAssetCollectionName:(NSString *)assetCollectionName withCompletion:(SaveVideoCompletionBlock)saveVideoCompletionBlock;

@end
