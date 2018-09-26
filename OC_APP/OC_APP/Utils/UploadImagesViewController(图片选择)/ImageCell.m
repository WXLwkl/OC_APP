//
//  ImageCell.m
//  OC_APP
//
//  Created by xingl on 2018/1/5.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "ImageCell.h"
#import <TZImagePickerController/TZImagePickerController.h>

#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation ImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.50];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        self.clipsToBounds = YES;

        _videoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamedFromMyBundle:@"MMVideoPreviewPlay"]];
        _videoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _videoImageView.hidden = YES;
        [self addSubview:_videoImageView];

        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"delete_image"] forState:UIControlStateNormal];
        _deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, -10);
        [self addSubview:_deleteBtn];

        _gifLable = [[UILabel alloc] init];
        _gifLable.text = @"GIF";
        _gifLable.textColor = [UIColor whiteColor];
        _gifLable.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        _gifLable.textAlignment = NSTextAlignmentCenter;
        _gifLable.font = [UIFont systemFontOfSize:10];
        [self addSubview:_gifLable];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
    _gifLable.frame = CGRectMake(self.xl_width - 25, self.xl_height - 14, 25, 14);
    _deleteBtn.frame = CGRectMake(self.xl_width - 36, 0, 36, 36);
    CGFloat width = self.xl_width / 3.0;
    _videoImageView.frame = CGRectMake(width, width, width, width);
}

- (void)setAsset:(id)asset {
    _asset = asset;
    if ([asset isKindOfClass:[PHAsset class]]) { //#import <Photos/Photos.h>
        PHAsset *phAsset = asset;
        _videoImageView.hidden = phAsset.mediaType != PHAssetMediaTypeVideo;
        _gifLable.hidden = ![[phAsset valueForKey:@"filename"] containsString:@"GIF"];
    } else if ([asset isKindOfClass:[ALAsset class]]) {
        ALAsset *alAsset = asset;
        _videoImageView.hidden = ![[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
        _gifLable.hidden = YES;
    }
}

-  (void)setRow:(NSInteger)row {
    _row = row;
    _deleteBtn.tag = row;
}

- (UIView *)snapshotView {
    UIView *snapshotView = [[UIView alloc] init];
    UIView *cellSnapshotView = nil;
    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]) {
        cellSnapshotView = [self snapshotViewAfterScreenUpdates:NO];
    } else {
        CGSize size = CGSizeMake(self.bounds.size.width + 20, self.bounds.size.height + 20);
        UIGraphicsBeginImageContextWithOptions(size, self.opaque, 0);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *cellSnapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cellSnapshotView = [[UIImageView alloc] initWithImage:cellSnapshotImage];
    }
    snapshotView.frame = CGRectMake(0, 0, cellSnapshotView.frame.size.width, cellSnapshotView.frame.size.height);
    cellSnapshotView.frame = CGRectMake(0, 0, cellSnapshotView.frame.size.width, cellSnapshotView.frame.size.height);
    [snapshotView addSubview:cellSnapshotView];
    return snapshotView;
}

@end
