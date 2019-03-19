//
//  TestModel.h
//  OC_APP
//
//  Created by xingl on 2019/2/27.
//  Copyright © 2019 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AA;
NS_ASSUME_NONNULL_BEGIN

@interface TestModel : NSObject

@property (nonatomic, strong)UIImage *iconImage;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) AA *user;

@end

@interface AA : NSObject

@property (nonatomic, copy) NSString *avatar_large;

@end


NS_ASSUME_NONNULL_END
