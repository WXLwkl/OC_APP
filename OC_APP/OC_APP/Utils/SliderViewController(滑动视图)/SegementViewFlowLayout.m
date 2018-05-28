//
//  SegementViewFlowLayout.m
//  OC_APP
//
//  Created by xingl on 2018/5/25.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "SegementViewFlowLayout.h"

@implementation SegementViewFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    if (self.collectionView.bounds.size.height) {   
        self.itemSize = self.collectionView.bounds.size;
    }
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

@end
