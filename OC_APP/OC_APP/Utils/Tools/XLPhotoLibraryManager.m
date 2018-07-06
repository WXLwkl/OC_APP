//
//  XLPhotoLibraryManager.m
//  OC_APP
//
//  Created by xingl on 2018/6/27.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "XLPhotoLibraryManager.h"
#import <Photos/Photos.h>
//#import <AssetsLibrary/AssetsLibrary.h>

@implementation XLPhotoLibraryManager

+ (void)requestALAssetsLibraryAuthorizationWithCompletion:(RequestAssetsLibraryAuthCompletion)requestAssetsLibraryAuthCompletion {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status != PHAuthorizationStatusAuthorized) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status != PHAuthorizationStatusAuthorized) {
                if (requestAssetsLibraryAuthCompletion) requestAssetsLibraryAuthCompletion(NO);
            } else {
                requestAssetsLibraryAuthCompletion(YES);
            }
        }];
    }
}

//+ (void)savePhotoWithImage:(UIImage *)image andAssetCollectionName:(NSString *)assetCollectionName withCompletion:(SavePhotoCompletionBlock)savePhotoCompletionBlock {
//    if (assetCollectionName == nil) {
//        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//        assetCollectionName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
//        if (assetCollectionName == nil) {
//            assetCollectionName = @"视频相册";
//        }
//    }
//    __block NSString *blockAssetCollectionName = assetCollectionName;
//    __block UIImage *blockImage = image;
//    __block NSString *assetId = nil;
//    
//    PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
//    
//}

@end
