//
//  RuntimeViewController.m
//  OC_APP
//
//  Created by xingl on 2018/5/28.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "RuntimeViewController.h"
#import "Person.h"

#import "NSObject+Model.h"
#import "User.h"


@interface RuntimeViewController ()

@end

@implementation RuntimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"runtime";
    [self xl_setNavBackItem];
    
    
    
//    [self test];
//    [self test1];
//    [self test2];
//    [self test3];
//    [self test4];
//    [self test5];
    [self test6];
}
/** 消息发送机制 */
- (void)test {
    Person *p = [[Person alloc] init];
    [p performSelector:@selector(eat:) withObject:@"汉堡"];
    
    // 需要在配置文件 settings 里面 搜索msg 设置为NO，因为苹果不建议直接这样
    
//    Person *p = objc_msgSend([Person class], @selector(alloc));
//    p = objc_msgSend(p, @selector(init));
//    objc_msgSend(p, @selector(eat:),"汉堡");
    
    // 系统c++
//    Person *person = ((Person *(*)(id, SEL))(void *)objc_msgSend)((id)((Person *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("Person"), sel_registerName("alloc")), sel_registerName("init"));
//    ((void (*)(id, SEL))(void *)objc_msgSend)((id)person, sel_registerName("run"));
    
    
    // 通过类名获取类
//    Class catClass = objc_getClass("Person");
    //注意Class实际上也是对象，所以同样能够接受消息，向Class发送alloc消息
//    Person *person = objc_msgSend(catClass, @selector(alloc));
    //发送init消息给Cat实例cat
//    person = objc_msgSend(person, @selector(init));
    //发送eat消息给cat，即调用eat方法
//    objc_msgSend(person, @selector(eat));
    //汇总消息传递过程
//    objc_msgSend(objc_msgSend(objc_msgSend(objc_getClass("Person"), sel_registerName("alloc")), sel_registerName("init")), sel_registerName("eat"));
    
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

/** 字典转Model */
- (void)test6 {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"model.json" ofType:nil];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
    
    User *user = [User xl_modelWithDict:json];
    Cat *cat = user.cat;
    
    Book *book = user.books[0];
    
    NSLog(@"fish--%@", cat.fish.name);
    NSLog(@"book--%@", book.name);
    NSLog(@"cat---%@", cat.name);
}

@end
