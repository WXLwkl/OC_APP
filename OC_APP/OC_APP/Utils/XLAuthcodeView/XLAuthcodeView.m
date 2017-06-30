//
//  XLAuthcodeView.m
//  OC_APP
//
//  Created by xingl on 2017/6/23.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "XLAuthcodeView.h"

#define XLRandomColor [UIColor colorWithRed:arc4random() % 256 / 256.0 green:arc4random() % 256 / 256.0 blue:arc4random() % 256 / 256.0 alpha:1.0];

#define XLLineCount 4
#define XLLineWidth 1.3
#define XLFontSize [UIFont systemFontOfSize:arc4random()%5 + 20]

@implementation XLAuthcodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithRed:210/256.0 green:229/256.0 blue:254/256.0 alpha:1];
        [self getAuthcode];
    }
    return self;
    
    
}

- (void)getAuthcode
{
    _dataArray = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"G",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"q",@"w",@"e",@"r",@"t",@"y",@"u",@"i",@"o",@"p",@"a",@"s",@"d",@"f",@"g",@"h",@"j",@"k",@"l",@"z",@"x",@"c",@"v",@"b",@"n",@"m"];
    _authCodeStr = [[NSMutableString alloc] initWithCapacity:XLLineCount];
    
    // 选取需要个数的字符串, 拼接为验证码字符
    for (int i = 0; i < XLLineCount; i ++)
    {
        NSInteger index = arc4random()%(_dataArray.count - 1);
        NSString *tempStr = [_dataArray objectAtIndex:index];
        _authCodeStr = (NSMutableString *)[_authCodeStr stringByAppendingString:tempStr];
        
    }
}


#pragma mark 点击界面切换验证码

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self getAuthcode];   // 点击界面时重新生成验证码
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    NSString *text = [NSString stringWithFormat:@"%@",_authCodeStr];
    CGSize cSize = [@"A" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22]}];
    int height = rect.size.height - cSize.height;
    
    CGPoint point;
    
    // 依次绘制字符
    float pX,pY;
    for (int i = 0 ; i<text.length; i++)
    {
        pX =  rect.size.width/text.length *i +5;
        pY = height;
        point = CGPointMake(pX, pY);
        unichar c = [text characterAtIndex:i];
        NSString *textC = [NSString stringWithFormat:@"%C", c];
        
        [textC drawAtPoint:point withAttributes:@{NSFontAttributeName:XLFontSize}];
    }
    //调用drawRect：之前，系统会向栈中压入一个CGContextRef，调用UIGraphicsGetCurrentContext()会取栈顶的CGContextRef
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条宽度
    CGContextSetLineWidth(context, XLLineWidth);
    
    //绘制干扰线
    for (int i = 0; i < XLLineCount-1; i++)
    {
        UIColor *color = XLRandomColor;
        CGContextSetStrokeColorWithColor(context, color.CGColor);//设置线条填充色
        
        //设置线的起点
        pX = arc4random() % (int)rect.size.width;
        pY = arc4random() % (int)rect.size.height;
        CGContextMoveToPoint(context, pX, pY);
        //设置线终点
        pX = arc4random() % (int)rect.size.width;
        pY = arc4random() % (int)rect.size.height;
        CGContextAddLineToPoint(context, pX, pY);
        //画线
        CGContextStrokePath(context);
    }
}


@end
