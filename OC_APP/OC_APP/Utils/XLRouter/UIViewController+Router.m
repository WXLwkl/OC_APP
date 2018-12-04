//
//  UIViewController+Router.m
//  OC_APP
//
//  Created by xingl on 2018/12/4.
//  Copyright © 2018 兴林. All rights reserved.
//

#import "UIViewController+Router.h"
#import <objc/runtime.h>

static char URLoriginUrl;
static char URLparams;
static char dataCallBack;

@implementation UIViewController (Router)

- (void)setOriginUrl:(NSURL *)originUrl {
    // 为分类设置属性值
    objc_setAssociatedObject(self, &URLoriginUrl,
                             originUrl,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSURL *)originUrl {
    // 获取分类的属性值
    return objc_getAssociatedObject(self, &URLoriginUrl);
}

- (NSDictionary *)params {
    return objc_getAssociatedObject(self, &URLparams);
}

- (void)setParams:(NSDictionary *)params{
    objc_setAssociatedObject(self, &URLparams,
                             params,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setValueBlock:(void (^)(id _Nonnull))valueBlock {
    objc_setAssociatedObject(self, &dataCallBack,
                             valueBlock,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(id _Nonnull))valueBlock {
    return objc_getAssociatedObject(self, &dataCallBack);
}

+ (UIViewController *)initFromString:(NSString *)urlString withQuery:(NSDictionary *)query {
    // 支持对中文字符的编码
    NSString *encodeStr = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [UIViewController initFromURL:[NSURL URLWithString:encodeStr] withQuery:query] ;
}

+ (UIViewController *)initFromURL:(NSURL *)url withQuery:(NSDictionary *)query {
    UIViewController *vc = nil;
    
    const char * name = [url.host cStringUsingEncoding:NSASCIIStringEncoding];
    
    // 从一个类名返回一个类
    Class newClass = objc_getClass(name);
    // 创建对象
    if (newClass == nil) return nil;
    vc = [[newClass alloc] init];
    
    if([vc respondsToSelector:@selector(open:withQuery:)]){
        [vc open:url withQuery:query];
    }
    return vc;
}

- (void)open:(NSURL *)url withQuery:(NSDictionary *)query{
    self.originUrl = url;
    if (query) {   // 如果自定义url后面有拼接参数,而且又通过query传入了参数,那么优先query传入了参数
        self.params = query;
    }else {
        self.params = [self paramsURL:url];
    }
}
//获取URL中的属性参数
- (NSDictionary *)paramsURL:(NSURL *)URL {
    
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    NSArray<NSURLQueryItem *> *queryItems = [[NSURLComponents alloc] initWithURL:URL resolvingAgainstBaseURL:false].queryItems;
    for (NSURLQueryItem *item in queryItems) {
        properties[item.name] = item.value;
    }
    return [properties copy];
}

@end
