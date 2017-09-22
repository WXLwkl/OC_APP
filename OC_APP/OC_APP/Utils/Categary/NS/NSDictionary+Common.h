//
//  NSDictionary+Common.h
//  OC_APP
//
//  Created by xingl on 2017/8/15.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Common)

//dictionary转json字符串
- (NSString *)xl_getJSONStringForDictionary;

@end

#ifdef __cplusplus
extern "C" {
#endif
    BOOL XL_isEmptyDictionary(NSObject *obj);
#ifdef __cplusplus
}
#endif
