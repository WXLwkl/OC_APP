//
//  XLProxyManager.h
//  OC_APP
//
//  Created by xingl on 2019/2/20.
//  Copyright © 2019 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLProxyManager : NSObject

@property (nonatomic, strong, readonly) NSPointerArray *targets;

- (void)addTarget:(id)target;
- (void)removeTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
