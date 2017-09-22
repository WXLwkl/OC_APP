//
//  AddressPickerView.m
//  OC_APP
//
//  Created by xingl on 2017/8/18.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "AddressPickerView.h"

@interface AddressPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic) UIWindow *rootWindow;

@end

//定义弹出高度
static const CGFloat kPickerViewHeight = 260;
static const CGFloat kTopViewHeight = 44;

@implementation AddressPickerView
{
    NSArray   *_provinces;
    NSArray   *_citys;
    NSArray   *_areas;
    
    NSString  *_currentProvince;  //当前省
    NSString  *_currentCity;      //当前市
    NSString  *_currentDistrict;  //当前区
    
    UIView        *_wholeView;
    UIView        *_topView;
    UIPickerView  *_pickerView;
}

+ (id)shareInstance {
    static AddressPickerView *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[AddressPickerView alloc] init];
    });
    
    return shareInstance;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        self.currentPickState = NO;
        
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenAddressPickView)];
        [self addGestureRecognizer:tap];
        
        [self loadData];
        [self initSubviews];
    }
    return self;
}

- (void)loadData {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"addressData" ofType:@"plist"];
    NSArray *data = [[NSArray array] initWithContentsOfFile:plistPath];
    
    _provinces = data;
    
    //第一省份对应的全部市
    _citys = [[_provinces objectAtIndex:0] objectForKey:@"cities"];
    // 第一个省份
    
    _currentProvince = [[_provinces objectAtIndex:0] objectForKey:@"state"];
    // 第一个省份对应的第一个市
    _currentCity = [[_citys objectAtIndex:0] objectForKey:@"city"];
    // 第一个省份对应的第一个市对应的第一个区
    _areas = [[_citys objectAtIndex:0] objectForKey:@"areas"];
    if (_areas.count > 0) {
        _currentDistrict = [_areas objectAtIndex:0];
    } else {
        _currentDistrict = @"";
    }
}
- (void)initSubviews {
    
    _wholeView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight + kPickerViewHeight)];
    _wholeView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_wholeView];
    
    // 头部按钮视图
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kTopViewHeight)];
    _topView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    [_wholeView addSubview:_topView];
    
    NSArray *buttonTitleArray = @[@"取消",@"确定"];
    for (int i = 0; i <buttonTitleArray.count ; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*(kScreenWidth-50), 0, 50, kTopViewHeight);
        [button setTitle:buttonTitleArray[i] forState:UIControlStateNormal];
        [_topView addSubview:button];
        
        button.tag = i;
        [button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // 初始化pickerView
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kTopViewHeight, kScreenWidth, kPickerViewHeight-kTopViewHeight)];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    [_wholeView addSubview:_pickerView];
}

- (void)showAddressPickView {
    [UIView animateWithDuration:0.3 animations:^{
         _wholeView.frame = CGRectMake(0, kScreenHeight-kPickerViewHeight, kScreenWidth, kPickerViewHeight);
         
     } completion:^(BOOL finished) {
         self.currentPickState=YES;
         self.rootWindow = [UIApplication sharedApplication].keyWindow;
         [self.rootWindow addSubview:self];
     }];
}

- (void)hiddenAddressPickView {
    [UIView animateWithDuration:0.3 animations:^{
         _wholeView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kPickerViewHeight);
     } completion:^(BOOL finished) {
         
         self.currentPickState=NO;
         [self removeFromSuperview];
     }];
}
- (void)buttonEvent:(UIButton *)sender {
    // 点击确定回调block
    if (sender.tag == 1) {
        if (_block) {
            _block(_currentProvince, _currentCity, _currentDistrict);
        }
    }
    
    [self hiddenAddressPickView];
}
#pragma mark - UIPickerViewDelegate && UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    switch (component) {
        case 0:
            return [_provinces count];
            break;
        case 1:
            return [_citys count];
            break;
        case 2:
            
            return [_areas count];
            break;
        default:
            return 0;
            break;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    switch (component) {
        case 0:
            return _provinces[row][@"state"];
            break;
        case 1:
            return _citys[row][@"city"];
            break;
        case 2:
            if ([_areas count] > 0) {
                return _areas[row];
                break;
            }
        default:
            return @"";
            break;
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    [pickerView selectRow:row inComponent:component animated:YES];
    switch (component) {
        case 0:
        {
            _citys = [_provinces objectAtIndex:row][@"cities"];
            [_pickerView reloadComponent:1];
            [_pickerView selectRow:0 inComponent:1 animated:YES];
            
            _areas = _citys[0][@"areas"];
            [_pickerView reloadComponent:2];
            [_pickerView selectRow:0 inComponent:2 animated:YES];
            
            _currentProvince = _provinces[row][@"state"];
            _currentCity = _citys[0][@"city"];
            if ([_areas count] > 0) {
                _currentDistrict = [_areas objectAtIndex:0];
            } else {
                _currentDistrict = @"";
            }
        }
            break;
        case 1:
        {
            _areas = _citys[row][@"areas"];
            [_pickerView reloadComponent:2];
            [_pickerView selectRow:0 inComponent:2 animated:YES];
            
            _currentCity = _citys[row][@"city"];
            if ([_areas count] > 0) {
                _currentDistrict = _areas[0];
            } else {
                _currentDistrict = @"";
            }
        }
            break;
        case 2:
        {
            if ([_areas count] > 0) {
                _currentDistrict = _areas[row];
            } else {
                _currentDistrict = @"";
            }
        }
            break;
        default:
            break;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *pickerLabel = (UILabel *)view;
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setFont:[UIFont systemFontOfSize:17]];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

#pragma mark 默认绑定设置

- (void)configDataProvince:(NSString *)provinceName City:(NSString *)cityName Town:(NSString *)townName {
    
    NSString *provinceStr = provinceName;
    NSString *cityStr = cityName;
    NSString *districtStr = townName;
    
    int oneColumn=0, twoColumn=0, threeColum=0;
    
    // 省份
    for (int i=0; i<_provinces.count; i++) {
        if ([provinceStr isEqualToString:[_provinces[i] objectForKey:@"state"]]) {
            oneColumn = i;
        }
    }
    
    // 用来记录是某个省下的所有市
    NSArray *tempArray = [_provinces[oneColumn] objectForKey:@"cities"];
    // 市
    for  (int j=0; j<[tempArray count]; j++) {
        if ([cityStr isEqualToString:[tempArray[j] objectForKey:@"city"]]) {
            twoColumn = j;
            break;
        }
    }
    
    // 区
    for (int k=0; k<[[tempArray[twoColumn] objectForKey:@"areas"] count]; k++) {
        if ([districtStr isEqualToString:[tempArray[twoColumn] objectForKey:@"areas"][k]]) {
            threeColum = k;
            break;
        }
    }
    
    [self pickerView:_pickerView didSelectRow:oneColumn inComponent:0];
    [self pickerView:_pickerView didSelectRow:twoColumn inComponent:1];
    [self pickerView:_pickerView didSelectRow:threeColum inComponent:2];
}

@end
