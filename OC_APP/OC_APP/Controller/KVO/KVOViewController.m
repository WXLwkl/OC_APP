//
//  KVOViewController.m
//  OC_APP
//
//  Created by xingl on 2018/5/14.
//  Copyright © 2018年 兴林. All rights reserved.
//

#import "KVOViewController.h"
#import "NSObject+xl_KVO.h"

#import "KVOObject.h"

@interface KVOViewController ()

@property (nonatomic, strong) UIView *colorView;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation KVOViewController

- (void)dealloc {
    [self.colorView xl_removeObserver:self.textLabel key:@"backgroundColor"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"KVO";
    
    [self.view addSubview:self.btn];
    [self.view addSubview:self.colorView];
    [self.view addSubview:self.textLabel];
    
    

    NSString *hVFL = @"H:|-50-[_btn]-50-|";
    NSArray *hCons = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(_btn)];
    [self.view addConstraints:hCons];
    NSString *vVFL = @"V:|-80-[_btn(100)]";
    NSArray *vCons = [NSLayoutConstraint constraintsWithVisualFormat:vVFL options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(_btn)];
    [self.view addConstraints:vCons];
    
    
    
    NSString *hsVFL = @"H:|-margin-[_textLabel]-margin-|";
    NSString *vsVFL = @"V:[_colorView(100)]-margin-[_textLabel(==_colorView)]-margin-|";
    NSDictionary *metrics = @{@"margin":@50};
    NSArray *hsCons = [NSLayoutConstraint constraintsWithVisualFormat:hsVFL options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:metrics views:NSDictionaryOfVariableBindings(_textLabel, _colorView)];
    NSArray *vsCons = [NSLayoutConstraint constraintsWithVisualFormat:vsVFL options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:metrics views:NSDictionaryOfVariableBindings(_textLabel, _colorView)];
    
    [self.view addConstraints:hsCons];
    [self.view addConstraints:vsCons];
    

    
    
    
    [self.colorView xl_addObserver:self.textLabel key:@"backgroundColor" callback:^(UILabel *observer, NSString *key, id oldValue, id newValue) {
        // 回到主线程刷新UI界面
        NSLog(@"%d", [NSThread isMainThread]);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // label上打印此时colorView上的RGBA值
            observer.text = [NSString stringWithFormat:@"currentBGColor = %@", newValue];
        });
    }];
    
}



- (void)loadKVOObject {
    
    KVOObject *obj = [[KVOObject alloc] init];
    obj.name = @"xl";
    
    Class cls = object_getClass(obj);
    NSString *isaInfo = [self printMethodNamesOfClass:cls];
    NSLog(@"\n\n添加 KVO 之前:\n%@", isaInfo);
    
    [obj addObserver:self forKeyPath:@"name" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
    
    obj.name = @"Coderxl";
    
    cls = object_getClass(obj);
    isaInfo = [self printMethodNamesOfClass:cls];
    NSLog(@"\n\n添加 KVO 之后:\n%@", isaInfo);
    
    [obj removeObserver:self forKeyPath:@"name"];
 
}

- (NSString *)printMethodNamesOfClass:(Class)cls {
    unsigned int count;
    // 获取方法数组
    Method *methodList = class_copyMethodList(cls, &count);
    
    // 存储方法名
    NSMutableString *methodNames = [NSMutableString string];
    
    // 遍历所有方法
    for (int i = 0; i < count; i++) {
        Method method = methodList[i];
        NSString *methodName = NSStringFromSelector(method_getName(method));
        [methodNames appendString:methodName];
        [methodNames appendString:@","];
    }
    free(methodList);
    return [NSString stringWithFormat:@"类名: %@ \n方法列表: %@", NSStringFromClass(cls), methodNames];
}


// KVO 的系统监听方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    //    NSLog(@"%@, %@, %@", keyPath, object, change);
}






- (void)changeColor {
//    self.colorView.backgroundColor = RandomColor;
    [self.colorView setValue:RandomColor forKey:@"backgroundColor"]; // kvc会触发kvo
    
//    [self.person1 setValue:@20 forKey:@"age"];
}


- (UIButton *)btn {
    if (!_btn) {
        _btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btn setTitle:@"Button 改变颜色" forState:(UIControlStateNormal)];
        [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btn setBackgroundColor:[UIColor yellowColor]];
        _btn.translatesAutoresizingMaskIntoConstraints = NO;
        [_btn addTarget:self action:@selector(changeColor) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _btn;
}

- (UIView *)colorView {
    if (!_colorView) {
        _colorView = [[UIView alloc] init];
        _colorView.translatesAutoresizingMaskIntoConstraints = NO;
        _colorView.backgroundColor = [UIColor redColor];
    };
    return _colorView;
}
- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor purpleColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.text = @"textLabel";
        _textLabel.numberOfLines = 0;
        _textLabel.lineBreakMode = NSLineBreakByTruncatingHead;
    }
    return _textLabel;
}
@end
