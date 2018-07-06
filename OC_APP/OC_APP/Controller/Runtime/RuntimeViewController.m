//
//  RuntimeViewController.m
//  OC_APP
//
//  Created by xingl on 2018/5/28.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "RuntimeViewController.h"
#import "Person.h"

@interface RuntimeViewController ()

@end

@implementation RuntimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"runtime";
    [self xl_setNavBackItem];
    
    
    [self test1];
//    [self test2];
//    [self test3];
//    [self test4];
//    [self test5];
}
/** 归档/解档 */
- (void)test1 {
    Person *person = [[Person alloc] init];
    person.name = @"林哥哥";
    person.sex = @"boy";
    person.age = 28;
    person.height = 176;
    person.job = @"iOS工程师";
    person.native = @"河南";
    person.education = @"本科";
        
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/archive.plist"];
    
    [NSKeyedArchiver archiveRootObject:person toFile:path];
    
    
    Person *unarchiverPerson = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSLog(@"unarchiverPerson == %@ %@",path,unarchiverPerson);
}
/** 获取一个类的全部成员变量名 */
- (void)test2 {
    unsigned int count;
    // 获取成员变量的结构体
    Ivar *ivars = class_copyIvarList([Person class], &count);
    for (NSInteger i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        // 根据ivar获取其成员变量的名称
        const char *name = ivar_getName(ivar);
        
        NSString *key = [NSString stringWithUTF8String:name];
        NSLog(@"%ld == %@", (long)i, key);
    }
    free(ivars);
}
/** 获取一个类的全部属性名 */
- (void)test3 {
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([Person class], &count);
    for (NSInteger i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *key = [NSString stringWithUTF8String:name];
        NSLog(@"%zd == %@", i, key);
    }
    free(properties);
}
/** 获取一个类的全部方法 */
- (void)test4 {
    unsigned int count;
    
    Method *methods = class_copyMethodList([Person class], &count);
    
    for (NSInteger i = 0; i < count; i++) {
        Method method = methods[i];
        SEL methodSEL = method_getName(method);
        const char *name = sel_getName(methodSEL);
        NSString *methodName = [NSString stringWithUTF8String:name];
        
        // 获取方法参数个数
        int arguments = method_getNumberOfArguments(method);
        NSLog(@"%zd == %@ %d", i, methodName, arguments);
    }
    free(methods);
}
/** 获取一个类遵循的全部协议 */
- (void)test5 {
    unsigned int count;
    
    // 获取指向该类遵循的所有协议的指针
    __unsafe_unretained Protocol **protocols = class_copyProtocolList([Person class], &count);
    for (NSInteger i = 0; i < count; i++) {
        Protocol *protocol = protocols[i];
        const char *name = protocol_getName(protocol);
        NSString *protocolName = [NSString stringWithUTF8String:name];
        NSLog(@"%zd == %@", i, protocolName);
    }
    free(protocols);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
