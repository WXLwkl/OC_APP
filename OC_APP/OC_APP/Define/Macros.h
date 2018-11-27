//
//  Macros.h
//  OC_APP
//




/** 过期属性或方法名提醒 */
#define XLDeprecated(instead) __deprecated_msg(instead)


#pragma mark - 当前设备屏幕 宽/高/size/ 系统控件默认高度

#define kScreenWidth \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.width)
#define kScreenHeight \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.height)
#define kScreenSize \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale) : [UIScreen mainScreen].bounds.size)


//状态栏、导航栏、标签栏高度
#define kNavHeight              (kNavBarHeight + kStatusBarHeight)
#define kNavBarHeight           (44.f)
#define kStatusBarHeight        ([[UIApplication sharedApplication] statusBarFrame].size.height)

#define kTabBarHeight           (kBottomHeight + 49.f)
#define kBottomHeight           (IS_IPhoneX_All ? 34.f : 0.f)


#define kEnglishKeyboardHeight  (216.f)
#define kChineseKeyboardHeight  (252.f)


#pragma mark - 打印日志
/*!**!**!**!**!**!**!**!**!**!**!**!**!**!**!**!**!**!*/
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#define Log(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
//#define XLLog(FORMAT, ...) fprintf(stderr,"%s %s [Line %d] Log:%s \n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __PRETTY_FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#define XLLog(FORMAT, ...) fprintf(stderr,"%s [Line %d] Log:%s \n",__PRETTY_FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#define LogBool(value) NSLog(@"%@",value == YES ? @"YES" : @"NO");
#else
#define Log(...) nil
#define XLLog(...) nil
#define LogBool(value) nil
#endif


/*!**!**!**!**!**!**!**!**!**!**!**!**!**!**!**!**!**!*/


#pragma mark - 图片
//-----------图片-------------------
//读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]
//定义UIImage对象
#define IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]



#pragma mark - 颜色类

//背景色
#define BACKGROUND_COLOR ColorWithHex(0xefeff4)
//清除背景色
#define CLEARCOLOR [UIColor clearColor]
//主题颜色
#define THEME_color ColorWithHex(0x1FB5EC)


//-------------------------------------------------
// rgb颜色转换（16进制->10进制）
#define ColorWithHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

// 获取RGB颜色
#define RGBAColor(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGBColor(r,g,b) RGBAColor(r,g,b,1.0f)
#define RandomColor  RGBColor(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))



#pragma mark - 由角度获取弧度 有弧度获取角度
//由角度获取弧度 有弧度获取角度
//由角度转换弧度
#define DegreesToRadian(x)      (M_PI * (x) / 180.0)
//由弧度转换角度
#define RadianToDegrees(radian) (radian * 180.0) / (M_PI)


#pragma mark - 判空
//字符串是否为空
#define StringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
#define ArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define DictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
//是否是空对象
#define ObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))


#pragma mark - 一些缩写
//-----一些缩写--------
#define kApplication        [UIApplication sharedApplication]
#define kKeyWindow          [UIApplication sharedApplication].keyWindow
#define kAppDelegate        [AppDelegate shareAppDelegate]
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]

//--------------------------------------------------
#pragma mark - 系统相关
//APP版本号
#define AppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
//系统版本号
#define SystemVersion [[UIDevice currentDevice] systemVersion]
//获取当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])


#pragma mark - 判断当前的iPhone设备/系统版本
// 判断是否为iPhone
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
// 判断是否为iPad
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
// 判断是否为ipod
#define IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])
// 判断是否为 iPhone 4
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断是否为 iPhone 5/SE
#define iPhone5SE ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断是否为iPhone 6/6s
#define iPhone6_6s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断是否为iPhone 6Plus/6sPlus
#define iPhone6Plus_6sPlus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)

// 判断是否为iPhoneX
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPHoneXR
#define SCREENSIZE_IS_XR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !IS_IPAD : NO)
//判断iPHoneX、iPHoneXs
#define SCREENSIZE_IS_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !IS_IPAD : NO)
#define SCREENSIZE_IS_XS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !IS_IPAD : NO)
//判断iPhoneXs Max
#define SCREENSIZE_IS_XS_MAX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !IS_IPAD : NO)
// 判断所有 X 系列
#define IS_IPhoneX_All ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)



#define SCREENSIZE_IS_35  (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height < 568.0)
#define SCREENSIZE_IS_40  (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define SCREENSIZE_IS_47  (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define SCREENSIZE_IS_55  (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0 || [[UIScreen mainScreen] bounds].size.width == 736.0)





//6.0
#define IOS_Foundation_Before_6 IOS_Foundation_Before(NSFoundationVersionNumber_iOS_5_1)
#define IOS_Foundation_Later_6  IOS_Foundation_Later(NSFoundationVersionNumber_iOS_5_1)
//7.0
#define IOS_Foundation_Before_7 IOS_Foundation_Before(NSFoundationVersionNumber_iOS_6_1)
#define IOS_Foundation_Later_7  IOS_Foundation_Later(NSFoundationVersionNumber_iOS_6_1)
//8.0
#define IOS_Foundation_Before_8 IOS_Foundation_Before(NSFoundationVersionNumber_iOS_7_1)
#define IOS_Foundation_Later_8  IOS_Foundation_Later(NSFoundationVersionNumber_iOS_7_1)
//9.0
#define IOS_Foundation_Before_9 IOS_Foundation_Before(NSFoundationVersionNumber_iOS_8_x_Max)
#define IOS_Foundation_Later_9  IOS_Foundation_Later(NSFoundationVersionNumber_iOS_8_x_Max)
//10.0
#define IOS_Foundation_Before_10 IOS_Foundation_Before(NSFoundationVersionNumber_iOS_9_x_Max)
#define IOS_Foundation_Later_10  IOS_Foundation_Later(NSFoundationVersionNumber_iOS_9_x_Max)

#define IOS_Foundation_Before(VersionNumber) floor(NSFoundationVersionNumber) <= VersionNumber
#define IOS_Foundation_Later(VersionNumber)  floor(NSFoundationVersionNumber) > VersionNumber




#ifndef kSystemVersion
#define kSystemVersion [UIDevice systemVersion]
#endif

#ifndef kiOS6Later
#define kiOS6Later (kSystemVersion >= 6)
#endif

#ifndef kiOS7Later
#define kiOS7Later (kSystemVersion >= 7)
#endif

#ifndef kiOS8Later
#define kiOS8Later (kSystemVersion >= 8)
#endif

#ifndef kiOS9Later
#define kiOS9Later (kSystemVersion >= 9)
#endif







//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif


#pragma mark - bolck
#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };
// 宏定义之前的用法
// if (completionBlock)   {
//        completionBlock(arg1, arg2);
//      }
// 宏定义之后的用法
// BLOCK_EXEC(completionBlock, arg1, arg2);

#pragma mark - 路径
//获取沙盒Document路径
#define DocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒temp路径
#define TempPath NSTemporaryDirectory()
//获取沙盒Cache路径
#define CachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]



#pragma mark - 弱引用 or 强引用
//弱引用/强引用
#define WeakSelf(type)   __weak typeof(type) weak##type = type
#define StrongSelf(type) __strong typeof(type) type = weak##type

#pragma mark - 可判断一个方法的耗时
//获取一段时间间隔
#define StartTime CFAbsoluteTime start = CFAbsoluteTimeGetCurrent()
#define EndTime   NSLog(@"Time: %f", CFAbsoluteTimeGetCurrent() - start)





#pragma mark - GCD的宏定义
//GCD - 一次性执行
#define DISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);
//GCD - 在Main线程上运行
#define DISPATCH_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);
//GCD - 开启异步线程
#define DISPATCH_GLOBAL_QUEUE_DEFAULT(globalQueueBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlocl);

#pragma mark - NetworkActivityIndicator
// 显示加载
#define ShowNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
// 收起加载
#define HideNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO


#pragma mark - 单例类
/**
 *  在.h文件中定义的宏，arc
 *
 *  SingletonInterface(Class) 这个是宏
 *  + (instancetype)shared##Class;这个是被代替的方法， ##代表着shared+name 高度定制化
 * 在外边我们使用 SingletonInterface(Class) 那么在.h文件中，定义了一个方法"+ (instancetype)shared##Class",所以，第一个字母要大写
 *
 *  @return 一个搞定好的方法名
 */

#define SingletonInterface(Class) \
+ (instancetype)shared##Class;

/**
 *  在.m文件中处理好的宏 arc
 *
 *  SingletonImplementation(Class) 这个是宏,因为是多行的东西，所以每行后面都有一个"\",最后一行除外，
 * 之所以还要传递一个“Class”,是因为有个方法要命名"+ (instancetype)shared##Class"
 *  @return 单利
 */

//单例化一个类
//方法1，快速创建对象
//方法2.这个方法一定要有，就是alloc] init]方法，一定会调用这个方法
//此处还应该有一个+ copy方法，因为可能是copy，那么有可能是生成新的方法
#define SingletonImplementation(Class) \
static id instance_ = nil; \
+ (instancetype)shared##Class { \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        instance_ = [[self alloc] init]; \
    }); \
    return instance_; \
} \
+ (instancetype)allocWithZone:(struct _NSZone *)zone{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        instance_ = [super allocWithZone:zone]; \
    }); \
    return instance_; \
} \
- (id)copyWithZone:(NSZone *)zone{\
    return instance_;\
}





//--------------------------------------------------
#pragma mark - 其他

#pragma mark - 使用ARC or MRC
#if __has_feature(objc_arc)
// ARC
#else
// MRC
#endif
