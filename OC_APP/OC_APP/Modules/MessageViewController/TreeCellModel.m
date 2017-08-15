//
//  TreeCellModel.m
//  OC_APP
//
//  Created by xingl on 2017/8/15.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "TreeCellModel.h"

@implementation TreeCellModel

+ (instancetype)modelWithDic:(NSDictionary *)dic {
    TreeCellModel *model = [[TreeCellModel alloc] init];
    model.text = dic[@"text"];
    model.level = dic[@"level"];
    model.belowCount = 0;
    model.submodels = [NSMutableArray new];
    NSArray *submodels = dic[@"submodels"];
    for (int i = 0; i < submodels.count; i++) {
        TreeCellModel *subModel = [TreeCellModel modelWithDic:submodels[i]];
        subModel.supermodel = model;
        [model.submodels addObject:subModel];
    }
    return model;
}
- (NSArray *)open {
    NSArray *submodels = self.submodels;
    self.submodels = nil;
    self.belowCount = submodels.count;
    return submodels;
}
- (void)closeWithSubModels:(NSArray *)submodels {
    self.submodels = [NSMutableArray arrayWithArray:submodels];
    self.belowCount = 0;
}
- (void)setBelowCount:(NSUInteger)belowCount {
    self.supermodel.belowCount += (belowCount - _belowCount);
    _belowCount = belowCount;
}

- (NSString *)description {
    
    return [self descriptionString];
}

- (NSString *)debugDescription {
    
    
    return [self descriptionString];
}


- (NSString *)descriptionString {
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    unsigned int count;
    
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        
        objc_property_t property = properties[i];
        
        NSString *proName = @(property_getName(property));
        
        id value = [self valueForKey:proName]?:@"nil";
        
        [dictionary setObject:value forKey:proName];
        
    }
    
    free(properties);
    
    return [NSString stringWithFormat:@"<%@: %p> -- %@",[self class], self,dictionary];
}

@end
